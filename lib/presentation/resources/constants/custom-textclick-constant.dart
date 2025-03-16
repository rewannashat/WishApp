import 'package:flutter/material.dart';

import 'custom-text-constant.dart';

class CustomTextClick extends StatelessWidget {
  final String? txt ;

  final Function? function;

  final Color? color;

  final FontWeight? fontWeight;

  final String? fontfamily;

  final TextAlign? textAlign;

  final double? fontSize;

  const CustomTextClick(
      {super.key,
        this.txt = "",
        this.function ,
        this.color = Colors.black,
        this.fontWeight = FontWeight.bold,
        this.fontfamily = '',
        this.textAlign = TextAlign.center,
        this.fontSize = 5
      }) ;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => function!(),
      child: CustomText(
        txt: txt!,
        color: color,
        fontWeight: fontWeight,
        textAlign: textAlign,
        fontfamily: fontfamily!,
        fontSize: fontSize,
      ),
    );
  }
}