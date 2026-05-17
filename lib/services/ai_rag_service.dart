import 'package:supabase_flutter/supabase_flutter.dart';

class AiRagDocument {
  final String source;
  final String title;
  final DateTime createdAt;
  final int chunkCount;

  const AiRagDocument({
    required this.source,
    required this.title,
    required this.createdAt,
    required this.chunkCount,
  });
}

class AiRagService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String buildDocumentSource({
    required String petId,
    required String fileName,
  }) {
    final safeName = fileName
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .trim();

    return 'pet_${petId}__${safeName.isEmpty ? 'document' : safeName}';
  }

  Future<void> uploadDocumentText({
    required String source,
    required String text,
  }) async {
    final response = await _supabase.functions.invoke(
      'ingest-knowledge',
      body: {
        'source': source,
        'text': text,
      },
    );

    if (response.status != 200) {
      final data = response.data;
      if (data is Map && data['error'] is String) {
        throw Exception(data['error'] as String);
      }
      throw Exception('Не удалось загрузить документ в AI');
    }
  }

  Future<List<AiRagDocument>> fetchDocumentsForPet({
    required String petId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return const [];

    final prefix = 'pet_${petId}__';

    final rows = await _supabase
        .from('knowledge_chunks')
        .select('source, created_at')
        .eq('user_id', user.id)
        .like('source', '$prefix%')
        .order('created_at', ascending: false);

    final Map<String, AiRagDocument> uniqueDocs = {};

    for (final row in rows) {
      final source = (row['source'] as String?)?.trim() ?? '';
      if (source.isEmpty) continue;

      final createdAt = DateTime.tryParse(
            (row['created_at'] as String?) ?? '',
          ) ??
          DateTime.now();

      final title = source.startsWith(prefix)
          ? source.substring(prefix.length)
          : source;

      if (uniqueDocs.containsKey(source)) {
        final existing = uniqueDocs[source]!;
        uniqueDocs[source] = AiRagDocument(
          source: existing.source,
          title: existing.title,
          createdAt: existing.createdAt,
          chunkCount: existing.chunkCount + 1,
        );
      } else {
        uniqueDocs[source] = AiRagDocument(
          source: source,
          title: title,
          createdAt: createdAt,
          chunkCount: 1,
        );
      }
    }

    final documents = uniqueDocs.values.toList();
    documents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return documents;
  }
}
