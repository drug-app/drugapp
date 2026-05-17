import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../ai/ai_screen.dart';

enum _TrainingTab { commands, training }

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  static const List<String> _commands = [
    'сидеть',
    'лежать',
    'голос',
    'дай лапу',
    'место',
    'кувырок',
    'задом',
  ];

  static const List<String> _topics = [
    'как приучить щенка к пеленке',
    'как научить спать на лежанке',
    'как отучить грызть вещи',
    'как отучить кусать руки',
    'как научить оставаться дома',
    'как убрать агрессию на других собак',
    'как отучить попрошайничать со стола',
  ];

  _TrainingTab _selectedTab = _TrainingTab.commands;

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AiScreen(),
      ),
    );
  }

  void _openDetails(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainingArticleScreen(title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFEFFFB);
    const accent = Color(0xFF2F3D91);
    const mint = Color(0xFFD9F3F5);
    const border = Color(0xFFF1D7D1);

    final items = _selectedTab == _TrainingTab.commands ? _commands : _topics;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.undo_rounded,
                        size: 32,
                        color: accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'на главный экран',
                        style: AppTextStyles.caption.copyWith(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'дрессировка',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: accent,
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: _openAiChat,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.pets_rounded,
                          color: accent,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ХВОСТАТЫЙ ИИ помощник',
                              style: AppTextStyles.subtitle.copyWith(
                                color: accent,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '— что хотите найти?\n— как научить команде кувырок?',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 15,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TrainingTabButton(
                        label: 'команды',
                        selected: _selectedTab == _TrainingTab.commands,
                        onTap: () {
                          setState(() => _selectedTab = _TrainingTab.commands);
                        },
                      ),
                    ),
                    Expanded(
                      child: _TrainingTabButton(
                        label: 'дрессировка',
                        selected: _selectedTab == _TrainingTab.training,
                        onTap: () {
                          setState(() => _selectedTab = _TrainingTab.training);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TrainingListCard(
                    title: item,
                    onTap: () => _openDetails(item),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainingArticleScreen extends StatelessWidget {
  final String title;

  const TrainingArticleScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFEFFFB);
    const accent = Color(0xFF2F3D91);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.undo_rounded,
                      size: 32,
                      color: accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'назад',
                      style: AppTextStyles.caption.copyWith(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: AppTextStyles.title.copyWith(
                  fontSize: 30,
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  'Здесь будет подробная информация по теме "$title".\n\n'
                  'На следующем этапе мы добавим сюда твой реальный текст, видео, шаги обучения и полезные советы.',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainingTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TrainingTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDFF0D1) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TrainingListCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TrainingListCard({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1D7D1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFE3E3E3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF2F333A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
