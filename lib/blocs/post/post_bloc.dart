import 'package:bloc/bloc.dart';
import 'package:emotional_social/repositories/post_repository.dart';
import 'package:equatable/equatable.dart';

import '../../models/Post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  int _currentPage = 1;
  static const int _pageSize = 10;

  PostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(PostInitial()) {
    on<LoadPosts>((event, emit) async {
      _currentPage = 1;
      emit(PostLoading());
      final posts = await _postRepository.getPosts(page: _currentPage, pageSize: _pageSize);
      add(PostsUpdated(posts));
    });

    on<AddPost>((event, emit) async {
      await _postRepository.addPost(event.post);
      if (state is PostLoaded) {
        final currentState = state as PostLoaded;
        final updatedPosts = [event.post, ...currentState.posts];
        emit(currentState.copyWith(posts: updatedPosts));
      } else {
        add(LoadPosts());
      }
    });

    on<PostsUpdated>((event, emit) {
      emit(PostLoaded(posts: event.posts, hasReachedMax: event.posts.length < _pageSize));
    });

    on<LoadMorePosts>((event, emit) async {
      if (state is PostLoaded) {
        final currentState = state as PostLoaded;
        if (currentState.hasReachedMax) return;

        _currentPage++;
        final posts = await _postRepository.getPosts(page: _currentPage, pageSize: _pageSize);
        emit(posts.isEmpty ? currentState.copyWith(hasReachedMax: true)
        : PostLoaded(posts: currentState.posts + posts, hasReachedMax: posts.length < _pageSize));
      }
    });
  }
}