import 'package:flutter/material.dart';

class VaccinationFormScreen extends StatefulWidget {
  const VaccinationFormScreen({super.key});

  @override
  State<VaccinationFormScreen> createState() => _VaccinationFormScreenState();
}

class _VaccinationFormScreenState extends State<VaccinationFormScreen> {
  static const Color accent = Color(0xFFF0B63F);
  static const Color textDark = Color(0xFF2F333A);
  static const Color bg = Color(0xFFF7F9F7);
  static const Color selectedColor = Color(0xFFBEE7DF);

  String selectedVaccinationType = '';
  String selectedDate = '';
  final TextEditingController commentController = TextEditingController();

  final List<String> vaccinationTypes = [
    'бешенство',
    'комплексная вакцина',
    'чума',
    'парвовирус',
    'лептоспироз',
    'коронавирус',
    'другое',
  ];

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: accent,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();

      setState(() {
        selectedDate = '$day.$month.$year';
      });
    }
  }

  Future<void> _showChoiceSheet({
    required String title,
    required List<String> options,
    required void Function(String value) onSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 14),
                ...options.map(
                  (item) => ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    title: Text(
                      item,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelected(item);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fieldTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: textDark,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _selectBox({
    required String value,
    required VoidCallback onTap,
    String placeholder = 'Выбрать',
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52, minWidth: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: value.isEmpty ? Colors.white : selectedColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E2E2),
          ),
        ),
        child: Text(
          value.isEmpty ? placeholder : value,
          style: const TextStyle(
            fontSize: 15,
            color: textDark,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 28),
              const Center(
                child: Text(
                  'ВАКЦИНАЦИЯ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _fieldTitle('тип вакцинации:')),
                  const SizedBox(width: 16),
                  _selectBox(
                    value: selectedVaccinationType,
                    onTap: () {
                      _showChoiceSheet(
                        title: 'Выберите тип вакцинации',
                        options: vaccinationTypes,
                        onSelected: (value) {
                          setState(() {
                            selectedVaccinationType = value;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _fieldTitle('дата:')),
                  const SizedBox(width: 16),
                  _selectBox(
                    value: selectedDate,
                    onTap: _pickDate,
                    placeholder: 'Выбрать дату',
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _fieldTitle('комментарий\n(необязательно)'),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Напишите комментарий',
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E2E2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E2E2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: accent,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor,
                    foregroundColor: textDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Сохранение добавим следующим шагом'),
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
    );
  }
}