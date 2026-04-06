import 'package:flutter/material.dart';
import '../../../models/pet.dart';
import '../../../widgets/pet_profile_header.dart';

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
              // 🔙 верх
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
                ],
              ),

              // 🐶 хедер питомца
              PetProfileHeader(
                pet: selectedPet,
                accent: accent,
                textDark: textDark,
              ),

              const SizedBox(height: 24),

              // 🧠 заголовок
              const Text(
                'ПРИВИВКИ И ОБРАБОТКИ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 14),

              // 📌 статус (пока заглушка)
              const Text(
                'статус:\nобработка через ...\nвакцинация через ...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 26),

              // ➕ кнопки
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
                          content: Text('Сканирование скоро будет'),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 🕘 история
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

              const SizedBox(height: 16),

              // пустое место
              const Expanded(
                child: Center(
                  child: Text(
                    'пока пусто',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 15,
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
          Icon(
            icon,
            size: 34,
            color: textDark,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }
}