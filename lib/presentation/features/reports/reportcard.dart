import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';

import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';
import 'package:pritam_manage_info_sys/presentation/features/reports/editreport.dart';
import 'package:pritam_manage_info_sys/presentation/features/reports/repors_desciption.dart';

class Reportcard extends StatelessWidget {
  final String reportid;
  final DateTime date;
  final num cash;
  final num payment;
  final num revenue;
  final List<Map<String, dynamic>> expense;
  final num quantity;
  final num rate;
  // final String image;
  final String notes;
  final String selectedBusiness;
  final String selectedBrand;
  final String? userRole;
  final VoidCallback onEdit; // Callback for editing
  final VoidCallback onDelete; // Callback for deleting

  const Reportcard({
    Key? key,
    required this.reportid,
    required this.date,
    required this.cash,
    required this.payment,
    required this.revenue,
    required this.expense,
    required this.quantity,
    required this.rate,
    // required this.image,
    required this.notes,
    required this.selectedBusiness,
    required this.selectedBrand,
    required this.userRole,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: 180,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
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
                _buildBackgroundDecorations(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHeader(context),
                      const Divider(),
                      _buildFinancialSummary(context),
                      const SizedBox(height: 10),
                      // _buildExpenseDetails(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Background design elements (circles)
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          right: -14,
          top: -14,
          child: Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 206, 34, 34),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: -20,
          top: -20,
          child: Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: AppColors.primaryLight),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 40,
          top: 116,
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 110,
          top: 20,
          child: Container(
            height: 5,
            width: 5,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedBusiness.isNotEmpty ? selectedBusiness : "No Business",
                style: AppTextStyles.headline1,
                overflow: TextOverflow.ellipsis, // Prevent overflow
              ),
              Text(
                selectedBrand.isNotEmpty ? selectedBrand : "No Brand",
                style: AppTextStyles.bodyText3,
                overflow: TextOverflow.ellipsis, // Prevent overflow
              ),
            ],
          ),
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(date),
          style: AppTextStyles.bodyText3,
        ),
        IconButton(
          onPressed: () => _showOptionsMenu(context),
          icon: const Icon(EvaIcons.moreVertical),
          color: Colors.white,
        ),
      ],
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.textWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Make it scrollable
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBoxHelper.height20(),
              ListTile(
                minTileHeight: 60,
                leading: const Icon(PhosphorIconsRegular.pencilSimpleLine,
                    color: AppColors.primary),
                title: const Text('Edit', style: AppTextStyles.bodyText1),
                onTap: () {
                  if (userRole != "Standard User") {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditReports(
                          reportid: reportid,
                          userRole: userRole,
                          onReportEdited: onEdit,
                        ),
                      ),
                    );
                  } else {
                    // Show snackbar in Reportpage instead
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "You do not have permission to edit this report."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                minTileHeight: 60,
                leading: const Icon(PhosphorIconsRegular.trash,
                    color: AppColors.primary),
                title: const Text('Delete', style: AppTextStyles.bodyText1),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              SizedBoxHelper.height20(),
            ],
          ),
        );
      },
    );
  }

  /// Displays financial summary (Revenue, Expenses, View Details button)
  Widget _buildFinancialSummary(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildFinancialColumn("Total Revenue Collected", revenue),
        ),
        Expanded(
          child:
              _buildFinancialColumn("Total Expense", _calculateTotalExpenses()),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReporsDesciption(
                    reportid: reportid,
                    date: date,
                    cash: cash,
                    payment: payment,
                    revenue: revenue,
                    expense: expense,
                    quantity: quantity,
                    rate: rate,
                    notes: notes,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    businessName: selectedBusiness),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Helper widget for financial summary columns
  Widget _buildFinancialColumn(String title, num value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyText3),
        Text(value.toString(), style: AppTextStyles.captionWhite),
      ],
    );
  }

  num _calculateTotalExpenses() {
    return expense.fold(0, (sum, e) {
      return sum + (e['quantity'] ?? 0) * (e['rate'] ?? 0.0);
    });
  }

  /// Displays expense details
  // Widget _buildExpenseDetails() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Expense Details', style: AppTextStyles.bodyTextPrimary1),
  //       const SizedBox(height: 10),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: expense.length,
  //         itemBuilder: (context, index) {
  //           final exp = expense[index];
  //           final quantity = exp['quantity'] ?? 0;
  //           final rate = exp['rate'] ?? 0.0;
  //           final total = quantity * rate;
  //         },
  //       ),
  //     ],
  //   );
  // }
}
