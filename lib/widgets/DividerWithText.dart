import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(text, style: TextStyle(
            color: Colors.grey.withOpacity(0.8)
          ),),
        ),
        const Expanded(
          child: Divider(),
        )
      ],
    );
  }
}
