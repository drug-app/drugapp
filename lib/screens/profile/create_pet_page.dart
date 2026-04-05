import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/pet.dart';
import '../../services/pet_service.dart';

class CreatePetPage extends StatefulWidget {
  final Pet? existingPet;

  const CreatePetPage({super.key, this.existingPet});

  @override
  State<CreatePetPage> createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  final _petService = PetService();

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final colorController = TextEditingController();
  final notesController = TextEditingController();

  bool isLoading = false;
  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  bool get isEditMode => widget.existingPet != null;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      setState(() {
        selectedImage = picked;
        selectedImageBytes = bytes;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (selectedImage == null || selectedImageBytes == null) return null;

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    await Supabase.instance.client.storage
        .from('pets')
        .uploadBinary(fileName, selectedImageBytes!);

    final publicUrl = Supabase.instance.client.storage
        .from('pets')
        .getPublicUrl(fileName);

    return publicUrl;
  }

  @override
  void initState() {
    super.initState();

    if (widget.existingPet != null) {
      nameController.text = widget.existingPet!.name;
      typeController.text = widget.existingPet!.type ?? '';
      breedController.text = widget.existingPet!.breed ?? '';
      ageController.text =
          widget.existingPet!.age != null ? widget.existingPet!.age.toString() : '';
      weightController.text =
          widget.existingPet!.weight != null ? widget.existingPet!.weight!.toString() : '';
      colorController.text = widget.existingPet!.color ?? '';
      notesController.text = widget.existingPet!.notes ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    colorController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (isLoading) return;

    final name = nameController.text.trim();
    final type = typeController.text.trim();
    final breed = breedController.text.trim();
    final color = colorController.text.trim();
    final notes = notesController.text.trim();

    final age = int.tryParse(ageController.text.trim());
    final weight = int.tryParse(weightController.text.trim());

    if (name.isEmpty || age == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните кличку, возраст и вес корректно'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final photoUrl = await _uploadImage();
      Pet savedPet;

      if (isEditMode) {
     savedPet = await _petService.updatePet(
  id: widget.existingPet!.id,
  name: name,
  breed: breed,
  age: age,
  weight: weight,
  color: color,
  notes: notes.isEmpty ? null : notes,
  photoUrl: photoUrl ?? widget.existingPet!.photoUrl,
);
      } else {
        savedPet = await _petService.createPet(
          name: name,
          type: type,
          breed: breed,
          age: age,
          weight: weight,
          color: color,
          notes: notes.isEmpty ? null : notes,
          photoUrl: photoUrl,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, savedPet);
    } catch (e) {
        print('SAVE PET ERROR: $e');

      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось сохранить питомца'),
        ),
      );
    }
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: const Color(0xFFF7F9F7),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFF0B63F);
    const textDark = Color(0xFF2F333A);
    const bg = Color(0xFFF2EEF4);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditMode ? 'Редактировать питомца' : 'Добавить питомца',
          style: const TextStyle(color: textDark),
        ),
        iconTheme: const IconThemeData(color: textDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                isEditMode
                    ? 'Измените данные вашего питомца'
                    : 'Заполните данные вашего питомца',
                style: const TextStyle(
                  fontSize: 16,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: selectedImageBytes != null
                      ? ClipOval(
                          child: Image.memory(
                            selectedImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.camera_alt, size: 30),
                ),
              ),
              _input('Кличка питомца', nameController),
              _input('Вид животного (собака, кошка...)', typeController),
              _input('Порода', breedController),
              _input('Возраст', ageController),
              _input('Вес', weightController),
              _input('Окрас', colorController),
              _input('Заметки', notesController),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: isLoading ? null : _save,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isEditMode ? 'СОХРАНИТЬ ИЗМЕНЕНИЯ' : 'СОХРАНИТЬ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}