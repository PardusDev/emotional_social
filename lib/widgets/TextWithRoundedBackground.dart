import 'package:flutter/material.dart';

class TextWithRoundedBackground extends StatelessWidget {
  final String text;
  const TextWithRoundedBackground({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Text(text, style: TextStyle(
        color: Colors.white,
        fontSize: 12
      ),),
    );
  }
}
