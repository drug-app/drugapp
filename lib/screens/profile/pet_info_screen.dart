import 'package:flutter/material.dart';
import '../../models/pet.dart';
import '../../widgets/pet_profile_header.dart';

class PetInfoScreen extends StatelessWidget {
  final Pet selectedPet;
  final VoidCallback onChangePet;

  const PetInfoScreen({
    super.key,
    required this.selectedPet,
    required this.onChangePet,
  });

  static const Color accent = Color(0xFFF0B63F);
  static const Color textDark = Color(0xFF2F333A);
  static const Color bg = Color(0xFFF7F9F7);
  static const Color tiffany = Color(0xFFDDF7F5);

  Widget _infoTile(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF2E8E6),
          width: 1.2,
        ),
      ),
      child: Text(
        value.isEmpty ? title : value,
        style: const TextStyle(
          fontSize: 18,
          color: textDark,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  String _petAgeText() {
    if (selectedPet.age == null) return '';
    return selectedPet.age.toString();
  }

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 34,
                            color: accent,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: onChangePet,
                          child: const Column(
                            children: [
                              Icon(
                                Icons.pets_rounded,
                                size: 30,
                                color: textDark,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'сменить питомца',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    PetProfileHeader(
                      pet: selectedPet,
                      accent: accent,
                      textDark: textDark,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                child: Column(
                  children: [
                    _infoTile('порода', selectedPet.breed ?? ''),
                    const SizedBox(height: 16),
                    _infoTile('вес', ''),
                    const SizedBox(height: 16),
                    _infoTile('окрас', ''),
                    const SizedBox(height: 16),
                    _infoTile('особенности', selectedPet.notes ?? ''),
                    const SizedBox(height: 16),
                    _infoTile('привычки', ''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}