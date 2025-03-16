import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final txt;
  final double? fontSize;
  final int? maxLine;
  final double? height;
  final double? wordSpacing;
  final Color? color;
  final FontWeight? fontWeight;
  final String fontfamily ;
  final TextScaler? textScaler;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? lineSpace ;
  final TextDirection? txtDirection ;
  final bool? wrap ;
  final Color? decorationColor ;


  const CustomText({super.key,
    this.txt = "",
    this.height = 1,
    this.fontfamily = '' ,
    this.fontSize = 16,
    this.maxLine = 20 ,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.textAlign = TextAlign.justify,
    this.overflow = TextOverflow.ellipsis,
    this.wordSpacing = 0,
    this.decoration = TextDecoration.none,
    this.lineSpace = 1 ,
    this.txtDirection ,
    this.wrap = false ,
    this.decorationColor = Colors.black,
    this.textScaler ,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        color: color,
        fontFamily:fontfamily ,
        fontWeight: fontWeight,
        height: height,
        wordSpacing: wordSpacing,
        letterSpacing: lineSpace,
        decorationColor: decorationColor,
      ),
      textAlign: textAlign,
      softWrap : wrap ,
      textDirection: txtDirection,
      textScaler:textScaler,


    );
  }
}