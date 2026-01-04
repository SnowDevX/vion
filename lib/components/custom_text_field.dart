import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;
  final String? hintText;
  final bool? isRTL; 

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.isRTL, 
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = isRTL != null
        ? (isRTL! ? TextDirection.rtl : TextDirection.ltr)
        : (Localizations.localeOf(context).languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        onSaved: onSaved,
        keyboardType: keyboardType,
        textDirection: textDirection,
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: labelColor),
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
        ),
      ),
    );
  }

  static const Color textColor = Colors.white;
  static const Color labelColor = Colors.white70;
  static const Color enabledBorderColor = Colors.white38;
  static const Color focusedBorderColor = Colors.white;

  static const OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: enabledBorderColor),
  );

  static const OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: focusedBorderColor),
  );
}