import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet.dart';

class PetService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Pet>> getPets() async {
    final userId = '7244f9ca-4e6b-4bff-9732-1c34570b9dac';

    final data = await supabase
        .from('pets')
        .select()
        .eq('owner_id', userId)
        .order('created_at', ascending: true);

    return (data as List).map((item) => Pet.fromMap(item)).toList();
  }

  Future<Pet> createPet({
    required String name,
    required String type,
    required String breed,
    required int age,
    required int weight,
    required String color,
    String? notes,
    String? photoUrl,
  }) async {
    final userId = '7244f9ca-4e6b-4bff-9732-1c34570b9dac';

    final data = await supabase
        .from('pets')
        .insert({
          'name': name,
          'type': type,
          'breed': breed,
          'age': age,
          'weight': weight,
          'color': color,
          'notes': notes,
          'owner_id': userId,
          'photo_url': photoUrl,
        })
        .select()
        .single();

    return Pet.fromMap(data);
  }

  Future<Pet> updatePet({
    required String id,
    required String name,
    required String breed,
    required int age,
    required int weight,
    required String color,
    String? notes,
    String? photoUrl,
  }) async {
    final data = await supabase
        .from('pets')
        .update({
          'name': name,
          'breed': breed,
          'age': age,
          'weight': weight,
          'color': color,
          'notes': notes,
          'photo_url': photoUrl,
        })
        .eq('id', id)
        .select()
        .single();

    return Pet.fromMap(data);
  }
}