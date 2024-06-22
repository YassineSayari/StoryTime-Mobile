import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storytime/User.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<void> insertUser(User user) async {
    await FirebaseFirestore.instance.collection('users').add(user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('users').get();

    return querySnapshot.docs
        .map((DocumentSnapshot document) =>
        User.fromMap(document.data() as Map<String, dynamic>?, document.id))
        .toList();
  }

  DatabaseHelper();

  Future<User?> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return User.fromMap(
      querySnapshot.docs.first.data() as Map<String, dynamic>?,
      querySnapshot.docs.first.id,
    );
  }

  Future<User?> getUserByEmailAndPassword(
      String email, String password) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return User.fromMap(
      querySnapshot.docs.first.data() as Map<String, dynamic>?,
      querySnapshot.docs.first.id,
    );
  }


  Future<void> updateUser(User user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(user.toMap());
  }

  Future<bool> isUserRegistered(String email) async {
    User? user = await DatabaseHelper.instance.getUserByEmail(email);
    return user != null;
  }

}