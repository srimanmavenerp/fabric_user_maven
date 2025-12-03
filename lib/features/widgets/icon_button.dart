import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    Key? key,
    this.width = double.infinity,
    this.height,
    this.buttonColor = AppColor.red,
    required this.title,
    this.onTap,
    this.titleColor = AppColor.white,
    this.borderRadius = 3,
  }) : super(key: key);
  final double? width;
  final double? height;
  final Color buttonColor;
  final String title;
  final Color titleColor;
  final Function()? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 48.h,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle(context)
                .bodyTextSmal
                .copyWith(color: titleColor, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
