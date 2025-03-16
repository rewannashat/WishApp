import 'package:flutter/material.dart';
import 'package:setup_library/presentation/resources/values_manager.dart';

import 'colors-manager.dart';
import 'styles-manager.dart';

ThemeData getApplightTheme () {
  return ThemeData(

    // main color
    scaffoldBackgroundColor: Colors.white,
    primaryColor: ColorsManager.drawerColor,
    primaryColorLight: ColorsManager.drawerColor,
    primaryColorDark: ColorsManager.baseTextColor,
    disabledColor: ColorsManager.disableButtonColor,
    splashColor: ColorsManager.greyColor,


    // card view theme
    cardTheme: const CardTheme(
      color: ColorsManager.backGroundPhotoColor,
      shadowColor: ColorsManager.greyColor,
      elevation: AppSize.s10,
      margin: EdgeInsetsDirectional.symmetric(
        horizontal: AppMargin.m10,
        vertical: AppMargin.m15,
      ),
    ),

    // app bar theme
    appBarTheme: AppBarTheme(
      elevation: AppSize.s0,
      color: Colors.white,
      centerTitle: true,
      titleTextStyle: getLightTextStyle(color: ColorsManager.blackColor) as TextStyle,
    ),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getMediumTextStyle(color: ColorsManager.buttonColor) as TextStyle, // toDo
        //  primary: ColorsManager.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s30),
        ),
      ),
    ),

    // button theme

    // text theme
    /*textTheme: TextTheme(
      headline1: getRegularTitleStyle(color: ColorsManager.titleTextColor) as TextStyle ,
      headline2: getBoldTextStyle(color: ColorsManager.titleTextColor) as TextStyle,
      bodyMedium: getRegularTextStyle(color:ColorsManager.baseTextColor) as TextStyle ,
      headlineSmall: getLightTextStyle(color: ColorsManager.staticTextColor) as TextStyle,
      button: getMediumTextStyle(color: ColorsManager.whiteColor) as TextStyle,
    ),*/

    // input theme
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsetsDirectional.symmetric(
        vertical: AppSize.s10, horizontal: AppSize.s8,
      ),
      hintStyle: getLightTextStyle(color: ColorsManager.greyColor) as TextStyle,
      labelStyle: getLightTextStyle(color: ColorsManager.blackColor) as TextStyle,
      errorStyle: getLightTextStyle(color: ColorsManager.redColor) as TextStyle,

      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorsManager.greyColor , width: AppSize.s5),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorsManager.buttonColor , width: AppSize.s5),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorsManager.redColor , width: AppSize.s5),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorsManager.redColor , width: AppSize.s5),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
    ),

  );

}
