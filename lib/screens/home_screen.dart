import 'package:emotional_social/blocs/auth/auth_bloc.dart';
import 'package:emotional_social/screens/post_detail_screen.dart';
import 'package:emotional_social/utilities/date_format.dart';
import 'package:emotional_social/widgets/HomeScreenPostText.dart';
import 'package:emotional_social/widgets/TextWithRoundedBackground.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/emotion/emotion_bloc.dart';
import '../blocs/emotion/emotion_state.dart';
import '../blocs/post/post_bloc.dart';
import '../models/Emotion.dart';
import '../models/Post.dart';
import '../utilities/asset_loader.dart';
import '../widgets/LoadingDot.dart';
import '../widgets/right_transition.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _postContentController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  late ScrollController _scrollController;
  late PostBloc _postBloc;

  int _selectedEmotion = 1;
  final List<int> emotions = [1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<PostBloc>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _postBloc.add(LoadPosts());
    // TODO: Check user is available
  }

  void _onScroll() {
    if (_isEnd) _postBloc.add(LoadMorePosts());
  }

  bool get _isEnd {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  bool _hasReachedMaxState () {
    final state = _postBloc.state;
    if (state is PostLoaded) {
      return state.hasReachedMax;
    }
    return false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _postContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(233, 235, 238, 1.0),
      appBar: AppBar(
        title: Text('Emotional Social'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 6.0,),
                  TextField(
                    controller: _postContentController,
                    decoration: InputDecoration(
                      labelText: 'Share your emotions',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          final content = _postContentController.text;
                          if (content.isNotEmpty) {
                            final post = Post(
                                id: DateTime.now().toString(),
                                content: content,
                                authorId: user!.uid,
                                author: user!.displayName.toString(),
                                emotion: _selectedEmotion,
                                sharedDate: DateTime.now()
                            );
                            context.read<PostBloc>().add(AddPost(post));
                            _postContentController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 28.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: emotions.map((emotion) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEmotion = emotion;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset(
                                getEmotionAsset(emotion),
                                height: 40,
                                width: 40,
                              ),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: _selectedEmotion == emotion
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                            if (_selectedEmotion == emotion)
                              Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 20,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0,),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return Center(child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: LoadingDot(),
                    ));
                  } else if (state is PostLoaded) {
                    if (state.posts.isEmpty) {
                      return Center(child: Text('No posts yet. 😥', style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),),);
                    }
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 18,
                    ),
                    itemCount: state.hasReachedMax
                                ? state.posts.length
                                : state.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.posts.length) {
                        return state.hasReachedMax  // Bu kontrol eklendi
                            ? Container()
                            : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: LoadingDot(),
                          ),
                        );
                      } else {
                        final post = state.posts[index];
                        final dateFormat = formatAccordingToNow(post.sharedDate);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                    PostDetailPage(post: post),
                                transitionsBuilder: rightTransition)
                            );
                          },
                          child: Material(
                            elevation: 4.0,
                            shadowColor: Colors.grey.withOpacity(0.3),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(post.author, style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      ),), //uid
                                      SizedBox(width: 10.0,),
                                      Icon(Icons.circle, size: 8.0, color: Colors.black.withOpacity(0.4),),
                                      SizedBox(width: 10.0,),
                                      TextWithRoundedBackground(text: dateFormat),
                                    ],
                                  ),
                                  SizedBox(height: 6.0,),
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
                                ],
                              ),
                              subtitle:
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: HomeScreenPostText(text: post.content,
                                    maxCharacters: 65,
                                    post: post,),
                                ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return Center(child: Text('No posts yet.'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
