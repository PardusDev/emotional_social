import 'package:emotional_social/theme/colors.dart';
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
          child: Text(text, style: const TextStyle(
            color: AppColors.dividerTextColor
          ),),
        ),
        const Expanded(
          child: Divider(),
        )
      ],
    );
  }
}
