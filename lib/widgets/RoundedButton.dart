import 'package:flutter/material.dart';

import '../theme/colors.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double height;
  final EdgeInsetsGeometry padding;
  final String text;
  final TextStyle textStyle;
  const RoundedButton({super.key,
    required this.onPressed,
    required this.text,
    this.height = 55,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    this.textStyle = const TextStyle(color: AppColors.roundedButtonTextColor, fontWeight: FontWeight.w500, fontSize: 18)
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed();
      },
      height: height,
      minWidth: double.infinity,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      color: AppColors.roundedButtonColor,
      child: Text(text, style: textStyle,)
    );
  }
}
