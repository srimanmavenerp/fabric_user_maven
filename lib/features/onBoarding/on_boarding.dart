import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/misc_providers.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/onBoarding/on_boarding_slider.dart';
import 'package:laundrymart/features/order/widget/button_with_icon_righ.dart';
import 'package:laundrymart/features/order/widget/journey_dot.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/utils/entensions.dart';
import 'package:laundrymart/utils/routes.dart';

// ignore: must_be_immutable
class OnBoardingScreen extends ConsumerWidget {
  OnBoardingScreen({super.key});
  bool shouldAnimate = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(onBoardingSliderIndexProvider);
    final imgPageController = ref.watch(
      onBoardingSliderControllerProvider('image'),
    );
    shouldAnimate = true;
    return ScreenWrapper(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    Theme.of(context).scaffoldBackgroundColor == AppColor.black
                        ? "assets/images/png/fabric.png"
                        : "assets/images/png/fabric_touch logo app (1).png",
                    height: 120.h,
                  ),
                ),
                AnimatedScale(
                  duration: transissionDuration,
                  scale: shouldAnimate ? 1 : 0,
                  child: const OnBoadringImageSlider(),
                ),
                AppSpacerH(20.h),
                SizedBox(
                  width: 335.w,
                  height: 6.h,
                  child: CustomJourneyDot(activeIndex: index, count: 3),
                ),
                AppSpacerH(20.h),
                const OnBoadringTextSlider(),
                AppSpacerH(20.h),
                AppTextButton(
                  title: 'Let`s Get Started',
                  onTap: () {
                    if (index < 2) {
                      ref.watch(onBoardingSliderIndexProvider.notifier).update((
                        state,
                      ) {
                        imgPageController.animateToPage(
                          state + 1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                        return state + 1;
                      });
                    } else {
                      final Box appSettingsBox = Hive.box(
                        AppHSC.appSettingsBox,
                      );
                      appSettingsBox.put(AppHSC.hasSeenSplashScreen, true);
                      context.nav.pushNamedAndRemoveUntil(
                        Routes.bottomnavScreen,
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
            if (index < 2)
              Positioned(
                right: 0,
                top: 0,
                child: SizedBox(
                  height: 30.h,
                  width: 80.w, // adjust to fit text + icon
                  child: TextButton(
                    onPressed: () {
                      final Box appSettingsBox = Hive.box(
                        AppHSC.appSettingsBox,
                      );
                      appSettingsBox.put(AppHSC.hasSeenSplashScreen, true);
                      context.nav.pushNamedAndRemoveUntil(
                        Routes.bottomnavScreen,
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 5.w), // spacing between text and icon
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final List<ObSliderData> slideData = [
  ObSliderData(
    image: 'assets/images/png/01.tutoral.png',
    text: 'Order online or via our app',
  ),
  ObSliderData(
    image: 'assets/images/png/02.tutorial.png',
    text: 'We Collect at a time that suits you and work our magic',
  ),
  ObSliderData(
    image: 'assets/images/png/03.tutorial.png',
    text: 'We return your clean clothes back to you',
  ),
];

class ObSliderData {
  String image;
  String text;
  ObSliderData({required this.image, required this.text});
}
