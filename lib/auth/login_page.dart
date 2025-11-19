import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A17),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset("assets/logo/logo.png", width: 120),
                const SizedBox(height: 20),
                const Text(
                  "أهلاً بعودتك",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "سجل الدخول للمتابعة",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // حقل البريد أو اسم المستخدم
                TextField(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1B2A26),
                    labelText: "البريد الإلكتروني أو اسم المستخدم",
                    labelStyle: const TextStyle(color: Colors.white70),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFF44C37F),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF44C37F),
                        width: 2,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
                const SizedBox(height: 16),

                // حقل كلمة المرور
                TextField(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1B2A26),
                    labelText: "كلمة المرور",
                    labelStyle: const TextStyle(color: Colors.white70),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFF44C37F),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF44C37F),
                        width: 2,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
                const SizedBox(height: 24),

                // زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF44C37F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // زر نسيان كلمة المرور
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reset');
                  },
                  child: const Text(
                    "هل نسيت كلمة المرور؟",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),

                // زر إنشاء حساب جديد
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ليس لديك حساب جديد؟ ",
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                      Text(
                        'انضم',
                        style: TextStyle(
                          color: Color(0xFF44C37F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
