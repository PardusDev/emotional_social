part of 'post_bloc.dart';


abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  final Post post;

  const AddPost(this.post);

  @override
  List<Object> get props => [post];
}

class PostsUpdated extends PostEvent {
  final List<Post> posts;

  const PostsUpdated(this.posts);

  @override
  List<Object> get props => [posts];
}

class LoadMorePosts extends PostEvent {}