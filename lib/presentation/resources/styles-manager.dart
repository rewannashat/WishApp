import 'package:flutter/material.dart';  // This automatically imports the correct TextStyle class
import 'font-manager.dart';

TextStyle _getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required String fontFamily,
  required Color color,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    color: color,
  );
}

// light text
TextStyle getLightTextStyle({double fontSize = FontSize.s10, required Color color}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWightManager.fontWeightLight,
    fontFamily: FontManager.fontFamilyApp,
    color: color,
  );
}

// Regular text
TextStyle getRegularTextStyle({double fontSize = FontSize.s12, required Color color}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWightManager.fontWeightRegular,
    fontFamily: FontManager.fontFamilyApp,
    color: color,
  );
}

// Medium text
TextStyle getMediumTextStyle({double fontSize = FontSize.s15, required Color color}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWightManager.fontWeightMedium,
    fontFamily: FontManager.fontFamilyTitle,
    color: color,
  );
}

// SemiBold text
TextStyle getSemiBoldTextStyle({double fontSize = FontSize.s20, required Color color}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWightManager.fontWeightSemiBold,
    fontFamily: FontManager.fontFamilyApp,
    color: color,
  );
}

// Bold text
TextStyle getBoldTextStyle({double fontSize = FontSize.s30, required Color color}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWightManager.fontWeightBold,
    fontFamily: FontManager.fontFamilyApp,
    color: color,
  );
}

// Regular Title
TextStyle getRegularTitleStyle({double fontSize = FontSize.s20, required Color color}) {
  return _getTextStyle(
    fontSize: fontSize,
    fontWeight: FontWightManager.fontWeightRegular,
    fontFamily: FontManager.fontFamilyTitle,
    color: color,
  );
}
