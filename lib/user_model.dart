import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String documentId;
  int id;
  String email;
  String name;
  bool isLogged;
  User(this.documentId, this.id, this.email, this.name, this.isLogged);
  factory User.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> querySnapshot) {
    final map = querySnapshot.data();
    return User(querySnapshot.id, map['id'], map['email'], map['name'],
        map['isloged']);
  }
}
