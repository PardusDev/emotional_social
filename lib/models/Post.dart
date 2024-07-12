
class Post {
  final String id;
  final String content;
  final String authorId;
  final String author;
  final int emotion;
  final DateTime sharedDate;

  Post({required this.id, required this.content, required this.authorId, required this.author, required this.sharedDate, required this.emotion});
}