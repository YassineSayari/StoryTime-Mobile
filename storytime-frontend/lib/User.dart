import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String firstName;
  String lastName;
  String email;
  String password;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic>? map, String documentId) {
    if (map == null) {
      // Handle the case where the map is null (e.g., document doesn't exist)
      return User(
        id: documentId,
        firstName: '',
        lastName: '',
        email: '',
        password: '',
      );
    }

    return User(
      id: documentId,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}