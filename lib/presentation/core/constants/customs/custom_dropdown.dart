import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.controller,
    this.hintText,
    this.labelStyle,
    this.onChanged,
    this.buttonText,
    this.validator,
    this.buttonTap,
  });

  final String labelText;
  final List<String> items; // List of items populated from API
  final String? hintText;
  final TextStyle? labelStyle;
  final void Function(String?)? onChanged;
  final void Function()? buttonTap;
  final String Function(String?)? validator;
  final String? buttonText;
  final DropdownController controller; // Controller to hold the selected value

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Row(
              children: [
                Text(
                  " ${widget.labelText}",
                  style: AppTextStyles.bodyText1,
                ),
                SizedBoxHelper.width10(),
                if (widget.buttonText != null)
                  GestureDetector(
                    onTap: widget.buttonTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        widget.buttonText!,
                        style: AppTextStyles.captionWhite,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBoxHelper.height4(),
          Container(
            height: 50,
            constraints: const BoxConstraints(maxWidth: 460),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 2,
                      spreadRadius: 2),
                ]),
            child: DropdownButtonFormField<String>(
              validator: widget.validator,
              value: widget.items.contains(widget.controller.value)
                  ? widget.controller.value
                  : null, // Ensuring the value is valid
              items: widget.items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: AppTextStyles.bodyText1,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  widget.controller.value = newValue;
                });
                widget.onChanged?.call(newValue);
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primaryLight),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: widget.hintText ?? "Select ${widget.labelText}",
                hintStyle: AppTextStyles.caption,
                border: InputBorder.none,
                alignLabelWithHint: true,
              ),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownController extends ValueNotifier<String?> {
  DropdownController([super.value]);
}
