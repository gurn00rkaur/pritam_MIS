import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomSnackbaradd extends StatelessWidget {
  final VoidCallback onOk; // Callback for the OK button
  final String title; // Title of the Snackbar
  final String message; // Message to display

  const CustomSnackbaradd({
    Key? key,
    required this.onOk,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 300,
      child: AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        icon: Icon(
          Icons.check_circle_outline_outlined,
          color: AppColors.primary,
          size: 50,
        ),
        title: Center(
          child: Text(
            title,
            style: AppTextStyles.primaryHeadline11,
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: AppTextStyles.bodyTextPrimary111,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              height: 40,
              width: 120,
              margin: const EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  onOk();
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'Ok',
                  style: AppTextStyles.bodyText33,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
