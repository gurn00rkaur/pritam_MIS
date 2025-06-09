import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirestoreReports {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a new report
  Future<void> addReport({
    required DateTime date, // Change to DateTime
    required String business,
    required String brand,
    required double cash, // Change to double
    required double payment, // Change to double
    required double revenue, // Change to double
    required List<Map<String, dynamic>> expenses, // Change to List of Maps
    required String notes,
  }) async {
    try {
      String reportId = _firestore.collection('Reports').doc().id;
      await _firestore.collection('Reports').add({
        'reportid': reportId,
        'date': Timestamp.fromDate(date), // Store as Timestamp
        'business': business,
        'brand': brand,
        'cash': cash,
        'payment': payment,
        'revenue': revenue,
        'expenses': expenses,
        'notes': notes,
      });
      print("Report added successfully");
    } catch (e) {
      print("Error adding report: $e");
      rethrow;
    }
  }

  // Function to edit an existing report
  Future<void> editReport({
    required String reportId, // Pass the document ID
    required DateTime date, // Change to DateTime
    required String business,
    required String brand,
    required double cash, // Change to double
    required double payment, // Change to double
    required double revenue, // Change to double
    required List<Map<String, dynamic>> expenses, // Change to List of Maps
    required String notes,
  }) async {
    try {
      await _firestore.collection('Reports').doc(reportId).update({
        'date': Timestamp.fromDate(date), // Store as Timestamp
        'business': business,
        'brand': brand,
        'cash': cash,
        'payment': payment,
        'revenue': revenue,
        'expenses': expenses,
        'notes': notes,
      });
      print("Report updated successfully");
    } catch (e) {
      print("Error updating report: $e");
      rethrow;
    }
  }
}
