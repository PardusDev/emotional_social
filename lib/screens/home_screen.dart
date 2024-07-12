import 'package:emotional_social/blocs/auth/auth_bloc.dart';
import 'package:emotional_social/screens/post_detail_screen.dart';
import 'package:emotional_social/theme/colors.dart';
import 'package:emotional_social/utilities/date_format.dart';
import 'package:emotional_social/widgets/HomeScreenPostText.dart';
import 'package:emotional_social/widgets/TextWithRoundedBackground.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final authState = context.watch<AuthBloc>().state;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Emotional Social'),
        backgroundColor: AppColors.homePageAppBarBgColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()),
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
                  const SizedBox(height: 6.0,),
                  TextField(
                    controller: _postContentController,
                    decoration: InputDecoration(
                      labelText: 'Share your emotions',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: AppColors.sendButtonBg,),
                        onPressed: () async {
                          final content = _postContentController.text;
                          if (content.isNotEmpty) {
                            if (authState is AuthAuthenticated) {
                              //DEPRECATED: final userInfo = await _authRepository.getUserByUID(user!.uid);
                              final post = Post(
                                  id: DateTime.now().toString(),
                                  content: content,
                                  authorId: user!.uid,
                                  author: authState.userModel.surname.isEmpty ? authState.userModel.name : "${authState.userModel.name} ${authState.userModel.surname}",
                                  emotion: _selectedEmotion,
                                  sharedDate: DateTime.now()
                              );
                              context.read<PostBloc>().add(AddPost(post));
                              _postContentController.clear();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28.0),
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
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: _selectedEmotion == emotion
                                    ? AppColors.selectedEmotionBg
                                    : AppColors.unSelectedEmotionBg,
                              ),
                              child: Image.asset(
                                getEmotionAsset(emotion),
                                height: 40,
                                width: 40,
                              ),
                            ),
                            if (_selectedEmotion == emotion)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.selectedEmotionBg,
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
            const SizedBox(height: 8.0,),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: LoadingDot(),
                    ));
                  } else if (state is PostLoaded) {
                    if (state.posts.isEmpty) {
                      return const Center(child: Text('No posts yet. 😥', style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),),);
                    }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 18,
                    ),
                    itemCount: state.hasReachedMax
                                ? state.posts.length
                                : state.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.posts.length) {
                        return state.hasReachedMax
                            ? Container()
                            : const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 18.0),
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
                            shadowColor: AppColors.shadowColor,
                            child: ListTile(
                              tileColor: AppColors.homePagePostBgColor,
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(post.author, style: const TextStyle(
                                        color: AppColors.authorNameSurnameColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      ),), //uid
                                      const SizedBox(width: 10.0,),
                                      const Icon(Icons.circle, size: 8.0, color: AppColors.separatorDotColor,),
                                      const SizedBox(width: 10.0,),
                                      TextWithRoundedBackground(text: dateFormat),
                                    ],
                                  ),
                                  const SizedBox(height: 6.0,),
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
                  return const Center(child: Text('No posts yet.'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
