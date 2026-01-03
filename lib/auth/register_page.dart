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

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'name': Myusername,
          'email': Myemail.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) Navigator.pop(context);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context)!.accountCreatedSuccess), 
              backgroundColor: Colors.green,
            ),
          );
        }

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? S.of(context)!.errorOccurred), 
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
                      onSaved: (val) => Myusername = val,
                      validator: (val) =>
                          val == null || val.isEmpty ? lang.nameRequired : null, 
                    ),

                    // Email
                    CustomTextField(
                      controller: emailController,
                      label: lang.email, 
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => Myemail = val,
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

                    // Confirm Password
                    CustomTextField(
                      controller: confirmController,
                      label: lang.confirmPassword, 
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

                    const SizedBox(height: 24),

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
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
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