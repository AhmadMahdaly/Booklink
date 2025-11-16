import 'package:biblio/core/constants/colors_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextformfield extends StatelessWidget {
  const CustomTextformfield({
    this.text,
    this.keyboardType,
    this.obscureText = false,
    super.key,
    this.onChanged,
    this.icon,
    this.validator,
    this.contentPadding,
    this.controller,
    this.maxLines = 1,
    this.inputFormatters,
    this.enabled = true,
    this.textInputAction,
    this.autofillHints,
  });
  final String? text;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? icon;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      enabled: enabled,
      cursorWidth: 0.5.sp,
      cursorColor: kMainColor,
      inputFormatters: inputFormatters,
      minLines: 1,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.top,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: text,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: kTextShadowColor,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: icon,
        border: border(),
        focusedBorder: border(),
        enabledBorder: border(),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder border() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.sp),
    borderSide: const BorderSide(
      color: kBorderColor,
    ),
  );
}
