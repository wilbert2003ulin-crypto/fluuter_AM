import 'package:flutter/material.dart';

import 'features/auth/presentation/screens/login_screen.dart';

void main() {
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
