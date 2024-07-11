import 'package:emotional_social/widgets/right_transition.dart';
import 'package:flutter/material.dart';

import '../models/Post.dart';
import '../screens/post_detail_screen.dart';

class HomeScreenPostText extends StatelessWidget {
  final String text;
  final int maxCharacters;
  final Post post;
  HomeScreenPostText({super.key, required this.text, required this.maxCharacters, required this.post});

  late TextStyle textStyle = TextStyle(
      color: Colors.black.withOpacity(0.6),
      fontSize: 14,
      fontWeight: FontWeight.w600
  );

  @override
  Widget build(BuildContext context) {
    if (text.length <= maxCharacters) {
      return Text(text, style: textStyle,);
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, maxCharacters) + '...',
            style: textStyle,
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(post: post),
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
