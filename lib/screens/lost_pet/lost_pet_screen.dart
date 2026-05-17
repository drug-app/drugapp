import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

class LostPetScreen extends StatelessWidget {
  const LostPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const draft = _LostPetData(
      petName: 'Барни',
      district: 'Патриаршие пруды',
      lostAt: 'Сегодня в 18:30',
      description:
          'Рыжий с белой грудкой бигль, небольшой, 3 года. Без ошейника, может быть напуган, но не агрессивен.',
      contactPhone: '+7 999 123-45-67',
      contactTelegram: '@usernname',
      rewardText: 'Будем благодарны за любую информацию',
    );

    return _LostPetScaffold(
      title: 'ПОТЕРЯЛСЯ\nПИТОМЕЦ',
      trailingText: 'редактировать',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'проверьте информацию\nи если нужно внесите\nизменения',
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                height: 1.25,
                color: const Color(0xFF2F333A).withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _LostPetPosterCard(data: draft),
          const SizedBox(height: 20),
          SizedBox(
            height: 58,
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _LostPetReviewScreen(data: draft),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE8E8E8),
                foregroundColor: const Color(0xFF2F333A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ГОТОВО',
                style: AppTextStyles.button.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LostPetReviewScreen extends StatelessWidget {
  final _LostPetData data;

  const _LostPetReviewScreen({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return _LostPetScaffold(
      title: 'ПОТЕРЯЛСЯ\nПИТОМЕЦ',
      trailingText: 'редактировать',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LostPetPosterCard(data: data),
          const SizedBox(height: 28),
          SizedBox(
            height: 88,
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _LostPetStatusScreen(data: data),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF86D63),
                foregroundColor: const Color(0xFF2F333A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(
                'СООБЩИТЬ\nО ПРОПАЖЕ',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LostPetStatusScreen extends StatefulWidget {
  final _LostPetData data;

  const _LostPetStatusScreen({
    required this.data,
  });

  @override
  State<_LostPetStatusScreen> createState() => _LostPetStatusScreenState();
}

class _LostPetStatusScreenState extends State<_LostPetStatusScreen> {
  bool _isActiveSearch = true;

  @override
  Widget build(BuildContext context) {
    return _LostPetScaffold(
      title: 'ПОТЕРЯШКИ',
      trailingText: 'редактировать',
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFF45A52),
            width: 4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LostPetPosterCard(data: widget.data, compact: true),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'СТАТУС',
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusChip(
                  label: 'активный поиск',
                  isSelected: _isActiveSearch,
                  onTap: () {
                    setState(() => _isActiveSearch = true);
                  },
                ),
                const SizedBox(width: 10),
                _StatusChip(
                  label: 'найден',
                  isSelected: !_isActiveSearch,
                  onTap: () {
                    setState(() => _isActiveSearch = false);
                  },
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _InfoAction(
                    title: 'УВЕДОМЛЕНИЯ',
                    value: '3',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Позже сюда добавим реальные сообщения.'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _InfoAction(
                    title: 'ПОДЕЛИТЬСЯ',
                    value: 'открыть',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Позже сюда подключим системный share sheet.',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LostPetScaffold extends StatelessWidget {
  final String title;
  final String trailingText;
  final Widget child;

  const _LostPetScaffold({
    required this.title,
    required this.trailingText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.undo_rounded,
                        color: Color(0xFFF0C146),
                        size: 34,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    trailingText,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 13,
                      color: const Color(0xFF2F333A).withValues(alpha: 0.82),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.06,
                ),
              ),
              const SizedBox(height: 22),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _LostPetPosterCard extends StatelessWidget {
  final _LostPetData data;
  final bool compact;

  const _LostPetPosterCard({
    required this.data,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      color: const Color(0xFFD9D9D9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ВНИМАНИЕ!',
            style: AppTextStyles.title.copyWith(
              fontSize: compact ? 24 : 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          Transform.translate(
            offset: const Offset(2, -2),
            child: Text(
              'потерялся друг',
              style: AppTextStyles.caption.copyWith(
                fontSize: compact ? 16 : 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 108 : 116,
                height: compact ? 108 : 124,
                color: const Color(0xFFFFE5E5),
                alignment: Alignment.center,
                child: Text(
                  'фото',
                  style: AppTextStyles.subtitle.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF89D9A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'выложите объявление\nи отметьте место на\nкарте, где вас увидели',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'отметить на карте',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoLine(text: 'Пропал кличка: ${data.petName}'),
          _InfoLine(text: '📍 Район: ${data.district}'),
          _InfoLine(text: '🕓 ${data.lostAt}'),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          _InfoLine(text: '! Очень просим, если его увидите или нашли — напишите или позвоните'),
          _InfoLine(text: '📞 ${data.contactPhone}'),
          _InfoLine(text: '◌ Telegram ${data.contactTelegram}'),
          const SizedBox(height: 8),
          Text(
            '⚠️ ${data.rewardText}',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String text;

  const _InfoLine({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          fontSize: 14,
          height: 1.3,
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
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF89D9A) : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _InfoAction extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _InfoAction({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.title.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LostPetData {
  final String petName;
  final String district;
  final String lostAt;
  final String description;
  final String contactPhone;
  final String contactTelegram;
  final String rewardText;

  const _LostPetData({
    required this.petName,
    required this.district,
    required this.lostAt,
    required this.description,
    required this.contactPhone,
    required this.contactTelegram,
    required this.rewardText,
  });
}
