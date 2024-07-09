part of 'post_bloc.dart';


abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  const PostLoaded({required this.posts, this.hasReachedMax = false});

  @override
  List<Object> get props => [posts, hasReachedMax];

  PostLoaded copyWith({List<Post>? posts, bool? hasReachedMax}) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }
}