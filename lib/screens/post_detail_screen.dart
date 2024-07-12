import 'package:emotional_social/utilities/date_format.dart';
import 'package:emotional_social/widgets/TextWithRoundedBackground.dart';
import 'package:flutter/material.dart';

import '../models/Emotion.dart';
import '../models/Post.dart';
import '../theme/colors.dart';
import '../utilities/asset_loader.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Post post;

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = formatAccordingToNow(post.sharedDate);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.postDetailPageAppBarBgColor,
        title: const Text("Post Detail"),
      ),
      body: Column(
        children: [
          Material(
            elevation: 1.0,
            child: Container(
              color: AppColors.postBg,
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.author,
                        style: const TextStyle(
                          color: AppColors.authorNameSurnameColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ), //uid
                      const SizedBox(width: 10.0),
                      const Icon(
                        Icons.circle,
                        size: 8.0,
                        color: AppColors.separatorDotColor,
                      ),
                      const SizedBox(width: 10.0),
                      TextWithRoundedBackground(text: dateFormat),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Your friend feels ${Emotion.getEmotionName(post.emotion)}',
                        style: const TextStyle(
                          color: AppColors.postFeelTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Image.asset(
                        getEmotionAsset(post.emotion),
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    post.content,
                    style: const TextStyle(
                      color: AppColors.postContentTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}