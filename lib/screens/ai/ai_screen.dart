import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _supabase = Supabase.instance.client;

  final List<Map<String, String>> _messages = [];
  final List<_ChatItem> _chats = [];

  bool _isInitializing = true;
  bool _isSending = false;
  bool _isLoadingChat = false;
  bool _isCreatingChat = false;

  String? _activeChatId;

  User? get _currentUser => _supabase.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _bootstrapChats();
  }

  Future<void> _bootstrapChats() async {
    try {
      if (_currentUser == null) {
        if (!mounted) return;
        setState(() => _isInitializing = false);
        return;
      }

      final chats = await _fetchChats();

      if (!mounted) return;

      setState(() {
        _chats
          ..clear()
          ..addAll(chats);
      });

      if (chats.isNotEmpty) {
        await _loadChat(chats.first.id, setLoadingState: false);
      }
    } catch (_) {
      if (!mounted) return;
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  Future<List<_ChatItem>> _fetchChats() async {
    final user = _currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('chats')
        .select('id, title, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response.map<_ChatItem>((chat) {
      return _ChatItem(
        id: chat['id'] as String,
        title: ((chat['title'] as String?) ?? '').trim(),
        createdAt: DateTime.tryParse(
              (chat['created_at'] as String?) ?? '',
            ) ??
            DateTime.now(),
      );
    }).toList();
  }

  Future<void> _refreshChats({String? keepChatId}) async {
    final chats = await _fetchChats();
    if (!mounted) return;

    setState(() {
      _chats
        ..clear()
        ..addAll(chats);
      if (keepChatId != null) {
        _activeChatId = keepChatId;
      } else if (_activeChatId != null &&
          chats.every((chat) => chat.id != _activeChatId)) {
        _activeChatId = chats.isEmpty ? null : chats.first.id;
      }
    });
  }

  Future<void> _loadChat(
    String chatId, {
    bool setLoadingState = true,
  }) async {
    if (setLoadingState && mounted) {
      setState(() => _isLoadingChat = true);
    }

    try {
      final response = await _supabase
          .from('messages')
          .select('role, content, created_at')
          .eq('chat_id', chatId)
          .order('created_at', ascending: true);

      if (!mounted) return;

      setState(() {
        _activeChatId = chatId;
        _messages
          ..clear()
          ..addAll(
            response.map<Map<String, String>>((message) {
              final role = ((message['role'] as String?) ?? '').toLowerCase();
              return {
                'role': role == 'assistant' ? 'assistant' : 'user',
                'text': ((message['content'] as String?) ?? '').trim(),
              };
            }).where((message) => message['text']!.isNotEmpty),
          );
      });

      _scrollToBottom();
    } finally {
      if (mounted) {
        setState(() => _isLoadingChat = false);
      }
    }
  }

  Future<void> _createNewChat() async {
    if (_isCreatingChat) return;

    final user = _currentUser;
    if (user == null) {
      _showSnackBar('Войдите в аккаунт, чтобы создавать чаты.');
      return;
    }

    setState(() => _isCreatingChat = true);

    try {
      final response = await _supabase
          .from('chats')
          .insert({
            'user_id': user.id,
            'title': 'Новый чат',
          })
          .select('id, title, created_at')
          .single();

      final chat = _ChatItem(
        id: response['id'] as String,
        title: ((response['title'] as String?) ?? 'Новый чат').trim(),
        createdAt: DateTime.tryParse(
              (response['created_at'] as String?) ?? '',
            ) ??
            DateTime.now(),
      );

      if (!mounted) return;

      setState(() {
        _activeChatId = chat.id;
        _messages.clear();
        _chats
          ..removeWhere((item) => item.id == chat.id)
          ..insert(0, chat);
      });

      Navigator.of(context).maybePop();
    } finally {
      if (mounted) {
        setState(() => _isCreatingChat = false);
      }
    }
  }

  Future<String?> _ensureActiveChat(String firstMessage) async {
    if (_activeChatId != null) return _activeChatId;
    await _createNewChat();
    return _activeChatId;
  }

  Future<void> _renameChatIfNeeded(String firstMessage) async {
    final chatId = _activeChatId;
    if (chatId == null) return;

    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex == -1) return;

    final currentTitle = _chats[chatIndex].title.trim();
    if (currentTitle.isNotEmpty && currentTitle != 'Новый чат') return;

    final title = firstMessage.length > 48
        ? '${firstMessage.substring(0, 48)}...'
        : firstMessage;

    await _supabase.from('chats').update({'title': title}).eq('id', chatId);

    if (!mounted) return;
    setState(() {
      _chats[chatIndex] = _chats[chatIndex].copyWith(title: title);
    });
  }

  Future<void> _saveMessage({
    required String role,
    required String text,
  }) async {
    final chatId = _activeChatId;
    if (chatId == null) return;

    await _supabase.from('messages').insert({
      'chat_id': chatId,
      'role': role,
      'content': text,
    });
  }

  Future<String> _fetchAiReply({
    required String text,
    required List<Map<String, String>> history,
  }) async {
    final response = await _supabase.functions.invoke(
      'ai-chat',
      body: {
        'message': text,
        'user_id': _currentUser?.id,
        'chat_id': _activeChatId,
        'petContext': 'У пользователя есть питомец.',
        'history': history
            .map(
              (message) => {
                'role': message['role'],
                'text': message['text'],
              },
            )
            .toList(),
      },
    );

    final data = response.data;
    if (data is Map && data['reply'] is String) {
      final reply = (data['reply'] as String).trim();
      if (reply.isNotEmpty) return reply;
    }

    throw Exception('Empty ai-chat reply');
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    FocusScope.of(context).unfocus();

    final historyForAi = List<Map<String, String>>.from(_messages)
        .map(
          (message) => {
            'role': message['role'] ?? 'user',
            'text': message['text'] ?? '',
          },
        )
        .toList();

    setState(() {
      _messages.add({
        'role': 'user',
        'text': text,
      });
      _controller.clear();
      _isSending = true;
    });
    _scrollToBottom();

    try {
      await _ensureActiveChat(text);
      await _renameChatIfNeeded(text);
      await _saveMessage(role: 'user', text: text);

      final reply = await _fetchAiReply(
        text: text,
        history: historyForAi,
      );

      if (!mounted) return;

      setState(() {
        _messages.add({
          'role': 'assistant',
          'text': reply,
        });
      });

      await _saveMessage(role: 'assistant', text: reply);
      await _refreshChats(keepChatId: _activeChatId);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'role': 'assistant',
          'text': 'Не удалось получить ответ. Попробуйте ещё раз.',
        });
      });
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 160,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatChatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final hh = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$dd.$mm • $hh:$min';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const textDark = Color(0xFF2F333A);
    const aiBg = Color(0xFFDDF3F2);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Чаты',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _isCreatingChat ? null : _createNewChat,
                      icon: const Icon(Icons.add_comment_rounded),
                      color: textDark,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isCreatingChat ? null : _createNewChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: aiBg,
                      foregroundColor: textDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      _isCreatingChat ? 'Создаю...' : 'Новый чат',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: _chats.isEmpty
                      ? const Center(
                          child: Text(
                            'Чатов пока нет',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _chats.length,
                          itemBuilder: (context, index) {
                            final chat = _chats[index];
                            final isActive = chat.id == _activeChatId;

                            return GestureDetector(
                              onTap: () async {
                                Navigator.of(context).maybePop();
                                await _loadChat(chat.id);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isActive ? aiBg : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.title.isEmpty
                                          ? 'Новый чат'
                                          : chat.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _formatChatDate(chat.createdAt),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 32,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'ХВОСТАТЫЙ ИИ ПОМОЩНИК',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isInitializing || _isLoadingChat
                  ? const Center(
                      child: CircularProgressIndicator(color: textDark),
                    )
                  : _messages.isEmpty
                      ? Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 22,
                            ),
                            decoration: BoxDecoration(
                              color: aiBg,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'ВАШ ХВОСТАТЫЙ ИИ ПОМОЩНИК',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                    height: 1.1,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Нажми "Новый чат" или просто начни писать. Я сохраню диалог и ты сможешь вернуться к нему позже.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textDark,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                          itemCount: _messages.length + (_isSending ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isSending && index == _messages.length) {
                              return const _MessageBubble(
                                text: 'Печатаю ответ...',
                                isUser: false,
                              );
                            }

                            final message = _messages[index];
                            return _MessageBubble(
                              text: message['text']!,
                              isUser: message['role'] == 'user',
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Как вам помочь?',
                          hintStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isSending ? Colors.black26 : textDark,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSending
                            ? Icons.hourglass_top_rounded
                            : Icons.arrow_upward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatItem {
  const _ChatItem({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;

  _ChatItem copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) {
    return _ChatItem(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF2F333A);
    const aiBg = Color(0xFFDDF3F2);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isUser ? aiBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isUser
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: textDark,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
