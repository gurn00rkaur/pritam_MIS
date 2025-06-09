import 'package:flutter/material.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';

class AddDropdown extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final void Function(String?) onSelected;
  final double? borderRadius;
  final String? initialValue; // ✅ Add initialValue

  const AddDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.onSelected,
    this.borderRadius,
    this.initialValue, // ✅ Accept initial value
  });

  @override
  State<AddDropdown> createState() => _AddDropdownState();
}

class _AddDropdownState extends State<AddDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue =
        widget.initialValue; // ✅ Set initial value when widget loads
  }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText, style: TextStyle(fontSize: 14)),
          DropdownButtonFormField<String>(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
            ),
            value: selectedValue, // ✅ Use selectedValue for initial selection
            items: widget.items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
              });
              widget.onSelected(newValue);
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
                borderSide: const BorderSide(color: AppColors.primaryLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
                borderSide: const BorderSide(color: AppColors.primaryLight),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 16),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
