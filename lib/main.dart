import 'package:espaco_ja/screens/home/opcoes_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth/auth_gate.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Espaço Já',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)), // Usando o verde como cor base
        useMaterial3: true,
        // ✅ Correção: Garante que o fundo do Scaffold seja transparente por padrão
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const AuthGate(),

      debugShowCheckedModeBanner: false,
    );
  }
}
