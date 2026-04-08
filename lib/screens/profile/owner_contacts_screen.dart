import 'package:flutter/material.dart';

class OwnerContactsScreen extends StatefulWidget {
  const OwnerContactsScreen({super.key});

  @override
  State<OwnerContactsScreen> createState() => _OwnerContactsScreenState();
}

class _OwnerContactsScreenState extends State<OwnerContactsScreen> {
  static const Color accent = Color(0xFFF0B63F);
  static const Color textDark = Color(0xFF2F333A);
  static const Color bg = Color(0xFFF7F9F7);
  static const Color blueText = Color(0xFF253B8F);
  static const Color tiffany = Color(0xFFDDF7F5);
  static const Color peachBorder = Color(0xFFF2D8D1);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController extraController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    areaController.dispose();
    extraController.dispose();
    super.dispose();
  }

  Widget _inputField({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 18,
        color: textDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 18,
          color: textDark,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: peachBorder,
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: peachBorder,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: accent,
            width: 1.4,
          ),
        ),
      ),
    );
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
                        'КОНТАКТЫ ХОЗЯИНА',
                        style: TextStyle(
                          fontSize: 21,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Добавление фото подключим следующим шагом'),
                          ),
                        );
                      },
                      child: Container(
                        width: 132,
                        height: 132,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF253B8F),
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            'ваше фото\n(необязательно)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: textDark,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _inputField(
                      hint: 'Имя',
                      controller: nameController,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      hint: 'Фамилия',
                      controller: surnameController,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      hint: 'номер телефона',
                      controller: phoneController,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      hint: 'район проживания',
                      controller: areaController,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      hint: 'дополнительные\nспособы связи',
                      controller: extraController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBEE7DF),
                          foregroundColor: textDark,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Сохранение подключим к Supabase следующим шагом'),
                            ),
                          );
                        },
                        child: const Text(
                          'сохранить',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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