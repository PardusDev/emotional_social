import 'package:bloc/bloc.dart';
import 'package:emotional_social/repositories/post_repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/Post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  int _currentPage = 1;

  PostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(PostInitial()) {
    on<LoadPosts>((event, emit) {
      emit(PostLoading());
      _postRepository.getPosts(page: 1).listen((posts) {
        add(PostsUpdated(posts));
      });
    });

    on<AddPost>((event, emit) async {
      await _postRepository.addPost(event.post);
    });

    on<PostsUpdated>((event, emit) {
      emit(PostLoaded(posts: event.posts));
    });

    on<LoadMorePosts>((event, emit) async {
      if (state is PostLoaded) {
        final currentState = state as PostLoaded;
        if (currentState.hasReachedMax) return;

        _currentPage++;
        final posts = await _postRepository.getPosts(page: _currentPage).first;
        emit(posts.isEmpty ? currentState.copyWith(hasReachedMax: true)
        : PostLoaded(posts: currentState.posts + posts));
      }
    });
  }
}