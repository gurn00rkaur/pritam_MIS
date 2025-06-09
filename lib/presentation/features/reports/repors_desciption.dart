import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/customs/custom_secondary_app_bar.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class ReporsDesciption extends StatefulWidget {
  final String reportid;
  final String businessName; // Add business name parameter
  final DateTime date;
  final num cash;
  final num payment;
  final num revenue;
  final List<Map<String, dynamic>> expense;
  final num quantity;
  final num rate;
  final String notes;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReporsDesciption({
    Key? key,
    required this.reportid,
    required this.date,
    required this.businessName,
    required this.cash,
    required this.payment,
    required this.revenue,
    required this.expense,
    required this.quantity,
    required this.rate,
    required this.notes,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ReporsDesciption> createState() => _ReportsDescriptionState();
}

class _ReportsDescriptionState extends State<ReporsDesciption> {
  DateTime? startDate;
  DateTime? endDate;

  num _calculateTotalExpense() {
    num total = 0;
    for (var expense in widget.expense) {
      final quantity = expense['quantity'] ?? 0;
      final rate = expense['rate'] ?? 0.0;
      total += quantity * rate;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSecondaryAppBar(title: '${widget.businessName}'),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildRevenueCard(size),
              SizedBox(
                height: 14,
              ),
              _buildFinancialDetails(size),
              SizedBox(
                height: 14,
              ),
              _buildExpenseDetails(),
              const SizedBox(height: 14),
              _buildNotesSection(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessName(Size size) {
    return Container(
      margin: const EdgeInsets.all(6),
      height: 50,
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          widget.businessName,
          style: AppTextStyles.captionWhite,
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
          onTap: _pickDateRange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                (startDate != null && endDate != null)
                    ? "${_formatDate(startDate!)} to ${_formatDate(endDate!)}"
                    : 'Select Date: ${_formatDate(widget.date)} to ${_formatDate(DateTime.now())}',
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
            Container(
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
                            Text('Total Revenue',
                                style: AppTextStyles.bodyText3),
                            Text('${widget.revenue ?? 0} cr',
                                style: AppTextStyles.bodyText3)
                          ],
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
                    ],
                  ),
                ),
              ),
            ),
            Container(
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
                            Text('Total Expense: ',
                                style: AppTextStyles.bodyText3),
                            Text('${_calculateTotalExpense()} cr',
                                style: AppTextStyles.bodyText3),
                          ],
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
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
                            Text('Total Online',
                                style: AppTextStyles.bodyText3),
                            Text('${widget.payment} cr',
                                style: AppTextStyles.bodyText3)
                          ],
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
                    ],
                  ),
                ),
              ),
            ),
            Container(
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
                            Text('Total Cash ', style: AppTextStyles.bodyText3),
                            Text('${widget.cash} cr',
                                style: AppTextStyles.bodyText3),
                          ],
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds financial details (Cash, Payment, Revenue)
  /// Builds financial details (Cash, Payment, Revenue)
  Widget _buildFinancialDetails(Size size) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(20),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Revenue Breakdown", style: AppTextStyles.bodyTextPrimary1),
          const SizedBox(height: 5),
          Text("Revenue categories for better cost analysis",
              style: AppTextStyles.bodyText2),
          const SizedBox(height: 10),

          // Row to align text on left & Pie Chart on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Labels & values
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
                  const SizedBox(height: 5),
                  Text('${widget.cash}',
                      style: AppTextStyles.bodyTextPrimary11),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.indigo[900], size: 10),
                      const SizedBox(width: 8),
                      Text("Online Payments", style: AppTextStyles.bodyText2),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('${widget.payment}',
                      style: AppTextStyles.bodyTextPrimary11),
                ],
              ),

              // Right side: Pie Chart
              SizedBox(
                height: 120,
                width: 120,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: widget.cash.toDouble(),
                        color: AppColors.primary,
                        title: '${widget.cash} cr',
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: widget.payment.toDouble(),
                        color: Colors.indigo[900]!,
                        title: '${widget.payment} cr',
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

  /// Builds expense details section
  Widget _buildExpenseDetails() {
    return Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryLight),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child:
                        Text('Expense', style: AppTextStyles.bodyTextPrimary1)),
                Container(
                    width: 1,
                    color: AppColors.primaryLight,
                    height: 20), // Divider
                Expanded(
                    child: Text('Quantity',
                        style: AppTextStyles.bodyTextPrimary11,
                        textAlign: TextAlign.center)),
                Container(
                    width: 1,
                    color: AppColors.primaryLight,
                    height: 20), // Divider
                Expanded(
                    child: Text('Rate',
                        style: AppTextStyles.bodyTextPrimary11,
                        textAlign: TextAlign.center)),
                Container(
                    width: 1,
                    color: AppColors.primaryLight,
                    height: 20), // Divider
                Expanded(
                    child: Text('Total',
                        style: AppTextStyles.bodyTextPrimary11,
                        textAlign: TextAlign.center)),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // ✅ Expense List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.expense.length,
            itemBuilder: (context, index) {
              final expense = widget.expense[index];
              final quantity = expense['quantity'] ?? 0;
              final rate = expense['rate'] ?? 0.0;
              final total = quantity * rate;
              final expenseName = expense['expense'] ?? 'Unknown';

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(expenseName,
                                style: AppTextStyles.bodyText2)),
                        Container(
                            width: 1,
                            color: AppColors.primaryLight,
                            height: 20), // Divider
                        Expanded(
                            child: Text('$quantity',
                                style: AppTextStyles.bodyText2,
                                textAlign: TextAlign.center)),
                        Container(
                            width: 1,
                            color: AppColors.primaryLight,
                            height: 20), // Divider
                        Expanded(
                            child: Text('$rate',
                                style: AppTextStyles.bodyText2,
                                textAlign: TextAlign.center)),
                        Container(
                            width: 1,
                            color: AppColors.primaryLight,
                            height: 20), // Divider
                        Expanded(
                            child: Text('$total',
                                style: AppTextStyles.bodyText2,
                                textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ]));
  }

  /// **Header Row with Vertical Dividers**
  Widget _buildHeaderRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildColumnHeader("Expenses"),
        _buildVerticalDivider(),
        _buildColumnHeader("Quantity"),
        _buildVerticalDivider(),
        _buildColumnHeader("Rate"),
        _buildVerticalDivider(),
        _buildColumnHeader("Total"),
      ],
    );
  }

  /// **Helper Widget for Column Headers**
  Widget _buildColumnHeader(String title) {
    return Expanded(
      child: Center(
        child: Text(title, style: AppTextStyles.bodyTextPrimary11),
      ),
    );
  }

  /// **Helper Widget for Expense Rows**
  Widget _buildExpenseRow(String expenseType) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildColumnData(expenseType),
        _buildVerticalDivider(),
        _buildColumnData("${widget.expense}"),
        _buildVerticalDivider(),
        _buildColumnData("${widget.rate}"),
        _buildVerticalDivider(),
        _buildColumnData("Total"),
      ],
    );
  }

  /// **Helper Widget for Column Data**
  Widget _buildColumnData(String value) {
    return Expanded(
      child: Center(
        child: Text(value, style: AppTextStyles.bodyText2),
      ),
    );
  }

  /// **Vertical Divider Helper**
  Widget _buildVerticalDivider() {
    return Container(
      width: 2, // Thickness of divider
      height: 20, // Height of the divider
      color: AppColors.primaryLight, // Red color for divider
      margin: const EdgeInsets.symmetric(horizontal: 2),
    );
  }

  /// Builds notes section
  Widget _buildNotesSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Notes', style: AppTextStyles.bodyTextPrimary1),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(20),
          width: size.width,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLight),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(widget.notes),
        ),
      ],
    );
  }

  /// Helper function to pick a date range
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
