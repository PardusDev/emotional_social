import 'package:emotional_social/theme/colors.dart';
import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool reverse;

  const ContinueButton({
    super.key,
    required this.onPressed,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(
    reverse ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
    color: AppColors.continueButtonTextColor,
    );

    return MaterialButton(
      onPressed: () {
        onPressed();
      },
      height: 55,
      minWidth: 55,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      color: AppColors.continueButtonColor,
      child: icon,
    );
  }
}
