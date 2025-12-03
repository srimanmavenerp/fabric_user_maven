import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';

AppColors colors(context) => Theme.of(context).extension<AppColors>()!;

ThemeData getAppTheme({
  required BuildContext context,
  required bool isDarkTheme,
}) {
  const primaryColor = Color(0xFF035f5f); // <-- your chosen primary

  return ThemeData(
    primaryColor: primaryColor,

    // full color scheme generated from the same primary
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    ),

    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        primaryColor: primaryColor,
        accentColor: primaryColor,
        buttonColor: primaryColor,
        buttonTextColor: AppColor.white,
        bodyTextColor: isDarkTheme ? AppColor.offWhite : AppColor.black,
        bodyTextSmallColor: isDarkTheme ? AppColor.offWhite : AppColor.gray,
        titleTextColor: isDarkTheme ? AppColor.white : AppColor.black,
        hintTextColor: AppColor.gray,
      ),
    ],

    fontFamily: 'Roboto',

    unselectedWidgetColor: primaryColor,

    scaffoldBackgroundColor: isDarkTheme ? AppColor.black : AppColor.offWhite,

    appBarTheme: AppBarTheme(
      backgroundColor: isDarkTheme ? AppColor.black : AppColor.white,
      titleTextStyle: TextStyle(
        color: isDarkTheme ? AppColor.white : AppColor.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(
        color: isDarkTheme ? AppColor.white : AppColor.black,
      ),
    ),
  );
}
