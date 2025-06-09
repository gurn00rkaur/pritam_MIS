import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      // height: 37,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.lightGrey),
      child: TextField(
        controller: widget.controller,
        decoration: const InputDecoration(
          labelText: 'Search Users',
          labelStyle: AppTextStyles.searchText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.transparent), // Focus border color
          ),
          prefixIcon: Icon(
            PhosphorIconsRegular.magnifyingGlass,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
