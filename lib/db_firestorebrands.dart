import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirestoreBrands {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new brand
  Future<void> addBrand({
    required String businessId, // ✅ Pass businessId as a parameter
    required String brandName,
    required String gstNumber,
    required String address,
    required String city,
    required String state,
    required String pinCode,
  }) async {
    try {
      String brandId = _firestore.collection('brand').doc().id;

      await _firestore.collection('brand').doc(brandId).set({
        'Brandname': brandName,
        'gstNumber': gstNumber,
        'address': address,
        'city': city,
        'state': state,
        'pinCode': pinCode,
        'businessId': businessId, // ✅ Ensure correct businessId is added
      });
    } catch (e) {
      throw Exception("Failed to add brand: $e");
    }
  }

  // Update an existing brand
  Future<void> editBrand({
    required String brandId,
    required String brandName,
    required String gstNumber,
    required String address,
    required String city,
    required String state,
    required String pinCode,
  }) async {
    try {
      await _firestore.collection('brand').doc(brandId).update({
        'Brandname': brandName,
        'gstNumber': gstNumber,
        'address': address, // ✅ Use correct field names
        'city': city,
        'state': state,
        'pinCode': pinCode,
      });
    } catch (e) {
      throw Exception("Failed to edit brand: $e");
    }
  }
}
