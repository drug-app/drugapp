import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../models/pet.dart';
import '../../../services/ai_rag_service.dart';
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

  final AiRagService _ragService = AiRagService();
  final SupabaseClient _supabase = Supabase.instance.client;

  final List<_PetDocumentItem> _documents = [];

  bool _isLoadingDocuments = true;
  bool _isUploadingDocument = false;

  User? get _currentUser => _supabase.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    if (_currentUser == null) {
      if (!mounted) return;
      setState(() {
        _documents.clear();
        _isLoadingDocuments = false;
      });
      return;
    }

    if (mounted) {
      setState(() => _isLoadingDocuments = true);
    }

    try {
      final docs = await _ragService.fetchDocumentsForPet(
        petId: widget.selectedPet.id,
      );

      if (!mounted) return;

      setState(() {
        _documents
          ..clear()
          ..addAll(
            docs.map(
              (doc) => _PetDocumentItem(
                title: doc.title,
                date: _formatDateTime(doc.createdAt),
                source: doc.source,
                chunkCount: doc.chunkCount,
              ),
            ),
          );
      });
    } catch (error) {
      if (!mounted) return;
      _showSnackBar('Не удалось загрузить документы: $error');
    } finally {
      if (mounted) {
        setState(() => _isLoadingDocuments = false);
      }
    }
  }

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
                leading: const Icon(Icons.upload_file_rounded),
                title: const Text('Загрузить PDF или TXT'),
                subtitle: const Text('Документ будет доступен AI-помощнику'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickAndUploadFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadFile() async {
    if (_isUploadingDocument) return;

    if (_currentUser == null) {
      _showSnackBar('Войдите в аккаунт, чтобы загружать документы.');
      return;
    }

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final fileName = (file.name).trim().isEmpty ? 'document' : file.name.trim();
    final extension = (file.extension ?? '').toLowerCase();

    setState(() => _isUploadingDocument = true);

    try {
      final extractedText = await _extractTextFromFile(file, extension);

      if (extractedText.trim().length < 40) {
        throw Exception(
          'В документе слишком мало текста для AI. Попробуй другой файл.',
        );
      }

      final source = _ragService.buildDocumentSource(
        petId: widget.selectedPet.id,
        fileName: fileName,
      );

      await _ragService.uploadDocumentText(
        source: source,
        text: extractedText,
      );

      await _loadDocuments();

      if (!mounted) return;
      _showSnackBar('Документ добавлен в знания AI.');
    } catch (error) {
      if (!mounted) return;
      _showSnackBar('Не удалось обработать документ: $error');
    } finally {
      if (mounted) {
        setState(() => _isUploadingDocument = false);
      }
    }
  }

  Future<String> _extractTextFromFile(
    PlatformFile file,
    String extension,
  ) async {
    final bytes = file.bytes ?? await _readBytesFromPath(file.path);

    if (bytes == null || bytes.isEmpty) {
      throw Exception('Не удалось прочитать файл');
    }

    if (extension == 'pdf') {
      final document = PdfDocument(inputBytes: bytes);
      try {
        final text = PdfTextExtractor(document).extractText();
        return text
            .replaceAll('\r', '\n')
            .replaceAll(RegExp(r'\n{3,}'), '\n\n')
            .trim();
      } finally {
        document.dispose();
      }
    }

    if (extension == 'txt') {
      return utf8.decode(bytes, allowMalformed: true).trim();
    }

    throw Exception('Поддерживаются только PDF и TXT');
  }

  Future<List<int>?> _readBytesFromPath(String? path) async {
    if (path == null || path.isEmpty) return null;
    return File(path).readAsBytes();
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day.$month.$year • $hour:$minute';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
              const SizedBox(height: 12),
              const Text(
                'Загружай PDF или TXT, и AI сможет использовать эти документы в ответах.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: textDark,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: _isUploadingDocument ? null : _showAddDocumentMenu,
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: textDark.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: _isUploadingDocument
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(strokeWidth: 2.8),
                            )
                          : const Icon(
                              Icons.add_rounded,
                              size: 34,
                              color: textDark,
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isUploadingDocument
                          ? 'загружаем\nдокумент'
                          : 'добавить\nдокумент',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                child: _isLoadingDocuments
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _documents.isEmpty
                    ? const Center(
                        child: Text(
                          'Документов для AI пока нет',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _documents.length,
                        separatorBuilder: (context, index) => const Padding(
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
  final String source;
  final int chunkCount;

  const _PetDocumentItem({
    required this.title,
    required this.date,
    required this.source,
    required this.chunkCount,
  });
}

class _DocumentTile extends StatelessWidget {
  final _PetDocumentItem doc;

  const _DocumentTile({required this.doc});

  String _buildChunkLabel(int count) {
    if (count % 10 == 1 && count % 100 != 11) return '$count фрагмент';
    if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 12 || count % 100 > 14)) {
      return '$count фрагмента';
    }
    return '$count фрагментов';
  }

  @override
  Widget build(BuildContext context) {
    final lowerTitle = doc.title.toLowerCase();
    final isPdf = lowerTitle.endsWith('.pdf');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DocIcon(isPdf: isPdf),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doc.date,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF2F333A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Загружено в AI • ${_buildChunkLabel(doc.chunkCount)}',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF2F333A).withValues(alpha: 0.72),
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
  final bool isPdf;

  const _DocIcon({required this.isPdf});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF7CCFC4).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isPdf ? Icons.picture_as_pdf_outlined : Icons.description_outlined,
        color: const Color(0xFF2F333A),
      ),
    );
  }
}
