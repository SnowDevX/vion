import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grandustionapp/components/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grandustionapp/generated/l10n.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var Myusername, Myemail, Mypassword;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF44C37F)),
          ),
        );

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: Myemail.trim(),
              password: Mypassword.trim(),
            );

        await userCredential.user!.updateDisplayName(Myusername);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'uid': userCredential.user!.uid,
              'name': Myusername,
              'email': Myemail.trim(),
              'height': 76,
              'weight': 82, 
              'dailyStepsGoal': 10000,
              'notifications': true,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            });

        if (mounted) Navigator.pop(context);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context)!.accountCreatedSuccess),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }

        // 4. الانتقال مباشرة إلى الصفحة الرئيسية بعد التسجيل
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) Navigator.pop(context);

        String errorMessage = S.of(context)!.errorOccurred;

        if (e.code == 'weak-password') {
          errorMessage = 'كلمة المرور ضعيفة، يجب أن تكون 6 أحرف على الأقل';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'هذا البريد الإلكتروني مستخدم بالفعل';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'بريد إلكتروني غير صالح';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      } catch (e) {
        if (mounted) Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ غير متوقع: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
                  children: [
                    const SizedBox(height: 40),
                    Image.asset("assets/logo/logo.png", width: 120),
                    const SizedBox(height: 30),

                    Text(
                      lang.joinVion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // UserName
                    CustomTextField(
                      controller: nameController,
                      label: lang.name,
                      hintText: "أدخل اسمك الكامل",
                      onSaved: (val) => Myusername = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? lang.nameRequired : null,
                      isRTL: null,
                    ),

                    const SizedBox(height: 16),

                    // Email
                    CustomTextField(
                      controller: emailController,
                      label: lang.email,
                      hintText: "example@email.com",
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => Myemail = val,
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return lang.emailRequired;
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                          return lang.enterValidEmail;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password
                    CustomTextField(
                      controller: passController,
                      label: lang.password,
                      hintText: "6 أحرف على الأقل",
                      obscure: true,
                      onSaved: (val) => Mypassword = val,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return lang.passwordRequired;
                        }
                        if (val.length < 6) {
                          return lang.passwordMinLength;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password
                    CustomTextField(
                      controller: confirmController,
                      label: lang.confirmPassword,
                      hintText: "أعد إدخال كلمة المرور",
                      obscure: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return lang.confirmPasswordRequired;
                        }
                        if (val != passController.text) {
                          return lang.passwordsNotMatch;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                    ),

                    const SizedBox(height: 30),

                    // Register Button
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
                        onPressed: _registerUser,
                        child: Text(
                          lang.createAccount,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Already have an account? Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "لديك حساب بالفعل؟ ",
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              color: const Color(0xFF44C37F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
