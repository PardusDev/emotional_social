import 'package:emotional_social/widgets/right_transition.dart';
import 'package:flutter/material.dart';

import '../models/Post.dart';
import '../screens/post_detail_screen.dart';
import '../theme/colors.dart';

class HomeScreenPostText extends StatefulWidget {
  final String text;
  final int maxCharacters;
  final Post post;
  const HomeScreenPostText({super.key, required this.text, required this.maxCharacters, required this.post});

  @override
  State<HomeScreenPostText> createState() => _HomeScreenPostTextState();
}

class _HomeScreenPostTextState extends State<HomeScreenPostText> {
  late TextStyle textStyle = const TextStyle(
      color: AppColors.postContentTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );

  @override
  Widget build(BuildContext context) {
    if (widget.text.length <= widget.maxCharacters) {
      return Text(widget.text, style: textStyle,);
    }
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${widget.text.substring(0, widget.maxCharacters)}...',
            style: textStyle,
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(post: widget.post),
                    transitionsBuilder: rightTransition,
                  ),
                );
              },
              child: const Text(
                " Read More",
                style: TextStyle(color: AppColors.readMoreTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
