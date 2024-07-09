import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Post.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Post>> getPosts({required int page, int pageSize = 10}) {
    return _firebaseFirestore
        .collection('posts')
        .orderBy('sharedDate', descending: true)
        .limit(page * pageSize)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Post> posts = [];
      for (var doc in snapshot.docs) {
        final postData = doc.data() as Map<String, dynamic>;
        final userDoc = await _firebaseFirestore.collection('users').doc(postData['authorId']).get();
        final userData = userDoc.data() as Map<String, dynamic>;

        final post = Post(
          id: doc.id,
          content: postData['content'],
          authorId: postData["authorId"],
          author: "${userData["name"]} ${userData["surname"]}",
          sharedDate: postData["sharedDate"].toDate()
        );
        posts.add(post);
      }
      return posts;
    });
  }

  Future<void> addPost(Post post) async {
    await _firebaseFirestore.collection('posts').add({
      'content': post.content,
      'authorId': post.authorId,
      'sharedDate': DateTime.now()
    });
  }
}