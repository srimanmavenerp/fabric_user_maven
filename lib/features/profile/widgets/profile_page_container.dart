import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';

class ProfilePageContainer extends StatelessWidget {
  const ProfilePageContainer({
    Key? key,
    required this.icon,
    required this.text,
    this.ontap,
    required this.isborder,
  }) : super(key: key);
  final String icon;
  final String text;
  final Function()? ontap;
  final bool isborder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        // height: 48.h,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.gray.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(icon, color: AppColor.gray),
                    AppSpacerW(18.w),
                    Text(
                      text,
                      style: AppTextStyle(
                        context,
                      ).bodyText.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                  color: colors(context).bodyTextColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
