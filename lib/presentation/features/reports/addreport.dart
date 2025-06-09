import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/db_firestore_reports.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_button.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_snackbaradd.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_tff.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/users/widgets/add_dropdown.dart';

class AddReports extends StatefulWidget {
  final VoidCallback onReportAdded;

  const AddReports({super.key, required this.onReportAdded});

  @override
  State<AddReports> createState() => _AddReportsState();
}

class _AddReportsState extends State<AddReports> {
  final DatabaseFirestoreReports _dbService = DatabaseFirestoreReports();
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _cashController = TextEditingController();
  final _paymentController = TextEditingController();
  final _revenueController = TextEditingController();

  // final _imageController = TextEditingController();
  final _notesController = TextEditingController();

  String? selectedBusiness;
  List<String> businessNames = [];
  String? selectedBrand;
  List<String> brandNames = [];
  List<Map<String, dynamic>> reportList = [];
  List<Map<String, TextEditingController>> expensesList = [
    {
      'expenseName': TextEditingController(),
      'expenseAmount': TextEditingController()
    },
  ];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchBusinessNames();
    _fetchBrandNames();
    _fetchReportList();
    _addExpenseRow();
    _cashController.addListener(() => setState(() {}));
    _paymentController.addListener(() => setState(() {}));
  }

  Future<void> _fetchBusinessNames() async {
    setState(() {
      isLoading = true; // Set loading to true
    });
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Business').get();
      setState(() {
        businessNames =
            snapshot.docs.map((doc) => doc['Businessname'] as String).toList();
      });
    } catch (e) {
      print("Error fetching business names: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false
      });
    }
  }

  Future<void> _fetchBrandNames() async {
    setState(() {
      isLoading = true; // Set loading to true
    });
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('brand').get();
      setState(() {
        brandNames =
            snapshot.docs.map((doc) => doc['Brandname'] as String).toList();
      });
    } catch (e) {
      print("Error fetching brand names: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false
      });
    }
  }

  Future<void> _fetchReportList() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Reports').get();
    setState(() {
      reportList = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void _addExpenseRow() {
    setState(() {
      expensesList.add({
        "expense": TextEditingController(),
        "quantity": TextEditingController(),
        "rate": TextEditingController(),
      });
    });
  }

  /// **Remove Expense Row**
  void _removeExpenseRow(int index) {
    setState(() {
      expensesList.removeAt(index);
    });
  }

  List<Map<String, dynamic>> _collectExpenseData() {
    return expensesList.map((expense) {
      return {
        "expense": expense["expense"]?.text.isNotEmpty == true
            ? expense["expense"]?.text
            : "0", // Default to "0" if empty
        "quantity": int.tryParse(expense["quantity"]?.text ?? "0") ?? 0,
        "rate": double.tryParse(expense["rate"]?.text ?? "0.0") ?? 0.0,
      };
    }).toList();
  }

  double _calculateRevenue() {
    double cash = double.tryParse(_cashController.text) ?? 0.0;
    double payment = double.tryParse(_paymentController.text) ?? 0.0;
    return cash + payment;
  }

  void _addReport() async {
    if (!_formKey.currentState!.validate())
      return; // Prevent empty form submission

    try {
      // Convert the date string to a DateTime object
      DateTime selectedDate = DateTime.parse(_dateController.text);

      await FirebaseFirestore.instance.collection('Reports').add({
        'date': Timestamp.fromDate(selectedDate), // Store as Timestamp
        'business': selectedBusiness ?? "Unknown",
        'brand': selectedBrand ?? "Unknown",
        'cash': double.tryParse(_cashController.text) ?? 0.0,
        'payment': double.tryParse(_paymentController.text) ?? 0.0,
        'revenue': _calculateRevenue(),
        'expenses': _collectExpenseData(),
        'notes': _notesController.text.isNotEmpty
            ? _notesController.text
            : "No notes",
      });

      // Show success Snackbar
      showDialog(
        context: context,
        builder: (context) {
          return CustomSnackbaradd(
            onOk: () {
              Navigator.pop(context); // Close the Snackbar dialog
              // widget
              //     .onReportAdded(); // Call the callback to refresh the report list
              // Navigator.pop(
              //     context, true); // Navigate back to the previous page
            },
            title: 'Success!',
            message: 'Your report details have been submitted successfully.',
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding report: $e")),
      );
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _cashController.dispose();
    _paymentController.dispose();
    _revenueController.dispose();

    // _imageController.dispose();
    for (var expense in expensesList) {
      expense["expense"]!.dispose();
      expense["quantity"]!.dispose();
      expense["rate"]!.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // When setting the date in the controller
        _dateController.text =
            picked.toIso8601String().split('T')[0]; // Correctly format the date
      });
    }
  }

  // Future<String?> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   return image?.path;
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final uniqueBusinesses =
        reportList.map((report) => report['business']).toSet().toList();

    return Scaffold(
      appBar: const CustomSecondaryAppBar(title: 'Add Reports'),
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
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTff(
                        labelText: "Date *",
                        controller: _dateController,
                        keyboardType: TextInputType.number,
                        hintText: "Select Date",
                        validator: (value) =>
                            value!.isEmpty ? 'Please choose date' : null,
                      ),
                    ),
                  ),
                  AddDropdown(
                    labelText: "Select Business",
                    items: businessNames,
                    onSelected: (value) {
                      setState(() {
                        selectedBusiness = value;
                      });
                    },
                  ),
                  AddDropdown(
                    labelText: "Select Brand",
                    items: brandNames,
                    onSelected: (value) {
                      setState(() {
                        selectedBrand = value;
                      });
                    },
                  ),
                  CustomTff(
                    labelText: "Total Cash Collected *",
                    controller: _cashController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter Cash Collected",
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter cash collected' : null,
                  ),
                  CustomTff(
                    labelText: "Total Online Payments *",
                    controller: _paymentController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter payment",
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter payment' : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Revenue *',
                            style: AppTextStyles.bodyText1,
                          ),
                          Container(
                            padding: EdgeInsets.all(14),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: AppColors.primaryLight),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade100,
                                      blurRadius: 2,
                                      spreadRadius: 2)
                                ]),
                            child: Text(
                              '₹${_calculateRevenue().toStringAsFixed(2)}',
                              style: AppTextStyles.bodyText1,
                            ),
                          )
                        ],
                      ),
                    ),
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
                  SizedBox(height: 20),
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
                              controller: expensesList[index]['expense'] ??
                                  TextEditingController(),
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
                              controller: expensesList[index]["quantity"] ??
                                  TextEditingController(),
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
                              controller: expensesList[index]["rate"] ??
                                  TextEditingController(),
                              keyboardType: TextInputType.number,
                              hintText: "Enter Rate",
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter rate' : null,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: expensesList.length > 1
                                ? () => _removeExpenseRow(index)
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _addExpenseRow,
                      icon: Icon(Icons.add, color: Colors.green),
                      label: Text("Add More"),
                    ),
                  ),
                  CustomTff(
                    labelText: "Notes *",
                    controller: _notesController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Notes",
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter notes' : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: CustomButton(
                      onPressed: _addReport,
                      color: AppColors.primary,
                      text: "Add",
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
