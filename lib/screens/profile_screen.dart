import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';
import 'create_pet_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PetService _petService = PetService();

  List<Pet> pets = [];
  Pet? selectedPet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('USER ID: ${Supabase.instance.client.auth.currentUser?.id}');
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final loadedPets = await _petService.getPets();

      setState(() {
        pets = loadedPets;
        selectedPet = loadedPets.isNotEmpty ? loadedPets.first : null;
        isLoading = false;
      });
    } catch (e) {
      print('LOAD PETS ERROR: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToHomePage(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _showPetSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Выберите питомца',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F333A),
                  ),
                ),
                const SizedBox(height: 16),
                ...pets.map(
                  (item) => ListTile(
                    leading: const Icon(
                      Icons.pets,
                      color: Color(0xFFF0B63F),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        color: Color(0xFF2F333A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      item.breed ?? 'Без породы',
                      style: const TextStyle(
                        color: Color(0xFF2F333A),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedPet = item;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFFF0B63F),
                  ),
                  title: const Text(
                    'Добавить питомца',
                    style: TextStyle(
                      color: Color(0xFF2F333A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    final Pet? newPet = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreatePetPage(),
                      ),
                    );

                    if (newPet != null) {
                      setState(() {
                        final alreadyExists =
                            pets.any((item) => item.id == newPet.id);

                        if (!alreadyExists) {
                          pets.add(newPet);
                        }

                        selectedPet = newPet;
                      });
                    } else {
                      _loadPets();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('PROFILE PHOTO URL: ${selectedPet?.photoUrl}');
    print('PROFILE PET NAME: ${selectedPet?.name}');

    const accent = Color(0xFFF0B63F);
    const textDark = Color(0xFF2F333A);
    const bg = Color(0xFFF7F9F7);

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (selectedPet == null) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: GestureDetector(
            onTap: () async {
              final Pet? newPet = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreatePetPage(),
                ),
              );

              if (newPet != null) {
                setState(() {
                  pets = [newPet];
                  selectedPet = newPet;
                });
              } else {
                _loadPets();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Добавить питомца',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

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
                  GestureDetector(
                    onTap: _showPetSwitcher,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.pets_outlined,
                          size: 34,
                          color: textDark,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'сменить питомца',
                          style: TextStyle(
                            fontSize: 10,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  child: selectedPet!.photoUrl != null &&
                          selectedPet!.photoUrl!.isNotEmpty
                      ? Image.network(
                          selectedPet!.photoUrl!,
                          width: 138,
                          height: 138,
                          fit: BoxFit.cover,
                        )
                      : const Center(
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
              const Row(
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
                    selectedPet!.breed ?? '—',
                    style: const TextStyle(
                      fontSize: 16,
                      color: textDark,
                    ),
                  ),
                  Text(
                    selectedPet!.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: textDark,
                    ),
                  ),
                  Text(
                    selectedPet!.age != null ? '${selectedPet!.age} года' : '—',
                    style: const TextStyle(
                      fontSize: 16,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: accent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  selectedPet!.notes ?? 'Нет заметок',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    color: textDark,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProfileActionButton(
                    title: 'здоровье',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServicePlaceholderPage(
                            title: 'здоровье',
                            text: 'Раздел здоровья питомца',
                            goToHomePage: _goToHomePage,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 28),
                  _ProfileActionButton(
                    title: 'о питомце',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServicePlaceholderPage(
                            title: 'о питомце',
                            text: 'Информация о питомце',
                            goToHomePage: _goToHomePage,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final Pet? updatedPet = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreatePetPage(
                        existingPet: selectedPet,
                      ),
                    ),
                  );

                  if (updatedPet != null) {
                    setState(() {
                      final index =
                          pets.indexWhere((item) => item.id == updatedPet.id);

                      if (index != -1) {
                        pets[index] = updatedPet;
                      }

                      selectedPet = updatedPet;
                    });
                  } else {
                    _loadPets();
                  }
                },
                child: const Text(
                  'редактировать',
                  style: TextStyle(
                    fontSize: 16,
                    color: textDark,
                    fontWeight: FontWeight.w500,
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

class _ProfileActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ProfileActionButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(title),
    );
  }
}

class ServicePlaceholderPage extends StatelessWidget {
  final String title;
  final String text;
  final void Function(BuildContext) goToHomePage;

  const ServicePlaceholderPage({
    super.key,
    required this.title,
    required this.text,
    required this.goToHomePage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F7CFF), Color(0xFF7EA2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => goToHomePage(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F333A),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}