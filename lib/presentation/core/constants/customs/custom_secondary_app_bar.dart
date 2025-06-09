import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomSecondaryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomSecondaryAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: AppTextStyles.titlePrimarydark,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); // Standard AppBar height
}
