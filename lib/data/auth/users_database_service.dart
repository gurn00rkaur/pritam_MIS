import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pritam_manage_info_sys/data/auth/users_model.dart';

class UsersDatabaseService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Save or update user details
  Future<void> saveUserDetails(UsersModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to save user details: $e');
    }
  }

  // Get user details by user ID
  Future<UsersModel?> getUserById(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();
      if (docSnapshot.exists) {
        // Cast the data to Map<String, dynamic>
        final data = docSnapshot.data() as Map<String, dynamic>;
        return UsersModel.fromMap(data, docSnapshot.id);
      }
    } catch (e) {
      throw Exception('Failed to get user details: $e');
    }
    return null;
  }
}
