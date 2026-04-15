import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../ai/ai_screen.dart';
import '../home/home_screen.dart';

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
    'кувырок задом',
  ];

  static const List<String> _trainingTopics = [
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

  void _openTopic(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainingTopicPlaceholderScreen(title: title),
      ),
    );
  }

  void _goToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const accent = Color(0xFF283593);
    const mint = Color(0xFFDDF3F2);
    const border = Color(0xFFF0D3CD);
    const textDark = Color(0xFF2F333A);

    final items = _selectedTab == _TrainingTab.commands
        ? _commands
        : _trainingTopics;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _goToHomePage,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_rounded,
                        color: accent,
                        size: 34,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'на главный экран',
                        style: AppTextStyles.caption.copyWith(
                          color: accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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
                  color: accent,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: _openAiChat,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: mint,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.pets_rounded,
                          size: 38,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 14),
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
                            const SizedBox(height: 10),
                            Text(
                              'Что хотите найти?',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 17,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Например: как научить команде кувырок?',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 15,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TrainingToggleButton(
                        label: 'команды',
                        isSelected: _selectedTab == _TrainingTab.commands,
                        onTap: () {
                          setState(() {
                            _selectedTab = _TrainingTab.commands;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: border,
                    ),
                    Expanded(
                      child: _TrainingToggleButton(
                        label: 'дрессировка',
                        isSelected: _selectedTab == _TrainingTab.training,
                        onTap: () {
                          setState(() {
                            _selectedTab = _TrainingTab.training;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _TrainingTopicButton(
                    title: item,
                    onTap: () => _openTopic(item),
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

class _TrainingToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TrainingToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE4F5D9) : Colors.transparent,
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
      ),
    );
  }
}

class _TrainingTopicButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TrainingTopicButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFF0D3CD)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFD8D8D8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainingTopicPlaceholderScreen extends StatelessWidget {
  final String title;

  const TrainingTopicPlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const accent = Color(0xFF283593);
    const textDark = Color(0xFF2F333A);
    const peach = Color(0xFFF1C9C2);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_back_rounded,
                      color: accent,
                      size: 34,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'назад',
                      style: AppTextStyles.caption.copyWith(
                        color: accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                style: AppTextStyles.title.copyWith(
                  color: accent,
                  fontSize: 30,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFF0D3CD)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: peach,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.article_outlined,
                        color: textDark,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Здесь позже появится статья или видео по этой теме.',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Каркас страницы уже готов, поэтому позже мы сможем спокойно подставить сюда контент без переделки навигации.',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 15,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
