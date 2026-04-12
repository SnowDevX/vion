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
    final lang = S.of(context)!; 
    final isRTL = Localizations.localeOf(context).languageCode == 'ar'; 

    return Directionality(
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
                      lang.welcomeBack, 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      lang.loginToContinue, 
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),

                    const SizedBox(height: 40),
                    
                    // Email or Username
                    CustomTextField(
                      controller: emailController,
                      label: lang.emailOrUsername, 
                      onSaved: (val) => Myemail = val,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) return lang.emailRequired; 
                        if (!val.contains("@") || !val.contains(".")) {
                          return lang.enterValidEmail; 
                        }
                        return null;
                      },
                    ),

                    // Password
                    CustomTextField(
                      controller: passController,
                      label: lang.password,
                      obscure: true,
                      onSaved: (val) => Mypassword = val,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return lang.passwordRequired; 
                        }
                        if (val.length < 6) {
                          return lang.passwordMinLength; 
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

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: Myemail.trim(),
                                    password: Mypassword.trim(),
                                  );
                              
                              print(" USER LOGGED IN SUCCESSFULLY");
                              
                              
                            } on FirebaseAuthException catch (e) {
                              String errorMessage = 'حدث خطأ في تسجيل الدخول';
                              
                              if (e.code == 'user-not-found') {
                                errorMessage = 'لا يوجد مستخدم بهذا البريد الإلكتروني';
                              } else if (e.code == 'wrong-password') {
                                errorMessage = 'كلمة المرور غير صحيحة';
                              } else if (e.code == 'invalid-email') {
                                errorMessage = 'بريد إلكتروني غير صالح';
                              }
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('حدث خطأ: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          lang.login, 
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
                        lang.forgotPassword, 
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
                            lang.noAccount, 
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            lang.join, 
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

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}