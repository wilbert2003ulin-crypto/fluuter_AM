import 'package:flutter/material.dart';

import '../widgets/dotted_background.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form_card.dart';
import '../widgets/login_footer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DottedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LoginHeader(),
                SizedBox(height: 28),
                LoginFormCard(),
                SizedBox(height: 28),
                LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
