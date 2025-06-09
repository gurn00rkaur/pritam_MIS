import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_app_bar.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class Brand {
  final String id;
  final String name;

  Brand({required this.id, required this.name});
}

class FinancialData {
  final String brandId;
  final double revenue;
  final double expense;
  final double grossprofit;
  final double cashReceived;

  FinancialData({
    required this.brandId,
    required this.revenue,
    required this.expense,
    required this.grossprofit,
    required this.cashReceived,
  });

  @override
  String toString() {
    return 'FinancialData(brandId: $brandId, revenue: $revenue, expense: $expense, profit: $grossprofit, cashReceived: $cashReceived)';
  }
}

class HomePage extends StatefulWidget {
  final List<Brand> brandNames;
  const HomePage({Key? key, required this.brandNames}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedBrandId;
  String? selectedBrandName;
  FinancialData? selectedFinancialData;
  List<Brand> brandNames = [];
  DateTime? startDate;
  DateTime? endDate;

  double totalRevenue = 0;
  double totalExpense = 0;
  double totalCashReceived = 0;

  String? userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserRole(); // Fetch user role when the page is initialized
    _fetchBrands().then((brands) {
      setState(() {
        brandNames = brands; // Update the state with fetched brands
        if (brandNames.isNotEmpty) {
          selectedBrandId = null; // Initially, no brand is selected
          selectedBrandName = null; // Initially, no brand name is selected
          _fetchFinancialData(); // Fetch financial data based on user role
        }
      });
    });
  }

  Future<void> _fetchUserRole() async {
    // Fetch user role from Firestore
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
        print("Error fetching user role: $e");
      }
    }
  }

  void _updateFinancialData() {
    if (userRole == "Super User") {
      // Super User can see total data and select any brand
      _fetchFinancialData(); // Fetch total data
    } else if (userRole == "Admin" || userRole == "Standard User") {
      // Fetch data for the user's specific brand
      _fetchFinancialDataForUserBrand();
    }
  }

  Future<void> _fetchFinancialData() async {
    try {
      print("Fetching financial data for reports");
      Query query = FirebaseFirestore.instance.collection('Reports');

      // Apply brand filtering if a brand is selected
      if (selectedBrandId != null) {
        query = query.where('brand', isEqualTo: selectedBrandId);
      }

      // Apply date filtering if startDate and endDate are provided
      if (startDate != null && endDate != null) {
        query = query
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate!));
      }

      final QuerySnapshot snapshot = await query.get(); // Fetch reports

      print("Fetched documents: ${snapshot.docs.length}");

      totalRevenue = 0;
      totalExpense = 0;
      totalCashReceived = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalRevenue += _parseNum(data['revenue']);
        totalCashReceived += _parseNum(data['cash']);

        // Calculate total expenses
        if (data['expenses'] is List) {
          for (var expense in data['expenses']) {
            totalExpense +=
                _parseNum(expense['quantity']) * _parseNum(expense['rate']);
          }
        }
      }

      print("Total Revenue: $totalRevenue");
      print("Total Expenses: $totalExpense");
      print("Total Cash Received: $totalCashReceived");

      setState(() {
        selectedFinancialData = FinancialData(
          brandId:
              selectedBrandId ?? 'Total', // Indicate that this is total data
          revenue: totalRevenue,
          expense: totalExpense,
          grossprofit: totalRevenue - totalExpense,
          cashReceived: totalCashReceived,
        );
      });
    } catch (e) {
      print("Error fetching financial data: $e");
    }
  }

  Future<void> _fetchFinancialDataForUserBrand() async {
    try {
      // Fetch reports for the specific brand associated with the user
      Query query = FirebaseFirestore.instance
          .collection('Reports')
          .where('brand', isEqualTo: selectedBrandId);

      // Apply date filtering if startDate and endDate are provided
      if (startDate != null && endDate != null) {
        query = query
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate!));
      }

      final QuerySnapshot snapshot = await query.get();

      print(
          "Fetched documents: ${snapshot.docs.length} for brand: $selectedBrandId");

      if (snapshot.docs.isNotEmpty) {
        double revenue = 0;
        double expense = 0;
        double cashReceived = 0;

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          revenue += _parseNum(data['revenue']);
          cashReceived += _parseNum(data['cash']);

          // Ensure you are correctly calculating expenses
          if (data['expenses'] is List) {
            for (var expenseData in data['expenses']) {
              expense += _parseNum(expenseData['quantity']) *
                  _parseNum(expenseData['rate']);
            }
          }
        }

        setState(() {
          selectedFinancialData = FinancialData(
            brandId: selectedBrandId ?? '',
            revenue: revenue,
            expense: expense,
            grossprofit: revenue - expense,
            cashReceived: cashReceived,
          );
        });
      } else {
        // If no data is found for the selected brand, reset the financial data
        setState(() {
          selectedFinancialData = FinancialData(
            brandId: selectedBrandId ?? '',
            revenue: 0,
            expense: 0,
            grossprofit: 0,
            cashReceived: 0,
          );
        });
      }
    } catch (e) {
      print("Error fetching financial data for user brand: $e");
    }
  }

  Future<void> _fetchFinancialDataForBrand(String brandId) async {
    try {
      print("Fetching financial data for brand: $brandId");
      Query query = FirebaseFirestore.instance
          .collection('Reports')
          .where('brand', isEqualTo: brandId);

      // Apply date filtering if startDate and endDate are provided
      if (startDate != null && endDate != null) {
        query = query
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate!));
      }

      final QuerySnapshot snapshot = await query.get();

      print("Fetched documents: ${snapshot.docs.length} for brand: $brandId");

      if (snapshot.docs.isNotEmpty) {
        double revenue = 0;
        double expense = 0;
        double cashReceived = 0;

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          revenue += _parseNum(data['revenue']);
          expense += _parseNum(data['totalExpense']);
          cashReceived += _parseNum(data['cash']);
        }

        setState(() {
          selectedFinancialData = FinancialData(
            brandId: brandId,
            revenue: revenue,
            expense: expense,
            grossprofit: revenue - expense,
            cashReceived: cashReceived,
          );
        });
      } else {
        // If no data is found for the selected brand, reset the financial data
        setState(() {
          selectedFinancialData = FinancialData(
            brandId: brandId,
            revenue: 0,
            expense: 0,
            grossprofit: 0,
            cashReceived: 0,
          );
        });
      }
    } catch (e) {
      print("Error fetching financial data for brand: $e");
    }
  }

  num _parseNum(dynamic value) {
    if (value is num) return value; // Already a valid number
    if (value == null || value.toString().trim().isEmpty)
      return 0.0; // Handle null and empty values
    return double.tryParse(value.toString()) ?? 0.0; // Try to parse the value
  }

  Future<List<Brand>> _fetchBrands() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Reports').get();

      // Extract unique brand names
      final Set<String> brandNamesSet = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['brand'] != null) {
          brandNamesSet.add(data['brand']);
        }
      }

      // Convert to List<Brand>
      return brandNamesSet.map((name) => Brand(id: name, name: name)).toList();
    } catch (e) {
      print("Error fetching brands: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildFilters(size),
              SizedBox(
                height: 10,
              ),
              _buildRevenueCard(size),
              SizedBox(
                height: 14,
              ),
              _buildFinancialDetails(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDropdown(size),
        _buildDateSelector(size),
      ],
    );
  }

  Widget _buildDropdown(Size size) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(10),
      height: 50,
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Brand>(
          value: brandNames.isNotEmpty
              ? brandNames.firstWhere((brand) => brand.id == selectedBrandId,
                  orElse: () => brandNames[0]) // Set the initial value
              : null, // Handle case when brandNames is empty
          hint: const Text('Select Brand', style: AppTextStyles.captionWhite),
          icon: const Icon(Icons.keyboard_arrow_down_outlined,
              color: Colors.white),
          dropdownColor: AppColors.primary,
          style: AppTextStyles.bodyText3,
          onChanged: (Brand? newValue) {
            setState(() {
              selectedBrandId = newValue?.id; // Update the selected brand ID
              selectedBrandName =
                  newValue?.name; // Update the selected brand name
              _updateFinancialData(); // Fetch financial data based on new selection
            });
          },
          items: brandNames.map<DropdownMenuItem<Brand>>((Brand brand) {
            return DropdownMenuItem<Brand>(
              value: brand,
              child: Text(brand.name, style: AppTextStyles.captionWhite),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateSelector(Size size) {
    return Container(
      margin: const EdgeInsets.all(6),
      height: 50,
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: GestureDetector(
          onTap: _pickDateRange, // Your method to pick a date range
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                (startDate != null && endDate != null)
                    ? "${_formatDate(startDate!)} to ${_formatDate(endDate!)}"
                    : 'Select Date ',
                style: AppTextStyles.captionWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds revenue card
  Widget _buildRevenueCard(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCard(
                size, 'Total Revenue', selectedFinancialData?.revenue ?? 0),
            _buildCard(
                size, 'Total Expense', selectedFinancialData?.expense ?? 0),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCard(
                size, 'Gross Profit', selectedFinancialData?.grossprofit ?? 0),
            _buildCard(size, 'Cash Received',
                selectedFinancialData?.cashReceived ?? 0),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(Size size, String title, double value) {
    return Container(
      margin: const EdgeInsets.all(6),
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 244, 35, 20),
              Color.fromARGB(255, 244, 115, 115),
            ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -14,
                top: -14,
                child: Container(
                  height: 86,
                  width: 86,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 206, 34, 34),
                      shape: BoxShape.circle),
                ),
              ),
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppColors.primaryLight),
                      shape: BoxShape.circle),
                  height: 100,
                  width: 100,
                ),
              ),
              Positioned(
                right: 76,
                top: -20,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    height: 5,
                    width: 5,
                  ),
                ),
              ),
              Positioned(
                right: 30,
                top: 32,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    height: 10,
                    width: 10,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Icon(
                        EvaIcons.trendingUpOutline,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(title, style: AppTextStyles.bodyText3),
                    Text('₹${value.toStringAsFixed(2)}',
                        style: AppTextStyles.bodyText3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialDetails(Size size) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      width: size.width,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Revenue Breakdown", style: AppTextStyles.bodyTextPrimary11),
          const SizedBox(height: 5),
          Text("Revenue categories for better cost analysis",
              style: AppTextStyles.bodyText2),
          const SizedBox(height: 10),

          // Row containing labels on the left & Pie Chart on the right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side - Labels
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, color: AppColors.primary, size: 10),
                      const SizedBox(width: 8),
                      Text("Cash Received", style: AppTextStyles.bodyText2),
                    ],
                  ),
                  Text('₹${selectedFinancialData?.cashReceived ?? 0}'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.indigo[900], size: 10),
                      const SizedBox(width: 8),
                      Text("Online Payments", style: AppTextStyles.bodyText2),
                    ],
                  ),
                  Text('₹${selectedFinancialData?.revenue ?? 0}'),
                ],
              ),

              // Right side - Pie Chart
              SizedBox(
                height: 120,
                width: 120,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: selectedFinancialData?.cashReceived ?? 0,
                        color: AppColors.primary,
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: selectedFinancialData?.revenue ?? 0,
                        color: Colors.indigo[900]!,
                        radius: 40,
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedStartDate != null) {
      DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: pickedStartDate.add(const Duration(days: 1)),
        firstDate: pickedStartDate,
        lastDate: DateTime(2100),
      );

      if (pickedEndDate != null) {
        setState(() {
          startDate = pickedStartDate;
          endDate = pickedEndDate;
        });
        _updateFinancialData(); // Fetch financial data based on new date range
      }
    }
  }

  /// Formats date to readable format
  String _formatDate(DateTime date) {
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
    return "${date.day} ${monthNames[date.month - 1]} ${date.year}";
  }
}
