import 'package:flutter/material.dart';
import '../../models/pet.dart';

class HistoryScreen extends StatelessWidget {
  final Pet selectedPet;

  const HistoryScreen({
    super.key,
    required this.selectedPet,
  });

  static const Color accent = Color(0xFFF0B63F);
  static const Color textDark = Color(0xFF2F333A);
  static const Color bg = Color(0xFFF7F9F7);
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
                        'ИСТОРИЯ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF253B8F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 34),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}