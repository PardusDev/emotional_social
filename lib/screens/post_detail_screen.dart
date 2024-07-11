import 'package:emotional_social/utilities/date_format.dart';
import 'package:emotional_social/widgets/TextWithRoundedBackground.dart';
import 'package:flutter/material.dart';

import '../models/Emotion.dart';
import '../models/Post.dart';
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
      backgroundColor: Color.fromRGBO(233, 235, 238, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Post Detail"),
      ),
      body: Column(
        children: [
          Material(
            elevation: 1.0,
            child: Container(
              color: Colors.white, // Beyaz arka plan
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        post.author,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ), //uid
                      SizedBox(width: 10.0),
                      Icon(
                        Icons.circle,
                        size: 8.0,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      SizedBox(width: 10.0),
                      TextWithRoundedBackground(text: dateFormat),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Your friend feels ${Emotion.getEmotionName(post.emotion)}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Image.asset(
                        getEmotionAsset(post.emotion),
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    post.content,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
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
              color: Color.fromRGBO(233, 235, 238, 1.0), // Gri arka plan
            ),
          ),
        ],
      ),
    );
  }
}