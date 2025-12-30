import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grandustionapp/auth/login_page.dart';
import 'package:grandustionapp/screens/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // المستخدم مسجل دخول
        if (snapshot.hasData) {
          return const HomePage();
        }

        // المستخدم مو مسجل
        return const LoginPage();
      },
    );
  }
}
