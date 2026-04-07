import 'package:flutter/material.dart';
import '../../../models/pet.dart';
import '../../../widgets/pet_profile_header.dart';
import 'add_record_screen.dart';

class VaccinesScreen extends StatelessWidget {
  final Pet selectedPet;

  const VaccinesScreen({
    super.key,
    required this.selectedPet,
  });

  static const Color accent = Color(0xFFF0B63F);
  static const Color textDark = Color(0xFF2F333A);
  static const Color bg = Color(0xFFF7F9F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Редактирование добавим следующим шагом'),
                        ),
                      );
                    },
                    child: const Text(
                      'редактировать',
                      style: TextStyle(
                        fontSize: 13,
                        color: textDark,
                      ),
                    ),
                  ),
                ],
              ),
              PetProfileHeader(
                pet: selectedPet,
                accent: accent,
                textDark: textDark,
              ),
              const SizedBox(height: 24),
              const Text(
                'ПРИВИВКИ И ОБРАБОТКИ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Подробный статус добавим следующим шагом'),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                    ),
                  ),
                  child: const Text(
                    'статус:\nпока пусто',
                    style: TextStyle(
                      fontSize: 14,
                      color: textDark,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TopActionButton(
                    icon: Icons.add,
                    title: 'добавить\nзапись',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddRecordScreen(
                            selectedPet: selectedPet,
                          ),
                        ),
                      );
                    },
                  ),
                  _TopActionButton(
                    icon: Icons.document_scanner_outlined,
                    title: 'сканировать\nдокумент',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Сканирование документа добавим следующим шагом'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 34),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'история',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE8E8E8),
                    ),
                  ),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'пока пусто',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 15,
                      ),
                    ),
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

class _TopActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _TopActionButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  static const Color textDark = Color(0xFF2F333A);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE8E8E8),
              ),
            ),
            child: Icon(
              icon,
              size: 34,
              color: textDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: textDark,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}   