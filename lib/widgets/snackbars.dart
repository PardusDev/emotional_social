import 'package:emotional_social/theme/colors.dart';
import 'package:flutter/material.dart';


SnackBar errorSnackBar (String text) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.error,
          color: AppColors.errorSnackBarIconColor,
        ),
        const SizedBox(
          width: 6,
        ),
        Flexible(child: Text(text)),
      ],
    ),
  );
}

SnackBar warningSnackBar (String text) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.warning, color: AppColors.warningSnackBarIconColor,),
        const SizedBox(width: 20,),
        Flexible(child: Text(text)),
      ],
    ),
  );
}

SnackBar successSnackBar (String text) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check_circle, color: AppColors.successSnackBarIconColor,),
        const SizedBox(width: 20,),
        Flexible(child: Text(text)),
      ],
    ),
  );
}