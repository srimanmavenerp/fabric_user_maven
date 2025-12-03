import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/theme.dart';

class AppTextStyle {
  final BuildContext context;
  AppTextStyle(this.context);

  TextStyle get bodyText => TextStyle(
        color: colors(context).bodyTextColor,
        fontSize: 16.sp,
      );
  TextStyle get bodyTextSmal => TextStyle(
        color: colors(context).bodyTextColor,
        fontSize: 14.sp,
      );
  TextStyle get bodyTextExtraSmall => TextStyle(
        color: colors(context).bodyTextSmallColor,
        fontSize: 12.sp,
      );
  TextStyle get bodyTextH1 => TextStyle(
        color: colors(context).bodyTextColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      );
}
