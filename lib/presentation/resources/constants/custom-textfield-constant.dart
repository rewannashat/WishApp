import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintTxt;
  final String? label;
  final String? helperText;
  final IconData? suffexIcon;
  final IconData? prefexIcon;
  final Function? onSaved;
  final Function? validator;
  final Function? onChange;
  final Function? onSubmitted;
  final Function? onPressedSuffexIcon;
  final Function? onPressedPrefexIcon;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final double? fontSize;
  final double? contentPadding;
  final Color? colorBorderEnable;
  final Color? colorBorder ;
  final Color? suffexIconColor;
  final Color? prefexIconColor;
  final FontWeight? fontWeight;
  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final double? radius ;
  final OutlineInputBorder? out ;
  final String? prefexTxt;
  final double? elevation;
  final Color? fillColor;
  final FocusNode? focusNode ;



  CustomTextFormField({
    this.hintTxt,
    this.out,
    this.onSaved,
    this.validator,
    this.suffexIcon,
    this.onPressedSuffexIcon,
    this.onPressedPrefexIcon,
    this.onSubmitted,
    this.keyboardType,
    this.radius,
    this.colorBorder,
    this.label,
    this.hintStyle,
    this.labelStyle,
    this.controller,
    this.onChange,
    this.fontSize = 16,
    this.colorBorderEnable = Colors.black,
    this.suffexIconColor,
    this.prefexIconColor,
    this.fontWeight = FontWeight.w600,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.helperText = '',
    this.prefexIcon,
    this.contentPadding = 12,
    this.textAlign = TextAlign.right,
    this.textDirection = TextDirection.rtl,
    this.prefexTxt,
    this.elevation,
    this.fillColor,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return TextFormField(
      cursorColor:Colors.white ,
      style: TextStyle(color: Colors.white),
      onSaved: (val) => onSaved!(val),
      validator: (val) => validator!(val),
      onFieldSubmitted :(val) => onSubmitted!(val),
     // onChanged:(val) => onChange!(),
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixText: prefexTxt,
        hintText: hintTxt ,
        hintStyle: hintStyle,
        labelText: label,
        labelStyle: labelStyle,
        filled: fillColor != null,
        fillColor: fillColor,
        suffixIcon:  IconButton(
          onPressed: () => onPressedSuffexIcon!(),
          icon: Icon(suffexIcon),
        ),
        suffixIconColor: suffexIconColor,
        prefixIcon: IconButton(
          icon: Icon(prefexIcon),
          onPressed:() => onPressedPrefexIcon!(),
        ),
        prefixIconColor: prefexIconColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color:colorBorderEnable!,),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius!),
          borderSide:  BorderSide(color: colorBorder!),//out color
        ),
        border: OutlineInputBorder(),
      ),
      mouseCursor: MouseCursor.defer,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      //focusNode: focusNode, // Add focusNode here
    );
  }
}