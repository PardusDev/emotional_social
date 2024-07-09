import 'package:emotional_social/widgets/right_transition.dart';
import 'package:flutter/material.dart';

import '../screens/post_detail_screen.dart';

class HomeScreenPostText extends StatelessWidget {
  final String text;
  final int maxCharacters;
  const HomeScreenPostText({super.key, required this.text, required this.maxCharacters});

  @override
  Widget build(BuildContext context) {
    if (text.length <= maxCharacters) {
      return Text(text);
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, maxCharacters) + '...',
            style: TextStyle(color: Colors.black),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(),
                    transitionsBuilder: rightTransition,
                  ),
                );
              },
              child: Text(
                " Devamını Oku",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
