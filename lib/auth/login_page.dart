import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grandustionapp/components/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var Myemail, Mypassword;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A17),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  // Email or Username
                  CustomTextField(
                    controller: emailController,
                    label: "البريد الإلكتروني أو اسم المستخدم",
                    onSaved: (val) => Myemail = val,
                    keyboardType:
                        TextInputType.emailAddress, // أضف هذا إذا أردت
                    validator: (val) {
                      if (val == null || val.isEmpty) return "البريد مطلوب";
                      if (!val.contains("@") || !val.contains(".")) {
                        return "الرجاء إدخال بريد صحيح";
                      }
                      return null;
                    },
                  ),

                  // Password
                  CustomTextField(
                    controller: passController,
                    label: "كلمة المرور",
                    obscure: true,
                    onSaved: (val) => Mypassword = val,
                    keyboardType:
                        TextInputType.visiblePassword, // أضف هذا إذا أردت
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "كلمة المرور مطلوبة";
                      }
                      if (val.length < 6) {
                        return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Login Button
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: Myemail.trim(),
                                password: Mypassword.trim(),
                              );

                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  //forgot password
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset');
                    },
                    child: const Text(
                      "هل نسيت كلمة المرور؟",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),

                  const SizedBox(height: 8),

                  //dont have an account?
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "ليس لديك حساب؟ ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "انضم",
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
      ),
    );
  }
}
