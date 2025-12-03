import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: const Border(
                    bottom: BorderSide(color: AppColor.offWhite, width: 1),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Text(
                  "Notifications",
                  style: AppTextStyle(context).bodyTextH1,
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacerH(40.h),
              // Body content
              const MessageTextWidget(msg: 'No Notifications Found'),
              AppSpacerH(20.h),
              SizedBox(
                // height: 154.h,
                // width: 154.w,
                child: Image.asset(
                  'assets/images/png/hibernation.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 50.h), // optional bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
