import 'package:flutter/material.dart';

class OurRecordsScreen extends StatelessWidget {
  const OurRecordsScreen({super.key});

  static const Color accent = Color(0xFFF0B63F);
  static const Color bg = Color(0xFFF7F9F7);
  static const Color blueText = Color(0xFF253B8F);
  static const Color tiffany = Color(0xFFDDF7F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: tiffany,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 34,
                      color: accent,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'НАШИ ЗАПИСИ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: blueText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 34),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  const Text(
                    'записей еще нет',
                    style: TextStyle(
                      fontSize: 18,
                      color: blueText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          'image.png',
                          height: 220,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 180,
                              child: Center(
                                child: Text(
                                  'тут будет милая картинка',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: blueText,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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