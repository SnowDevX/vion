import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grandustionapp/components/custom_text_field.dart';
import 'package:grandustionapp/generated/l10n.dart';

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
    final lang = S.of(context)!; // الحصول على النصوص المترجمة
    final isRTL = Localizations.localeOf(context).languageCode == 'ar'; // تحديد اتجاه النص

    return Directionality( // أضف هذا الـ Directionality
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
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

                    Text(
                      lang.welcomeBack, // استبدل النص الثابت
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      lang.loginToContinue, // استبدل النص الثابت
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),

                    const SizedBox(height: 40),
                    // Email or Username
                    CustomTextField(
                      controller: emailController,
                      label: lang.emailOrUsername, // استبدل النص الثابت
                      onSaved: (val) => Myemail = val,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) return lang.emailRequired; // استبدل رسالة الخطأ
                        if (!val.contains("@") || !val.contains(".")) {
                          return lang.enterValidEmail; // استبدل رسالة الخطأ
                        }
                        return null;
                      },
                    ),

                    // Password
                    CustomTextField(
                      controller: passController,
                      label: lang.password, // استبدل النص الثابت
                      obscure: true,
                      onSaved: (val) => Mypassword = val,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return lang.passwordRequired; // استبدل رسالة الخطأ
                        }
                        if (val.length < 6) {
                          return lang.passwordMinLength; // استبدل رسالة الخطأ
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
                        child: Text(
                          lang.login, // استبدل النص الثابت
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // forgot password
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reset');
                      },
                      child: Text(
                        lang.forgotPassword, // استبدل النص الثابت
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // dont have an account?
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lang.noAccount, // استبدل النص الثابت
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            lang.join, // استبدل النص الثابت
                            style: const TextStyle(
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
      ),
    );
  }
}