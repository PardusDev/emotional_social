import 'package:emotional_social/blocs/auth/auth_bloc.dart';
import 'package:emotional_social/screens/post_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/post/post_bloc.dart';
import '../models/Post.dart';
import '../widgets/right_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _postContentController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPosts());
    // TODO: Check user is available
  }

  @override
  void dispose() {
    _postContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
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
                        author: "test",
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
                  return Center(child: CircularProgressIndicator());
                } else if (state is PostLoaded) {
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      final post = state.posts[index];
                      final dateFormat = DateFormat("yyyy.MM.dd HH:mm");

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(), transitionsBuilder: rightTransition )
                          );
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(post.author), //uid
                              Text(" - "),
                              Text(dateFormat.format(DateTime.now()))
                            ],
                          ),
                          subtitle: Text(post.content),
                        ),
                      );
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
