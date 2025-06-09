import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm; // Callback for confirmation
  final String title;
  final String message;

  const CustomConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Center(
        child: Text(
          title,
          style: AppTextStyles
              .primaryHeadline11, // Ensure you have a style for the title
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles
              .bodyTextPrimary111, // Ensure you have a style for the message
        ),
      ),
      actions: [
        Container(
          height: 40,
          width: 120,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyText33,
            ),
          ),
        ),
        Container(
          height: 40,
          width: 120,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: () {
              onConfirm(); // Call the confirmation callback
              Navigator.pop(context); // Close the dialog after confirmation
            },
            child: Text(
              'Okay',
              style: AppTextStyles.bodyText33,
            ),
          ),
        ),
      ],
    );
  }
}
