import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/features/notification/pages/notify_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Image.asset(
          "assets/logos/Pritam_MIS_Logo.png",
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifyPage()),
              );
            },
            icon: const Icon(
              PhosphorIconsRegular.bell,
              color: AppColors.darkGrey,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60); // Standard AppBar height
}
