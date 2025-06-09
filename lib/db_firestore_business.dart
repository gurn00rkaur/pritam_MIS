import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirestoreBusiness {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBusiness({
    required String businessName,
    required String gstnumber,
    required String address,
    required String city,
    required String state,
    required String pinCode,
  }) async {
    try {
      String businessId =
          _firestore.collection('Business').doc().id; // Generate ID

      await _firestore.collection('Business').doc(businessId).set({
        // Use .set() instead of .add()
        'Businessid': businessId,
        'Businessname': businessName,
        'gstnumber': gstnumber,
        'address': address,
        'city': city,
        'state': state,
        'pinCode': pinCode,
      });

      print("Business added successfully: $businessId");
    } catch (e) {
      throw Exception("Failed to add business: $e");
    }
  }

  Future<void> editBusiness({
    required String businessId,
    required String businessName,
    required String gstnumber,
    required String address,
    required String city,
    required String state,
    required String pinCode,
  }) async {
    try {
      await _firestore.collection('Business').doc(businessId).update({
        'Businessname': businessName,
        'gstnumber': gstnumber,
        'address': address,
        'city': city,
        'state': state,
        'pinCode': pinCode,
      });

      print("Business updated successfully: $businessId");
    } catch (e) {
      throw Exception("Failed to update business: $e");
    }
  }
}
