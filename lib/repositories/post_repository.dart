import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Post.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Post>> getPosts() {
    return _firebaseFirestore.collection('posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post(
          id: doc.id,
          content: doc['content'],
          author: doc['author']
        );
      }).toList();
    });
  }

  Future<void> addPost(Post post) async {
    await _firebaseFirestore.collection('posts').add({
      'content': post.content,
      'author': post.author
    });
  }
}