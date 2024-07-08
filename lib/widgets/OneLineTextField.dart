import 'package:flutter/material.dart';

class OneLineTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  const OneLineTextField({super.key, required this.hintText, required this.controller, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
      ),
    );
  }
}
