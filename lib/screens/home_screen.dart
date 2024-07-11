import 'package:emotional_social/blocs/auth/auth_bloc.dart';
import 'package:emotional_social/screens/post_detail_screen.dart';
import 'package:emotional_social/utilities/date_format.dart';
import 'package:emotional_social/widgets/HomeScreenPostText.dart';
import 'package:emotional_social/widgets/TextWithRoundedBackground.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/post/post_bloc.dart';
import '../models/Post.dart';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
                        sharedDate: DateTime.now()
                      );
                      context.read<PostBloc>().add(AddPost(post));
                      _postContentController.clear();
                    }
                  },
                )
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: LoadingDot(),
                  ));
                } else if (state is PostLoaded) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 18,
                    ),
                    controller: _scrollController,
                    itemCount: state.hasReachedMax
                                ? state.posts.length
                                : state.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.posts.length) {
                        return Center(child: Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: LoadingDot(),
                        ),);
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
                              title: Row(
                                children: [
                                  Text(post.author, style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),), //uid
                                  SizedBox(width: 10.0,),
                                  Icon(Icons.circle, size: 8.0, color: Colors.black.withOpacity(0.4),),
                                  SizedBox(width: 10.0,),
                                  TextWithRoundedBackground(text: dateFormat)
                                ],
                              ),
                              subtitle: HomeScreenPostText(text: post.content,
                                maxCharacters: 65,
                                post: post,),
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
            ),
          )
        ],
      ),
    );
  }
}
