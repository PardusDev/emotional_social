import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Post.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Post>> getPosts({required int page, int pageSize = 10}) async {
    Query query = _firebaseFirestore
        .collection('posts')
        .orderBy('sharedDate', descending: true)
        .limit(pageSize);

    if (page > 1) {
      final startAfterDoc = await _getStartAfterDoc((page - 1) * pageSize);
      query = query.startAfterDocument(startAfterDoc);
    }

    final snapshot = await query.get();

    List<Post> posts = [];
    for (var doc in snapshot.docs) {
      final postData = doc.data() as Map<String, dynamic>;
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(postData['authorId'])
          .get();
      final userData = userDoc.data() as Map<String, dynamic>;

      final post = Post(
        id: doc.id,
        content: postData['content'],
        authorId: postData["authorId"],
        author: userData["surname"].isNotEmpty ? "${userData["name"]}" : "${userData["name"]} ${userData["surname"]}",
        emotion: postData["emotion"],
        sharedDate: postData["sharedDate"].toDate()
      );
      posts.add(post);
    }
    return posts;
  }

  Future<DocumentSnapshot> _getStartAfterDoc(int startAt) async {
    final snapshot = await _firebaseFirestore
        .collection('posts')
        .orderBy('sharedDate', descending: true)
        .limit(startAt)
        .get();
    return snapshot.docs.last;
  }

  Future<void> addPost(Post post) async {
    await _firebaseFirestore.collection('posts').add({
      'content': post.content,
      'authorId': post.authorId,
      'emotion': post.emotion,
      'sharedDate': DateTime.now()
    });
  }
}