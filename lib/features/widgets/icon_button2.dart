import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';

class AppIconButton2 extends StatelessWidget {
  const AppIconButton2({
    Key? key,
    this.width = double.infinity,
    this.height,
    this.buttonColor = AppColor.red,
    required this.title,
    this.onTap,
    this.titleColor = AppColor.white,
    this.icon,
  }) : super(key: key);
  final double? width;
  final double? height;
  final Color buttonColor;
  final String title;
  final String? icon;
  final Color titleColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(48.r),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            title,
            style: AppTextStyle(context).bodyText.copyWith(
                  color: AppColor.offWhite,
                  fontWeight: FontWeight.w700,
                ),
          ),
          AppSpacerW(4.w),
          Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal).toString() ==
                  "ar"
              ? RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset("assets/svgs/right_arrow.svg",
                      width: 15.w, height: 6.25.h
                      // color: AppColors.white,
                      ),
                )
              : SvgPicture.asset(icon ?? "assets/svgs/right_arrow.svg",
                  width: 15.w, height: 6.25.h
                  // color: AppColors.white,
                  ),
        ]),
      ),
    );
  }
}
