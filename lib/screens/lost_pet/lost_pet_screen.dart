import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

class LostPetScreen extends StatelessWidget {
  const LostPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LostPetDraftScreen();
  }
}

class _LostPetDraftScreen extends StatelessWidget {
  const _LostPetDraftScreen();

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const accent = Color(0xFF2F333A);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LostPetTopBar(
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 22),
              Text(
                'ПОТЕРЯЛСЯ\nПИТОМЕЦ',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  color: accent,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Проверьте информацию\nи если нужно внесите\nизменения',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    height: 1.25,
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const _LostPetAnnouncementCard(),
              const SizedBox(height: 22),
              _LostPetMainButton(
                label: 'Готово',
                backgroundColor: const Color(0xFFE9E9E9),
                textColor: accent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const _LostPetReviewScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LostPetReviewScreen extends StatelessWidget {
  const _LostPetReviewScreen();

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LostPetTopBar(
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),
              const _LostPetAnnouncementCard(
                compact: true,
              ),
              const SizedBox(height: 28),
              _LostPetMainButton(
                label: 'Сообщить\nо пропаже',
                backgroundColor: const Color(0xFFFF5B5B),
                textColor: const Color(0xFF111111),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const _LostPetOwnerScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LostPetOwnerScreen extends StatefulWidget {
  const _LostPetOwnerScreen();

  @override
  State<_LostPetOwnerScreen> createState() => _LostPetOwnerScreenState();
}

class _LostPetOwnerScreenState extends State<_LostPetOwnerScreen> {
  bool _isFound = false;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const accent = Color(0xFF2F333A);
    const borderRed = Color(0xFFFF4B4B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LostPetTopBar(
                onBack: () => Navigator.pop(context),
                topLabel: 'экран хозяина',
              ),
              const SizedBox(height: 16),
              Text(
                'ПОТЕРЯШКИ',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  color: accent,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderRed,
                    width: 3,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _LostPetAnnouncementCard(
                      compact: true,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'статус',
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        _StatusChip(
                          label: 'активный поиск',
                          isSelected: !_isFound,
                          onTap: () {
                            setState(() {
                              _isFound = false;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        _StatusChip(
                          label: 'найден',
                          isSelected: _isFound,
                          onTap: () {
                            setState(() {
                              _isFound = true;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoActionTile(
                            title: '3',
                            subtitle: 'уведомления',
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: _InfoActionTile(
                            title: 'поделиться',
                            subtitle: 'скоро',
                          ),
                        ),
                      ],
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

class _LostPetTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final String? topLabel;

  const _LostPetTopBar({
    required this.onBack,
    this.topLabel,
  });

  @override
  Widget build(BuildContext context) {
    const backColor = Color(0xFFE1BF63);

    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_back_rounded,
                color: backColor,
                size: 34,
              ),
              if (topLabel != null) ...[
                const SizedBox(width: 6),
                Text(
                  topLabel!,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F333A),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        Text(
          'редактировать',
          style: AppTextStyles.caption.copyWith(
            fontSize: 13,
            color: const Color(0xFF2F333A),
          ),
        ),
      ],
    );
  }
}

class _LostPetAnnouncementCard extends StatelessWidget {
  final bool compact;

  const _LostPetAnnouncementCard({
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFFE4E4E4);
    const peach = Color(0xFFFFC0BF);
    const accent = Color(0xFF2F333A);
    const photoBg = Color(0xFFFFE3E3);

    return Container(
      padding: EdgeInsets.all(compact ? 18 : 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ВНИМАНИЕ!',
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: compact ? 28 : 30,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'потерялся друг',
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: compact ? 16 : 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: compact ? 138 : 148,
                  decoration: BoxDecoration(
                    color: photoBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.pets_rounded,
                        color: accent,
                        size: 34,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'фото',
                        style: AppTextStyles.subtitle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: peach,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'отметить\nна карте',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.button.copyWith(
                          fontSize: 18,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 16 : 18),
          Text(
            'Пропал корги по кличке Барни.\n'
            '📍 Район Патриаршие пруды\n'
            '🕐 Сегодня около 18:30\n'
            'Рыжий с белой грудкой и лапами, небольшой, 3 года.\n'
            'Без ошейника, может быть напуган, но не агрессивный.',
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              height: 1.35,
              color: accent,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '❗ Очень просим, если вы его увидели или нашли,\n'
            'напишите или позвоните\n'
            '📞 +7 999 123-45-67\n'
            '✉ Telegram: @username',
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              height: 1.35,
              color: accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '🙏 Будем благодарны за любую информацию',
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w500,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _LostPetMainButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _LostPetMainButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            height: 1.15,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFD5D5)
              : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _InfoActionTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoActionTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
