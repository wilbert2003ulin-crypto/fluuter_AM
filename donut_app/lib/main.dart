import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicialización de Supabase
  await Supabase.initialize(
    url: 'https://abvvllqgpqpbawkaqzlz.supabase.co',
    publishableKey: 'PEGA_AQUI_TU_ANON_PUBLIC_KEY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Donut App',
      theme: ThemeData(primarySwatch: Colors.pink),
      // Mantiene la sesión activa aunque se cierre la app
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFC21235)),
              ),
            );
          }

          if (snapshot.hasData) {
            return const HomePage();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
