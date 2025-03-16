import 'package:flutter/material.dart';

import '../font-manager.dart';
import 'custom-text-constant.dart';


class CustomButton extends StatelessWidget {
  final String? txt;
  final Color? colorButton;
  final Color? colorOutLineButton;
  final Color? colorTxt;
  final Function? onPressed;
  final Alignment? alignment;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily ;
  final double? width;
  final double? high;
  final double? borderRadius;
  final bool outLineBorder;
  final double widthOutLineBorder;

  const CustomButton({super.key,
    required this.txt,
    this.colorButton = Colors.white,
    this.colorTxt = Colors.white,
    this.onPressed,
    this.alignment = Alignment.center,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 16,
    required this.width,
    required this.high,
    this.borderRadius = 10,
    required this.outLineBorder,
    this.colorOutLineButton = Colors.white,
    this.widthOutLineBorder = 0,
    this.fontFamily = '',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: high,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
              side: outLineBorder
                  ? BorderSide(color: colorOutLineButton! ,width: widthOutLineBorder)
                  : BorderSide(color: colorButton!),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
              outLineBorder ? Colors.white : colorButton),
        ),
        onPressed: () {
          onPressed!();
        },
        child: CustomText(
          color: colorTxt,
          txt: txt,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontfamily: FontManager.fontFamilyTitle,
        ),
      ),
    );
  }
}