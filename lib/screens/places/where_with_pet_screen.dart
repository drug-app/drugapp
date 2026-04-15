import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../ai/ai_screen.dart';

enum _PlacesView { list, map }

class WhereWithPetScreen extends StatefulWidget {
  const WhereWithPetScreen({super.key});

  @override
  State<WhereWithPetScreen> createState() => _WhereWithPetScreenState();
}

class _WhereWithPetScreenState extends State<WhereWithPetScreen>
    with TickerProviderStateMixin {
  static const List<String> _filters = [
    'кафе',
    'парки',
    'площадки',
    'выставки',
    'мероприятия',
  ];

  _PlacesView _selectedView = _PlacesView.list;
  String _selectedFilter = _filters.first;
  bool _isFilterOpen = false;

  void _openAiChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AiScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const accent = Color(0xFF283593);
    const peach = Color(0xFFF1C9C2);
    const mint = Color(0xFFDDF3F2);
    const greenHighlight = Color(0xFFE4F5D9);
    const border = Color(0xFFF0D3CD);
    const textDark = Color(0xFF2F333A);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
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
              const SizedBox(height: 18),
              Text(
                'КУДА\nС ПИТОМЦЕМ',
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
                              'Куда в этот раз?',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 17,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Например: в кофейню, где есть матча',
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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFilterOpen = !_isFilterOpen;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'фильтр',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 15,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedRotation(
                              turns: _isFilterOpen ? 0.5 : 0,
                              duration: const Duration(milliseconds: 220),
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: _isFilterOpen
                          ? Container(
                              width: 220,
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: border),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 16,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _filters.map((filter) {
                                  final isSelected =
                                      filter == _selectedFilter;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedFilter = filter;
                                        _isFilterOpen = false;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 9,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? greenHighlight
                                            : const Color(0xFFFFF8F7),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: border),
                                      ),
                                      child: Text(
                                        filter,
                                        style: AppTextStyles.caption.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ViewToggleButton(
                        label: 'список мест',
                        isSelected: _selectedView == _PlacesView.list,
                        onTap: () {
                          setState(() {
                            _selectedView = _PlacesView.list;
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
                      child: _ViewToggleButton(
                        label: 'на карте',
                        isSelected: _selectedView == _PlacesView.map,
                        onTap: () {
                          setState(() {
                            _selectedView = _PlacesView.map;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _selectedView == _PlacesView.list
                    ? const _PlacesListCard(
                        key: ValueKey('places_list'),
                      )
                    : _MapPlaceholder(
                        key: const ValueKey('places_map'),
                        selectedFilter: _selectedFilter,
                        accent: accent,
                        peach: peach,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleButton({
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

class _PlacesListCard extends StatelessWidget {
  const _PlacesListCard({super.key});

  @override
  Widget build(BuildContext context) {
    const peach = Color(0xFFF2B7AD);
    const cardBorder = Color(0xFF2D93F5);

    return Container(
      key: key,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: cardBorder, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'CoffeeDog',
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '⭐ 4.8',
                style: AppTextStyles.subtitle.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 14),
              Text(
                '📍 0.8 км',
                style: AppTextStyles.subtitle.copyWith(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  height: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF8A5B3D),
                        Color(0xFFD5B08B),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_cafe_rounded,
                      color: Colors.white,
                      size: 54,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 4,
                child: Column(
                  children: const [
                    _PlaceTag(text: 'самый вкусный\nчизкейк в Москве'),
                    SizedBox(height: 12),
                    _PlaceTag(text: 'бесплатный кофе\nпо промокоду RIM'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: _ActionButton(
                  label: 'меню',
                  color: peach,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'подробнее',
                  color: peach,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'маршрут',
                  color: peach,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final String selectedFilter;
  final Color accent;
  final Color peach;

  const _MapPlaceholder({
    super.key,
    required this.selectedFilter,
    required this.accent,
    required this.peach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF0D3CD)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: CustomPaint(
                painter: _MapPainter(),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,
            right: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Здесь появится карта твоего города.\nСейчас выбран фильтр: $selectedFilter',
                style: AppTextStyles.body.copyWith(fontSize: 14),
              ),
            ),
          ),
          Positioned(
            top: 86,
            left: 56,
            child: Column(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFFE15A5A),
                  size: 34,
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE15A5A),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 72,
            right: 14,
            bottom: 14,
            child: Container(
              width: 94,
              decoration: BoxDecoration(
                color: peach,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MapSideLabel(label: 'кафе', accent: accent),
                      _MapSideLabel(label: 'парки', accent: accent),
                      _MapSideLabel(label: 'площадки', accent: accent),
                      _MapSideLabel(label: 'другое', accent: accent),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceTag extends StatelessWidget {
  final String text;

  const _PlaceTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0D3CD)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;

  const _ActionButton({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.button.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapSideLabel extends StatelessWidget {
  final String label;
  final Color accent;

  const _MapSideLabel({
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 0,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.subtitle.copyWith(
          fontSize: 17,
          color: accent,
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0xFFF4E8C9);
    final parkPaint = Paint()..color = const Color(0xFFD5EDC5);
    final waterPaint = Paint()..color = const Color(0xFFC7E5F7);
    final roadPaint = Paint()
      ..color = const Color(0xFFE1A664)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Offset.zero & size, backgroundPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.06, size.height * 0.12, 120, 90),
        const Radius.circular(24),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.34, size.height * 0.54, 130, 96),
        const Radius.circular(26),
      ),
      parkPaint,
    );

    final waterPath = Path()
      ..moveTo(0, size.height * 0.36)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.24,
        size.width * 0.34,
        size.height * 0.38,
      )
      ..quadraticBezierTo(
        size.width * 0.46,
        size.height * 0.52,
        size.width * 0.64,
        size.height * 0.44,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.38,
        size.width,
        size.height * 0.52,
      );
    canvas.drawPath(waterPath, waterPaint..strokeWidth = 30);

    final roads = [
      [Offset(0, size.height * 0.72), Offset(size.width * 0.84, 0)],
      [Offset(size.width * 0.08, 0), Offset(size.width * 0.7, size.height)],
      [Offset(size.width * 0.22, size.height), Offset(size.width * 0.88, size.height * 0.14)],
      [Offset(0, size.height * 0.22), Offset(size.width * 0.86, size.height * 0.8)],
      [Offset(size.width * 0.2, 0), Offset(size.width * 0.28, size.height)],
    ];

    for (final road in roads) {
      roadPaint.strokeWidth = 7;
      canvas.drawLine(road[0], road[1], roadPaint);
      roadPaint.strokeWidth = 3;
      canvas.drawLine(
        road[0] + const Offset(8, 8),
        road[1] + const Offset(-8, -8),
        roadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
