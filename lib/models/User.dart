import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String surname;

  User({required this.uid, required this.email, required this.name, required this.surname});

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User (
      uid: data["uid"],
      email: data["email"],
      name: data["name"],
      surname: data["surname"]
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'surname': surname
    };
  }
}