import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.text,
    this.height = 46.0, // Default height
    this.textStyle, // Optional text style
  });

  final void Function() onPressed;
  final Color color;
  final String text;
  final double height; // Height of the button
  final TextStyle? textStyle; // Optional text style

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        overlayColor:
            AppColors.secondary, // Change this to your desired overlay color
        padding: const EdgeInsets.all(0),
        shape: ContinuousRectangleBorder(
          side: const BorderSide(
            style: BorderStyle.solid,
            color: AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          height: height,
          child: Text(
            textAlign: TextAlign.center,
            text,
            style: textStyle ??
                AppTextStyles.bodyText3, // Use provided text style or default
          ),
        ),
      ),
    );
  }
}
