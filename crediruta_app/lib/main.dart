import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/presentation/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CrediRutaApp());
}

class CrediRutaApp extends StatelessWidget {
  const CrediRutaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "YEYPE'S Natura",
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
