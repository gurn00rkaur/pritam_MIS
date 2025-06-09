import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_confirmationdialog.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pritam_manage_info_sys/presentation/features/reports/addreport.dart';
import 'package:pritam_manage_info_sys/presentation/features/reports/editreport.dart';
import 'package:pritam_manage_info_sys/presentation/features/reports/reportcard.dart';

class Reportpage extends StatefulWidget {
  const Reportpage({super.key});

  @override
  State<Reportpage> createState() => _ReportpageState();
}

class _ReportpageState extends State<Reportpage> {
  List<Map<String, dynamic>> reportList = [];
  String? selectedBusiness;
  String? selectedBrand;
  List<Map<String, dynamic>> filteredReports = [];
  DateTime? startDate;
  DateTime? endDate;
  String? userRole; // To store the user role
  bool _onReportEdited = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole(); // Fetch user role when the page is initialized
    _fetchReports(); // Fetch reports
  }

  Future<void> _fetchUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userRole = userDoc['role']; // Store the user role
          });
        }
      } catch (e) {
        _showSnackbar("Error fetching user role: $e");
      }
    }
  }

  void _fetchReports({DateTime? startDate, DateTime? endDate}) async {
    print("Fetching reports...");
    try {
      Query query = FirebaseFirestore.instance.collection('Reports');

      // Apply date filtering if startDate and endDate are provided
      if (startDate != null && endDate != null) {
        query = query
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final QuerySnapshot snapshot = await query.get();

      print("Fetched ${snapshot.docs.length} reports");

      setState(() {
        reportList = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          print("Raw Firestore Data: $data");

          List<Map<String, dynamic>> expensesList = [];
          if (data['expenses'] is List) {
            // Change 'expense' to 'expenses'
            expensesList = (data['expenses'] as List)
                .whereType<Map<String, dynamic>>() // Ensure it's a list of maps
                .toList();
          }

          num totalExpense = expensesList.fold(0, (sum, e) {
            num quantity = _parseNum(e['quantity']);
            num rate = _parseNum(e['rate']);
            return sum + (quantity * rate);
          });

          return {
            'id': doc.id,
            'date': (data['date'] as Timestamp)
                .toDate(), // Convert Timestamp to DateTime
            'cash': _parseNum(data['cash']),
            'payment': _parseNum(data['payment']),
            'revenue': _parseNum(data['revenue']),
            'expenses': expensesList, // Ensure this is the correct key
            'totalExpense': totalExpense,
            'notes': data['notes'] ?? '',
            'brand': data['brand'] ?? '',
            'business': data['business'] ?? '',
          };
        }).toList();

        // Sort reports by date in ascending order
        reportList.sort((a, b) => a['date'].compareTo(b['date']));

        filteredReports = List.from(reportList);
      });
    } catch (e) {
      _showSnackbar("Error fetching reports: $e");
    }
  }

  void _filterReports() {
    setState(() {
      filteredReports = reportList.where((report) {
        bool matchesBusiness = selectedBusiness == null ||
            selectedBusiness!.isEmpty ||
            report['business'] == selectedBusiness;

        bool matchesDate = startDate == null ||
            endDate == null ||
            (report['date'] != null &&
                report['date'].isAfter(startDate!
                    .subtract(Duration(days: 1))) && // Include start date
                report['date'].isBefore(
                    endDate!.add(Duration(days: 1)))); // Include end date

        return matchesBusiness && matchesDate;
      }).toList();

      // Sort filtered reports by date in ascending order
      filteredReports.sort((a, b) => a['date'].compareTo(b['date']));
    });
  }

  num _parseNum(dynamic value) {
    if (value is num) return value;
    if (value == null || value.toString().trim().isEmpty) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  void _deleteReport(String reportId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomConfirmationDialog(
          onConfirm: () async {
            try {
              await FirebaseFirestore.instance
                  .collection('Reports')
                  .doc(reportId)
                  .delete();
              _fetchReports(); // Refresh list after deletion
              Navigator.of(context).pop(true); // Close the dialog
            } catch (e) {
              _showSnackbar("Error deleting report: $e");
              Navigator.of(context).pop(false); // Close the dialog
            }
          },
          title: 'Delete Report',
          message: 'Do you really want to delete this report?',
        );
      },
    );

    // If the dialog was closed with a confirmation, you can handle additional logic here if needed
  }

  void _updateReport(String reportId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReports(
          reportid: reportId,
          userRole: userRole,
          onReportEdited: () {
            _fetchReports(); // Refresh list after editing
          }, // Pass userRole here
        ),
      ),
    ).then((_) => _fetchReports()); // Refresh the list after editing
  }

  void _showSnackbar(String message, {Color color = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButton: userRole !=
              "Standard User" // Only show for non-standard users
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddReports(
                              onReportAdded: _fetchReports,
                            )));
              },
              child: Container(
                width: 150,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Add Reports",
                      style: AppTextStyles.bodyText3,
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          : null,
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Our',
                  style: AppTextStyles.headline23,
                ),
                const Text(
                  'Reports',
                  style: AppTextStyles.headline22,
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(6),
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? pickedStartDate = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (pickedStartDate != null) {
                          DateTime? pickedEndDate = await showDatePicker(
                            context: context,
                            initialDate:
                                pickedStartDate.add(const Duration(days: 1)),
                            firstDate: pickedStartDate,
                            lastDate: DateTime(2100),
                          );

                          if (pickedEndDate != null) {
                            setState(() {
                              startDate = pickedStartDate;
                              endDate = pickedEndDate;
                            });
                            _fetchReports(
                                startDate: startDate,
                                endDate:
                                    endDate); // Fetch reports with date range
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            (startDate != null && endDate != null)
                                ? "${startDate!.day} ${_getMonthName(startDate!.month)} ${startDate!.year} to ${endDate!.day} ${_getMonthName(endDate!.month)} ${endDate!.year}"
                                : 'Select Date ',
                            style: AppTextStyles.captionWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredReports.length,
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
                  return GestureDetector(
                    child: Reportcard(
                      reportid: report['id'],
                      date: report['date'] ?? '',
                      cash: report['cash'] ?? 0,
                      payment: report['payment'] ?? 0,
                      revenue: report['revenue'] ?? 0,
                      expense: report['expenses'] ?? [],
                      quantity: report['quantity'] ?? 0,
                      rate: report['rate'] ?? 0,
                      notes: report['notes'] ?? '',
                      selectedBusiness: report['business'] ?? "Select Business",
                      selectedBrand: report['brand'] ?? "Select Brand",
                      userRole: userRole,
                      onDelete: () => _deleteReport(
                          report['id']), // Allow delete for all users
                      onEdit: userRole !=
                              "Standard User" // Disable edit for Standard Users
                          ? () => _updateReport(report['id'])
                          : () {
                              _showSnackbar(
                                  "You do not have permission to edit this report.");
                            },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getMonthName(int month) {
  const monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return monthNames[month - 1];
}
