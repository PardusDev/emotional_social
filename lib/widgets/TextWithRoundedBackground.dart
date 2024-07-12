import 'package:flutter/material.dart';

import '../theme/colors.dart';

class TextWithRoundedBackground extends StatelessWidget {
  final String text;
  const TextWithRoundedBackground({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.dateBackgroundColor,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Text(text, style: const TextStyle(
        color: AppColors.dateTextColor,
        fontSize: 12
      ),),
    );
  }
}
