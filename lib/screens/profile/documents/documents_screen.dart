import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/pet.dart';
import '../../../widgets/pet_profile_header.dart';

class DocumentsScreen extends StatefulWidget {
  final Pet selectedPet;

  const DocumentsScreen({
    super.key,
    required this.selectedPet,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  static const Color accent = Color(0xFFF0B63F);
  static const Color textDark = Color(0xFF2F333A);
  static const Color bg = Color(0xFFF7F9F7);

  final ImagePicker _imagePicker = ImagePicker();

  final List<_PetDocumentItem> _documents = [];

  Future<void> _showAddDocumentMenu() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Сделать фото'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Выбрать из галереи'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Выбрать файл'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (photo == null) return;

    setState(() {
      _documents.insert(
        0,
        _PetDocumentItem(
          title: 'Фото документа',
          date: _formatNow(),
          path: photo.path,
        ),
      );
    });
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _documents.insert(
        0,
        _PetDocumentItem(
          title: 'Документ из галереи',
          date: _formatNow(),
          path: image.path,
        ),
      );
    });
  }

  Future<void> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    setState(() {
      _documents.insert(
        0,
        _PetDocumentItem(
          title: file.name,
          date: _formatNow(),
          path: file.path,
        ),
      );
    });
  }

  String _formatNow() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();
    return '$day.$month.$year';
  }

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
                ],
              ),
              PetProfileHeader(
                pet: widget.selectedPet,
                accent: accent,
                textDark: textDark,
              ),
              const SizedBox(height: 28),
              const Text(
                'ДОКУМЕНТЫ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _showAddDocumentMenu,
                child: const Column(
                  children: [
                    Icon(
                      Icons.add,
                      size: 46,
                      color: textDark,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'добавить\nдокумент',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: textDark,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Expanded(
                child: _documents.isEmpty
                    ? const Center(
                        child: Text(
                          'Документов пока нет',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _documents.length,
                        separatorBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                            color: Color(0xFFBDBDBD),
                            thickness: 1,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final doc = _documents[index];
                          return _DocumentTile(doc: doc);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetDocumentItem {
  final String title;
  final String date;
  final String? path;

  _PetDocumentItem({
    required this.title,
    required this.date,
    required this.path,
  });
}

class _DocumentTile extends StatelessWidget {
  final _PetDocumentItem doc;

  const _DocumentTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    final lowerPath = (doc.path ?? '').toLowerCase();
    final isImage =
        lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isImage && doc.path != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(doc.path!),
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _DocIcon(),
            ),
          )
        else
          const _DocIcon(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc.title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2F333A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doc.date,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2F333A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocIcon extends StatelessWidget {
  const _DocIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF7CCFC4).withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.description_outlined,
        color: Color(0xFF2F333A),
      ),
    );
  }
}