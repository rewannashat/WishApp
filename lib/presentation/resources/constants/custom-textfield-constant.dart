import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintTxt;
  final String? label;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Function(String)? onSaved;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onPressedSuffixIcon;
  final Function()? onPressedPrefixIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final double? fontSize;
  final Color? colorBorderEnable;
  final Color? colorBorder;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final FontWeight? fontWeight;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final double radius;
  final Color? fillColor;
  final Color? cursorColor;
  final Size? size;
  final  validator ;

  const CustomTextFormField({
    super.key,
    this.hintTxt,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.onSaved,
    this.onChanged,
    this.onSubmitted,
    this.onPressedSuffixIcon,
    this.onPressedPrefixIcon,
    this.keyboardType,
    this.controller,
    this.fontSize = 16,
    this.colorBorderEnable = Colors.black,
    this.colorBorder,
    this.suffixIconColor,
    this.prefixIconColor ,
    this.fontWeight = FontWeight.w600,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.hintStyle,
    this.labelStyle,
    this.radius = 12.0,
    this.fillColor,
    this.cursorColor,
    this.size,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size?.width,
      height: size?.height,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        minLines: minLines,
        maxLines: maxLines,
        cursorColor: cursorColor,
        style: TextStyle(
            color: Colors.white, fontSize: fontSize, fontWeight: fontWeight),
        onSaved: (val) => onSaved?.call(val ?? ''),
        onChanged: (val) => onChanged?.call(val),
        onFieldSubmitted: (val) => onSubmitted?.call(val),
        decoration: InputDecoration(
          hintText: hintTxt,
          hintStyle: hintStyle,
          labelText: label,
          labelStyle: labelStyle,
          filled: fillColor != null,
          fillColor: fillColor,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon),
                  color: suffixIconColor,
                  onPressed: onPressedSuffixIcon,
                )
              : null,
          prefixIcon: prefixIcon != null
              ? IconButton(
            icon: Icon(
              prefixIcon,
              color: prefixIconColor,
            ),
            onPressed: onPressedPrefixIcon,
          )
              : null,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: colorBorderEnable!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(color: colorBorder ?? Colors.white),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
