import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/app_colors.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/sizedbox.dart';
import 'package:pritam_manage_info_sys/presentation/core/constants/text_styles.dart';

class CustomTff extends StatefulWidget {
  const CustomTff({
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

  @override
  // ignore: library_private_types_in_public_api
  _CustomTffState createState() => _CustomTffState();
}

class _CustomTffState extends State<CustomTff> {
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
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            " ${widget.labelText}" ?? "",
            style: widget.labelStyle ?? AppTextStyles.bodyText1,
          ),
          SizedBoxHelper.height4(),
          Container(
            // width: size.width,
            // constraints: const BoxConstraints(maxWidth: 460),
            decoration: BoxDecoration(
                // color: AppColors.textFormField,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 2,
                      spreadRadius: 2)
                ]),
            child: TextFormField(
                validator: widget.validator,
                obscureText: _obscureText,
                inputFormatters: widget.inputFormatter,
                keyboardType: widget.keyboardType,
                cursorColor: AppColors.primary,
                controller: widget.controller,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 16),
                    borderSide: const BorderSide(color: AppColors.primaryLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 16),
                    borderSide: const BorderSide(color: AppColors.primaryLight),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 16),
                    borderSide: const BorderSide(color: AppColors.primaryLight),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 16),
                    borderSide: const BorderSide(color: AppColors.primaryLight),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 16),
                    borderSide: const BorderSide(color: AppColors.primaryLight),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: AppTextStyles.bodyTextPrimary1,
                  contentPadding: const EdgeInsets.only(left: 16),
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.caption,
                  suffixIcon: widget.isPasswordField
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? PhosphorIconsRegular.eyeSlash
                                : PhosphorIconsRegular.eye,
                            color: AppColors.darkGrey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        )
                      : null,
                )),
          ),
        ],
      ),
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
