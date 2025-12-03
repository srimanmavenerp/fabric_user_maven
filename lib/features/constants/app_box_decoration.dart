import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';

class AppBoxDecorations {
  AppBoxDecorations._();

  static const BoxDecoration topBar = BoxDecoration(
    color: AppColor.white,
    border: Border(bottom: BorderSide(color: AppColor.gray)),
  );
  static BoxDecoration topBarv2 = BoxDecoration(
    color: AppColor.white,
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF000000).withOpacity(0.2),
        offset: const Offset(0, 2),
        blurRadius: 10,
      )
    ],
  );
  static BoxDecoration pageCommonCard = BoxDecoration(
    color: AppColor.white,
    borderRadius: BorderRadius.circular(5.w),
  );
}
