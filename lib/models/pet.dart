class Pet {
  final String id;
  final String? ownerId;
  final String name;
  final String? type;
  final String? breed;
  final int? age;
  final double? weight;
  final String? color;
  final String? notes;
  final String? photoUrl;

  const Pet({
    required this.id,
    this.ownerId,
    required this.name,
    this.type,
    this.breed,
    this.age,
    this.weight,
    this.color,
    this.notes,
    this.photoUrl,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'] as String,
      ownerId: map['owner_id'] as String?,
      name: map['name'] as String,
      type: map['type'] as String?,
      breed: map['breed'] as String?,
      age: map['age'] as int?,
      weight: map['weight'] == null ? null : (map['weight'] as num).toDouble(),
      color: map['color'] as String?,
      notes: map['notes'] as String?,
      photoUrl: map['photo_url'] as String?,
    );
  }
}