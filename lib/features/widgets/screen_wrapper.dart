import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/misc/global_functions.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    super.key,
    this.color = AppColor.offWhite,
    required this.child,
    this.padding,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });
  final Color color;
  final Widget child;
  final EdgeInsets? padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    AppGFunctions.changeStatusBarColor(color: Colors.transparent);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Container(
        height: 844.h,
        width: 390.w,
        padding: padding ?? EdgeInsets.zero,
        color: color,
        child: child,
      ),
    );
  }
}
