import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content;
  final String authorId;
  final String author;
  final DateTime sharedDate;

  Post({required this.id, required this.content, required this.authorId, required this.author, required this.sharedDate});
}