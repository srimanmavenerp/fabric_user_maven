import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/others/widgets/app_back_button.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar(
      {super.key, this.title, this.onBack, this.showBack = true, this.height});
  final String? title;
  final Function()? onBack;
  final bool showBack;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 44.h,
      width: 390.w,
      child: Row(
        children: [
          if (showBack)
            Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal).toString() ==
                    "ar"
                ? RotatedBox(
                    quarterTurns: 2, // Rotate by 180 degrees (2 quarter turns)
                    child: AppBackButton(
                      size: 64.h,
                      onTap: onBack,
                    ),
                  )
                : AppBackButton(
                    size: 64.h,
                    onTap: onBack,
                  ),
          Align(
            child: SizedBox(
              height: 44.h,
              width: 260.w,
              child: Center(
                child: Text(
                  title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).bodyTextH1,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
