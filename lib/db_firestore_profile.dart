import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Add a new profile to Firestore**
  Future<void> addProfile({
    required String name,
    required String role,
    required String businessName,
  }) async {
    try {
      String profileId = _firestore.collection('Profile').doc().id;

      await _firestore.collection('Profile').doc(profileId).set({
        'profileId': profileId, // ✅ Fixed variable name for consistency
        'firstname': name,
        'role': role,
        'businessName': businessName,
        'createdAt': FieldValue.serverTimestamp(), // ✅ Add timestamp
      });

      print("Profile added successfully");
    } catch (e) {
      print("🔥 Error adding profile: $e");
      rethrow;
    }
  }

  /// **Edit an existing profile in Firestore**
  Future<void> editProfile({
    required String profileId,
    required String name,
    required String role,
    required String businessName,
  }) async {
    try {
      await _firestore.collection('Profile').doc(profileId).update({
        'firstname': name,
        'role': role,
        'businessName': businessName,
        'updatedAt': FieldValue.serverTimestamp(), // ✅ Track last update
      });

      print("✅ Profile updated successfully");
    } catch (e) {
      print("🔥 Error updating profile: $e");
      rethrow;
    }
  }

  /// **Fetch profile by ID**
  Future<Map<String, dynamic>?> getProfileById(String profileId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Profile').doc(profileId).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print("❌ Profile not found");
        return null;
      }
    } catch (e) {
      print("🔥 Error fetching profile: $e");
      return null;
    }
  }
}
