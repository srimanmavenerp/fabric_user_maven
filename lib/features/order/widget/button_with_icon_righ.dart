import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';

class AppRightIconTextButton extends StatelessWidget {
  const AppRightIconTextButton({
    super.key,
    this.width = double.infinity,
    this.height,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor,
    required this.icon,
  });
  final double? width;
  final double? height;
  final Color? buttonColor;
  final String title;
  final IconData icon;
  final Color? titleColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50.h,
        width: width,
        padding: EdgeInsets.only(left: 5.w),
        decoration: BoxDecoration(
          color: buttonColor ?? AppColor.blue,
          borderRadius: BorderRadius.circular(5.w),
          border: Border.all(color: AppColor.offWhite),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyle(context).bodyTextExtraSmall.copyWith(
                    color: titleColor ?? AppColor.offWhite,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(width: 10.w),
            Icon(
              icon,
            ),
          ],
        ),
      ),
    );
  }
}
