import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    Key? key,
    this.width = double.infinity,
    this.height,
    this.buttonColor = AppColor.blue,
    required this.title,
    this.onTap,
    this.titleColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.iconheight,
  }) : super(key: key);
  final double? width;
  final double? height;
  final double? iconheight;
  final Color buttonColor;
  final String title;
  final Color? titleColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function()? onTap;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 48.h,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 48.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SvgPicture.asset(
                icon.toString(),
                height: iconheight ?? 40.h,
              ),
              AppSpacerW(2.2.w),
            ],
            Text(
              title,
              style: AppTextStyle(context).bodyTextSmal.copyWith(
                    color: titleColor ?? AppColor.offWhite,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
