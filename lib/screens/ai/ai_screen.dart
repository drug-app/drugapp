import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  static const String _petContext = 'У пользователя собака, 7 месяцев.';

  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    final history = _messages
        .map(
          (message) => {
            'role': message['role'] == 'ai' ? 'assistant' : 'user',
            'text': message['text'] ?? '',
          },
        )
        .where((message) => (message['text'] ?? '').trim().isNotEmpty)
        .toList();

    setState(() {
      _messages.add({
        'role': 'user',
        'text': text,
      });
      _controller.clear();
      _isLoading = true;
    });

    try {
      final res = await Supabase.instance.client.functions.invoke(
        'ai-chat',
        body: {
          'message': text,
          'petContext': _petContext,
          'history': history,
        },
      );

      final data = res.data;
      String reply = 'Пока не удалось получить ответ.';

      if (data is Map && data['reply'] != null) {
        reply = data['reply'].toString();
      }

      if (!mounted) return;

      setState(() {
        _messages.add({
          'role': 'ai',
          'text': reply,
        });
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _messages.add({
          'role': 'ai',
          'text': 'Не удалось получить ответ. Попробуйте ещё раз.',
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const textDark = Color(0xFF2F333A);
    const aiBg = Color(0xFFDDF3F2);

    return Scaffold(
      backgroundColor: bg,
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
                ],
              ),
            ),
            Expanded(
              child: _messages.isEmpty
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
                              'Спроси что-нибудь\nпро питомца',
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
                              'Напишите вопрос — я помогу подобрать сервис,\nобъяснить что делать дальше или найти нужный раздел.',
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
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return const Align(
                            alignment: Alignment.centerLeft,
                            child: _MessageBubble(
                              text: 'Печатаю ответ...',
                              isUser: false,
                            ),
                          );
                        }

                        final message = _messages[index];
                        final isUser = message['role'] == 'user';

                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: _MessageBubble(
                            text: message['text'] ?? '',
                            isUser: isUser,
                          ),
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
                        color: _isLoading ? Colors.black26 : textDark,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isLoading
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

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _MessageBubble({
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    const userBg = Color(0xFFDDF3F2);
    const aiBg = Colors.white;
    const textDark = Color(0xFF2F333A);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: isUser ? userBg : aiBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isUser
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
    );
  }
}
