import 'package:flutter/material.dart';

import 'app_color.dart';

class AppStyles{

  // Light Theme
  static ThemeData lightTheme(){
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: AppColors.PRIMARY_COLOR,
      primaryColorLight: AppColors.PRIMARY_COLOR_LIGHT,
      primaryColorDark: AppColors.PRIMARY_COLOR_DARK,
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.all(16),
        hintStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.normal,
        ),
        labelStyle: TextStyle(
          color: AppColors.PRIMARY_COLOR,
          fontWeight: FontWeight.bold,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.PRIMARY_COLOR_DARK,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.PRIMARY_COLOR,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2.5,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
        ),
      ),
      buttonTheme: const ButtonThemeData(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            )
        ),
        textTheme:ButtonTextTheme.normal,
        buttonColor: AppColors.ACCENT_COLOR,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.ACCENT_COLOR),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(){
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      primaryColor: AppColors.PRIMARY_COLOR,
      primaryColorLight: AppColors.PRIMARY_COLOR_LIGHT,
      primaryColorDark: AppColors.PRIMARY_COLOR_DARK, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.ACCENT_COLOR),
    );
  }
}