import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser({
    required String name,
    required String email,
    required String password,
    required String confirmpassword,
    required String businessName,
    required String role,
  }) async {
    try {
      String userId =
          _firestore.collection('users').doc().id; // Generate a new user ID

      await _firestore.collection('users').doc(userId).set({
        'id': userId,
        'name': name,
        'email': email,
        'businessName': businessName,
        'role': role,
        'password': password,
        'confirmpassword': confirmpassword,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception("Failed to add user: $e");
    }
  }

  Future<void> editUser({
    required String name,
    required String email,
    required String password,
    required String confirmpassword,
    required String businessName,
    required String role,
  }) async {
    try {
      String userId =
          _firestore.collection('users').doc().id; // Generate a new user ID

      await _firestore.collection('users').doc(userId).set({
        'id': userId,
        'name': name,
        'email': email,
        'businessName': businessName,
        'role': role,
        'password': password,
        'confirmpassword': confirmpassword,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception("Failed to add user: $e");
    }
  }
}
