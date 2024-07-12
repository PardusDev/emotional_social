import 'package:emotional_social/theme/colors.dart';
import 'package:flutter/material.dart';

class UserInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const UserInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 22.0),
        fillColor: AppColors.userInputFieldBackground,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.userInputFieldEnabledBorderColor, width: 2),
              borderRadius: BorderRadius.circular(30)
          ),
          floatingLabelStyle: const TextStyle(color: AppColors.userInputFieldFloatingLabelColor, fontSize: 18),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.userInputFieldFocusedBorderColor, width: 1.5),
              borderRadius: BorderRadius.circular(30)
          )
      ),
      validator: validator,
    );
  }
}
