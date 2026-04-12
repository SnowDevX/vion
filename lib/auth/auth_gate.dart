import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grandustionapp/auth/login_page.dart';
import 'package:grandustionapp/screens/goal_setup_page.dart';
import 'package:grandustionapp/screens/home_page.dart';
import 'package:grandustionapp/services/account_backend.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //  حالة التحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0F1A17),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF44C37F)),
            ),
          );
        }

        if (snapshot.hasError) {
          print(' AuthGate Error: ${snapshot.error}');
          return const LoginPage();
        }

        final user = snapshot.data;
        
        if (user == null) {
          print(' AuthGate: لا يوجد مستخدم -> LoginPage');
          return const LoginPage();
        }

        print(' AuthGate: يوجد مستخدم ${user.email}');
        return FutureBuilder<bool>(
          future: AccountBackend().isNewUser(),
          builder: (context, isNewSnapshot) {
            if (isNewSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xFF0F1A17),
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFF44C37F)),
                ),
              );
            }
            
            if (isNewSnapshot.hasError) {
              print(' isNewUser Error: ${isNewSnapshot.error}');
              return const HomePage();
            }
            
            final isNew = isNewSnapshot.data ?? true;
            
            if (isNew) {
              print(' AuthGate: مستخدم جديد -> GoalSetupPage');
              return const GoalSetupPage();
            }
            
            print(' AuthGate: مستخدم قديم -> HomePage');
            return const HomePage();
          },
        );
      },
    );
  }
}