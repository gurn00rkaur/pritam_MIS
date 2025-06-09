import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomLoginTff extends StatefulWidget {
  const CustomLoginTff({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    this.obscureText = false,
    this.isPasswordField = false,
    this.validator,
    this.labelStyle,
    this.inputFormatter,
    this.initialvalue,
    required this.prefixIcon,
  });

  final String? initialvalue;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final bool isPasswordField;
  final IconData prefixIcon;
  final TextStyle? labelStyle;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;

  @override
  // ignore: library_private_types_in_public_api
  _CustomLoginTffState createState() => _CustomLoginTffState();
}

class _CustomLoginTffState extends State<CustomLoginTff> {
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
    // final size = MediaQuery.sizeOf(context);
    return Container(
      // width: size.width * 0.8,
      constraints: const BoxConstraints(maxWidth: 460),
      decoration: BoxDecoration(
        // color: AppColors.textFormField,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
          validator: widget.validator,
          obscureText: _obscureText,
          inputFormatters: widget.inputFormatter,
          keyboardType: widget.keyboardType,
          cursorColor: AppColors.primary,
          controller: widget.controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.textSecondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.textSecondary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.textSecondary),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.textSecondary),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.textSecondary),
            ),
            filled: true,
            fillColor: AppColors.textWhite,
            errorStyle: AppTextStyles.button,
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: AppTextStyles.bodyText2,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: AppColors.textSecondary,
            ),
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : null,
          )),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
