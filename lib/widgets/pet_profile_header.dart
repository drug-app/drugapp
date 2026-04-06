import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetProfileHeader extends StatelessWidget {
  final Pet pet;
  final Color accent;
  final Color textDark;

  const PetProfileHeader({
    super.key,
    required this.pet,
    required this.accent,
    required this.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Container(
          width: 138,
          height: 138,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: accent,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: pet.photoUrl != null && pet.photoUrl!.isNotEmpty
                ? Image.network(
                    pet.photoUrl!,
                    width: 138,
                    height: 138,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Text(
                      'фото вашего\nпитомца',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          pet.name,
          style: TextStyle(
            fontSize: 28,
            color: textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'порода',
              style: TextStyle(
                fontSize: 15,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'кличка питомца',
              style: TextStyle(
                fontSize: 15,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'возраст',
              style: TextStyle(
                fontSize: 15,
                color: textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              pet.breed ?? '—',
              style: TextStyle(
                fontSize: 16,
                color: textDark,
              ),
            ),
            Text(
              pet.name,
              style: TextStyle(
                fontSize: 16,
                color: textDark,
              ),
            ),
            Text(
              pet.age != null ? '${pet.age}' : '—',
              style: TextStyle(
                fontSize: 16,
                color: textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}