import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class Customprofiletff extends StatefulWidget {
  const Customprofiletff({
    super.key,
    this.labelText,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    this.obscureText = false,
    this.isPasswordField = false,
    this.validator,
    this.labelStyle,
    this.inputFormatter,
    this.initialvalue,
    this.borderRadius,
    this.readOnly = false, // ✅ Add readOnly property
    this.style, // ✅ Add text style property
    this.decoration, // ✅ Add decoration property
  });

  final String? labelText;
  final String? initialvalue;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final double? borderRadius;
  final bool isPasswordField;
  final TextStyle? labelStyle;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;
  final bool readOnly; // ✅ New property
  final TextStyle? style; // ✅ New property
  final InputDecoration? decoration; // ✅ New property

  @override
  _CustomTffState createState() => _CustomTffState();
}

class _CustomTffState extends State<Customprofiletff> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    // Set the initial value to the controller
    if (widget.initialvalue != null) {
      widget.controller.text = widget.initialvalue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " ${widget.labelText}" ?? "",
            style: widget.labelStyle ?? AppTextStyles.bodyText1,
          ),
          SizedBox(height: 4),
          TextFormField(
            validator: widget.validator,
            obscureText: _obscureText,
            inputFormatters: widget.inputFormatter,
            keyboardType: widget.keyboardType,
            cursorColor: AppColors.primary,
            controller: widget.controller,
            readOnly: widget.readOnly, // ✅ Apply read-only behavior
            style:
                widget.style ?? TextStyle(color: Colors.black), // ✅ Apply style
            decoration: widget.decoration ??
                InputDecoration(
                  filled: true,
                  fillColor: widget.readOnly
                      ? Colors.grey[200]
                      : Colors.white, // ✅ Light grey if readOnly
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
          ),
        ],
      ),
    );
  }
}
