import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grandustionapp/components/custom_text_field.dart';
import 'package:grandustionapp/generated/l10n.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.resetLinkSent), // استبدل النص الثابت
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        final lang = S.of(context)!; // احصل على النصوص المترجمة

        switch (e.code) {
          case 'user-not-found':
            errorMessage = lang.userNotFound; // استبدل النص الثابت
            break;
          case 'invalid-email':
            errorMessage = lang.invalidEmail; // استبدل النص الثابت
            break;
          case 'user-disabled':
            errorMessage = lang.accountDisabled; // استبدل النص الثابت
            break;
          default:
            errorMessage = e.message ?? lang.resetError; // استبدل النص الثابت
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context)!.unexpectedError), // استبدل النص الثابت
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context)!; // الحصول على النصوص المترجمة
    final isRTL =
        Localizations.localeOf(context).languageCode ==
        'ar'; // تحديد اتجاه النص

    return Directionality(
      // أضف هذا الـ Directionality
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
                    const SizedBox(height: 40),

                    Text(
                      lang.resetPassword, // استبدل النص الثابت
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      lang.enterEmailForReset, // استبدل النص الثابت
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // reset email field
                    CustomTextField(
                      controller: emailController,
                      label: lang.email, // استبدل النص الثابت
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return lang.pleaseEnterEmail; // استبدل رسالة الخطأ
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return lang
                              .enterValidEmailPlease; // استبدل رسالة الخطأ
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // reset password button
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
                        onPressed: _isLoading ? null : _resetPassword,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                lang.sendResetLink, // استبدل النص الثابت
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // back to login button
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: Text(
                        lang.backToLogin, // استبدل النص الثابت
                        style: const TextStyle(color: Colors.white70),
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
