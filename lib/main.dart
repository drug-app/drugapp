import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hcohlvtsypqwroeeuzxl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhjb2hsdnRzeXBxd3JvZWV1enhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5NDEyNTgsImV4cCI6MjA5MDUxNzI1OH0.n0LCTV_7tfJAG2U3_eMXgRZFb8ZIdZLms_Fx_3wrQw4',
  );

  runApp(const DrugApp());
}

class DrugApp extends StatelessWidget {
  const DrugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: const AuthGate(),
    );
  }
}