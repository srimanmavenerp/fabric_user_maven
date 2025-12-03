import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/theme.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.size, this.onTap});
  final double? size;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? 36.h,
        width: size ?? 36.w,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              BorderRadius.circular(size != null ? size! * 0.27 : 10.h),
        ),
        child: Center(
          child: Icon(
            Icons.keyboard_arrow_left,
            color: colors(context).bodyTextColor,
            size: size != null ? size! * 0.5 : 18.h,
          ),
        ),
      ),
    );
  }
}
