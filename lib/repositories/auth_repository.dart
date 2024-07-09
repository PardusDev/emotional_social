import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../models/User.dart';

class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<auth.User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<auth.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on auth.FirebaseAuthException {
      return null;
    }
  }

  Future<auth.User?> registerWithEmailAndPassword(String email, String password, String name, String surname) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User newUser = User(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
          surname: surname,
        );
        await _firestore.collection('users').doc(newUser.uid).set(newUser.toDocument());
      }
      return userCredential.user;
    } on auth.FirebaseAuthException {
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> getUserByUID(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromDocument(doc);
    }
    return null;
  }
}