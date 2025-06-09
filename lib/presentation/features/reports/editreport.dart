import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pritam_manage_info_sys/db_firestore_reports.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_Snackbaredit.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class EditReports extends StatefulWidget {
  final String reportid; // Report ID for editing
  final String? userRole;
  final VoidCallback onReportEdited;

  const EditReports(
      {super.key,
      required this.reportid,
      this.userRole,
      required this.onReportEdited});

  @override
  State<EditReports> createState() => _EditReportsState();
}

class _EditReportsState extends State<EditReports> {
  final DatabaseFirestoreReports _dbService = DatabaseFirestoreReports();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Define Firestore instance

  final _dateController = TextEditingController();
  final _cashController = TextEditingController();
  final _paymentController = TextEditingController();
  final _revenueController = TextEditingController();

  // final _imageController = TextEditingController();
  final _notesController =
      TextEditingController(); // Separate controller for notes
  String? selectedBusiness;
  String? selectedBrand;
  List<Map<String, TextEditingController>> expensesList = [];

  @override
  void initState() {
    super.initState();
    // Check user role before fetching report data
    if (widget.userRole == "Standard User") {
      _showSnackbar("You do not have permission to edit reports.");
      Navigator.pop(context); // Go back to the previous page
    } else {
      _fetchReportData(); // Fetch report data if user is allowed
    }
  }

  void _fetchReportData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('Reports').doc(widget.reportid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        // Debugging: Print fetched data to verify field names
        print("Fetched Data: $data");

        setState(() {
          _dateController.text = (data['date'] as Timestamp)
              .toDate()
              .toIso8601String()
              .split('T')[0]; // Format as String
          _cashController.text = data['cash']?.toString() ?? '';
          _paymentController.text = data['payment']?.toString() ?? '';
          _revenueController.text = data['revenue']?.toString() ?? '';
          _notesController.text = data['notes'] ?? '';

          selectedBusiness = data['business'] ??
              null; // Ensure this matches the Firestore field name
          selectedBrand = data['brand'] ??
              null; // Ensure this matches the Firestore field name

          // Handle Expenses List
          expensesList = (data['expenses'] as List)
              .map<Map<String, TextEditingController>>((expense) {
            return {
              'expense': TextEditingController(
                  text: expense['expense']?.toString() ?? ''),
              'quantity': TextEditingController(
                  text:
                      expense['quantity']?.toString() ?? '0'), // Default to '0'
              'rate': TextEditingController(
                  text:
                      expense['rate']?.toString() ?? '0.0'), // Default to '0.0'
            };
          }).toList();
        });
      } else {
        _showSnackbar("Report not found.");
      }
    } catch (e) {
      _showSnackbar("Error fetching report data: $e");
    }
  }

  Future<void> _editReport() async {
    if (_formKey.currentState!.validate()) {
      String date = _dateController.text.trim();
      String cash = _cashController.text.trim();
      String payment = _paymentController.text.trim();
      String revenue = _revenueController.text.trim();
      String notes = _notesController.text.trim();

      List<Map<String, dynamic>> expenses = expensesList.map((expense) {
        return {
          'expense': expense['expense']!.text.isNotEmpty
              ? expense['expense']!.text
              : "0",
          'quantity': int.tryParse(expense['quantity']!.text) ?? 0,
          'rate': double.tryParse(expense['rate']!.text) ?? 0.0,
        };
      }).toList();

      Map<String, dynamic> dataToUpdate = {
        'date': Timestamp.fromDate(DateTime.parse(date)),
        'cash': double.tryParse(cash) ?? 0.0,
        'payment': double.tryParse(payment) ?? 0.0,
        'revenue': double.tryParse(revenue) ?? 0.0,
        'expenses': expenses,
        'notes': notes,
        'business': selectedBusiness,
        'brand': selectedBrand,
      };

      try {
        // Update the report data in Firestore
        await _firestore
            .collection('Reports')
            .doc(widget.reportid)
            .update(dataToUpdate);

        // Show the custom dialog
        showDialog(
          context: context,
          builder: (context) {
            return CustomSnackbaredit(
              onOk: () {
                Navigator.pop(context); // Close the Snackbar dialog
                if (widget.onReportEdited != null) {
                  widget.onReportEdited!(); // Call the callback
                }
                Navigator.pop(context, true); // Go back to the previous page
              },
              title: 'Reports Edited!',
              message:
                  'The changes for the Reports have been edited successfully.',
            );
          },
        );
      } catch (e) {
        _showSnackbar("Error updating report: $e");
      }
    }
  }

  void _showSnackbar(String message, {Color color = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _cashController.dispose();
    _paymentController.dispose();
    _revenueController.dispose();

    // _imageController.dispose();
    _notesController.dispose();
    for (var expense in expensesList) {
      expense['expense']!.dispose();
      expense['quantity']!.dispose();
      expense['rate']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (selectedBusiness == null || selectedBrand == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: const CustomSecondaryAppBar(title: 'Edit Reports'),
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTff(
                    labelText: "Date *",
                    controller: _dateController,
                    keyboardType: TextInputType.text,
                    hintText: "Select Date",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please choose date'
                        : null,
                  ),
                  AddDropdown(
                    labelText: "Business Name",
                    items: ["Pritam", "Grandmamas Cafe", "Torii"],
                    initialValue: selectedBusiness,
                    onSelected: (value) =>
                        setState(() => selectedBusiness = value),
                  ),
                  AddDropdown(
                    labelText: "Select Brand",
                    items: ['Pritam', 'Grandmamas Cafe', 'Torii'],
                    initialValue: selectedBrand,
                    onSelected: (value) =>
                        setState(() => selectedBrand = value),
                  ),

                  CustomTff(
                    labelText: "Total Cash Collected *",
                    controller: _cashController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter Cash Collected",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter cash collected'
                        : null,
                  ),
                  CustomTff(
                    labelText: "Total Online Payments *",
                    controller: _paymentController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter payment",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter payment'
                        : null,
                  ),
                  CustomTff(
                    labelText: "Total Revenue *",
                    controller: _revenueController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter Revenue",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter revenue'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 2, // Height of the divider
                        width: 150, // Width of the divider
                        color: AppColors.primaryLight,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Expenses'),
                      ),
                      Container(
                        height: 2, // Height of the divider
                        width: 150, // Width of the divider
                        color: AppColors.primaryLight,
                      ),
                    ],
                  ),

                  // CustomTff(
                  //   labelText: "Image *",
                  //   controller: _imageController,
                  //   keyboardType:
                  //       TextInputType.text, // Changed to text for image path
                  //   hintText: "Choose Image",
                  //   validator: (value) => value == null || value.isEmpty
                  //       ? 'Please choose image'
                  //       : null,
                  // ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: expensesList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomTff(
                              labelText: "Expense *",
                              controller: expensesList[index]['expense']!,
                              keyboardType: TextInputType.text,
                              hintText: "Enter Expense",
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter expense'
                                  : null,
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: CustomTff(
                              labelText: "Quantity *",
                              controller: expensesList[index]["quantity"]!,
                              keyboardType: TextInputType.number,
                              hintText: "Enter Quantity",
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter quantity'
                                  : null,
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: CustomTff(
                              labelText: "Rate *",
                              controller: expensesList[index]["rate"]!,
                              keyboardType: TextInputType.number,
                              hintText: "Enter Rate",
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter rate' : null,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  CustomTff(
                    labelText: "Notes *",
                    controller: _notesController, // Use the correct controller
                    keyboardType: TextInputType.text,
                    hintText: "Enter Notes",
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter notes'
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: CustomButton(
                      onPressed: _editReport,
                      color: AppColors.primary,
                      text: "Edit",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
