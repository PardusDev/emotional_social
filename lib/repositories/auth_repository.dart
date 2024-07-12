import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/User.dart';

class AuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({auth.FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

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
    await _googleSignIn.signOut();
  }

  Future<User?> getUserByUID(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromDocument(doc);
    }
    return null;
  }

  Future<auth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // User has stopped login
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Store new user on Firestore
      if (userCredential.additionalUserInfo!.isNewUser) {
        User newUser = User(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? '',
          surname: '', // Maybe we cant get surname with Google API
        );
        await _firestore.collection('users').doc(newUser.uid).set(newUser.toDocument());
      }

      return userCredential.user;
    } on auth.FirebaseAuthException catch (e) {
      Exception('Firebase Google Auth Exception: ${e.message}');
      return null;
    } catch (e) {
      Exception('Firebase Google Auth GENERAL Exception: ${e.toString()}');
      return null;
    }
  }
}