import 'package:flutter/material.dart';


SnackBar errorSnackBar (String text) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.error,
          color: Colors.red,
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
        const Icon(Icons.warning, color: Colors.yellow,),
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
        const Icon(Icons.check_circle, color: Colors.green,),
        const SizedBox(width: 20,),
        Flexible(child: Text(text)),
      ],
    ),
  );
}