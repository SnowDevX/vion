import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grandustionapp/components/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            const SnackBar(
              content: Text('تم إنشاء الحساب بنجاح!'),
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
            content: Text(e.message ?? 'حدث خطأ'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
                children: [
                  const SizedBox(height: 40),
                  Image.asset("assets/logo/logo.png", width: 120),
                  const SizedBox(height: 30),

                  const Text(
                    "انضم إلى VION",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),
                  // في صفحة التسجيل
                  //UserName
                  CustomTextField(
                    controller: nameController,
                    label: "الاسم",
                    onSaved: (val) => Myusername = val,
                    validator: (val) =>
                        val == null || val.isEmpty ? "الاسم مطلوب" : null,
                    // لا تحتاج keyboardType هنا - ستستخدم القيمة الافتراضية TextInputType.text
                  ),

                  //Email
                  CustomTextField(
                    controller: emailController,
                    label: "البريد الإلكتروني",
                    keyboardType: TextInputType.emailAddress, // هنا تحتاجه
                    onSaved: (val) => Myemail = val,
                    validator: CustomTextField.emailValidator,
                  ),

                  //Password
                  CustomTextField(
                    controller: passController,
                    label: "كلمة المرور",
                    obscure: true,
                    onSaved: (val) => Mypassword = val,
                    validator: CustomTextField.passwordValidator,
                    // يمكنك إضافة keyboardType إذا أردت
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  //Confirm Password
                  CustomTextField(
                    controller: confirmController,
                    label: "تأكيد كلمة المرور",
                    obscure: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "تأكيد كلمة المرور مطلوب";
                      }
                      if (val != passController.text) {
                        return "كلمة المرور غير متطابقة";
                      }
                      return null;
                    },
                    // يمكنك إضافة keyboardType إذا أردت
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
                      child: const Text(
                        "إنهاء الحساب",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
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
