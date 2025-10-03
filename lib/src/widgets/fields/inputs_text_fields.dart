import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/settings/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Color? prefixIconColor;
  final double paddingCircular;
  final double widthBorder;
  final EdgeInsetsGeometry contentPadding;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    required this.contentPadding,
    this.paddingCircular = 50,
    this.widthBorder = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding:contentPadding,
        hintText: hintText,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.inputBackground,
        hintStyle: TextStyle(color: AppColors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(paddingCircular)),
          borderSide: BorderSide(color: AppColors.white, width: widthBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(paddingCircular)),
          borderSide: BorderSide(color: AppColors.white, width: widthBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(paddingCircular)),
          borderSide: BorderSide(color: AppColors.buttonBlue, width: widthBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(paddingCircular)),
          borderSide: BorderSide(color: AppColors.red, width: widthBorder),
        ),
      ),
    );
  }
}
