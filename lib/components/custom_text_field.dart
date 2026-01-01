import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
  });

  //  Colors
  static const Color textColor = Colors.white;
  static const Color labelColor = Colors.white70;
  static const Color enabledBorderColor = Colors.white38;
  static const Color focusedBorderColor = Colors.white;

  //  Borders
  static const OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: enabledBorderColor),
  );

  static const OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: focusedBorderColor),
  );

  //  Validators
  static String? emailValidator(String? val) {
    if (val == null || val.isEmpty) return "البريد مطلوب";
    if (!val.contains("@") || !val.contains(".")) {
      return "الرجاء إدخال بريد صحيح";
    }
    return null;
  }

  static String? passwordValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "كلمة المرور مطلوبة";
    }
    if (val.length < 6) {
      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
    }
    return null;
  }

  static String? requiredValidator(String? val, String message) {
    if (val == null || val.isEmpty) return message;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        onSaved: onSaved,
        keyboardType: keyboardType, // أضف هذا السطر
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: labelColor),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }
}
