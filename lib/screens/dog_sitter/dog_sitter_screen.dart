import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../ai/ai_screen.dart';

class DogSitterScreen extends StatelessWidget {
  const DogSitterScreen({super.key});

  static const _DogSitterProfile _profile = _DogSitterProfile(
    name: 'Елена',
    services: ['дрессировка', 'выгул', 'передержка'],
    rating: '5.0',
    reviews: '14 отзывов',
    price: 'от 500 рублей',
    about:
        'Елена уже несколько лет работает с собаками, помогает с выгулом, домашней передержкой и мягкой адаптацией питомца к новому режиму.',
    experience:
        'Работает с маленькими и средними породами, умеет выстраивать спокойный режим прогулок и бережную адаптацию.',
  );

  void _openAiChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AiScreen(),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const _DogSitterProfileScreen(profile: _profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFEFFFB);
    const accent = Color(0xFF2F3D91);
    const mint = Color(0xFFD9F3F5);
    const softPink = Color(0xFFFBE1DA);

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
              const SizedBox(height: 18),
              Text(
                'ЗООНЯНИ',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 30,
                  color: accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _openAiChat(context),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              '— мне нужен человек, который\nможет гулять с собакой каждый день',
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xFFF1D7D1)),
                ),
                child: Text(
                  'анкеты',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFF1D7D1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: softPink,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            _profile.name,
                            style: AppTextStyles.subtitle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ..._profile.services.map(
                            (service) => Text(
                              service,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'оценка ${_profile.rating}',
                            style: AppTextStyles.caption.copyWith(fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _profile.reviews,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption.copyWith(fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _profile.price,
                            textAlign: TextAlign.end,
                            style: AppTextStyles.caption.copyWith(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'фото',
                            style: AppTextStyles.subtitle.copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: FilledButton(
                              onPressed: () => _openProfile(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: softPink,
                                foregroundColor: const Color(0xFF2F333A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                              ),
                              child: Text(
                                'посмотреть анкету',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
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

class _DogSitterProfileScreen extends StatelessWidget {
  final _DogSitterProfile profile;

  const _DogSitterProfileScreen({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFEFFFB);
    const accent = Color(0xFF2F3D91);
    const softPink = Color(0xFFFBE1DA);

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
              ),
              const SizedBox(height: 20),
              Text(
                profile.name,
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: Text(
                  'фото',
                  style: AppTextStyles.title.copyWith(fontSize: 28),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFF1D7D1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: profile.services
                          .map(
                            (service) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: softPink,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                service,
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Оценка ${profile.rating} • ${profile.reviews} • ${profile.price}',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'О специалисте',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.about,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Опыт и формат работы',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.experience,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        height: 1.45,
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

class _DogSitterProfile {
  final String name;
  final List<String> services;
  final String rating;
  final String reviews;
  final String price;
  final String about;
  final String experience;

  const _DogSitterProfile({
    required this.name,
    required this.services,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.about,
    required this.experience,
  });
}
