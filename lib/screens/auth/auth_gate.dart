import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../home/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    // Если уже есть активная сессия — сразу на главный экран
    if (supabase.auth.currentSession != null) {
      return const HomePage();
    }

    // Без сессии тоже сразу на главный экран (гостевой режим)
    return const HomePage();
  }
}
