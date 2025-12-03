import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundrymart/features/auth/logic/auth_providers.dart';
import 'package:laundrymart/features/auth/logic/misc_provider.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class LoginOtpScreen extends ConsumerStatefulWidget {
  const LoginOtpScreen({
    super.key,
    required this.contact,
    required this.isSignUp,
  });
  final String contact;
  final bool isSignUp;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends ConsumerState<LoginOtpScreen> {
  int otpTime = 0;
  Timer? timer;
  List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    startTimer();
    super.initState();
    Future.delayed(500.milisec).then((value) {
      (ref.watch(otpProvider));
    });
  }

  startTimer() {
    otpTime = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timex) {
      setState(() {
        if (otpTime > 0) {
          otpTime--;
        } else {
          timer?.cancel();
          timer = null;
        }
      });
    });
  }

  @override
  void dispose() {
    timer = null;
    for (TextEditingController controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String verificationType = ref
        .read(appSettingDataProvider.notifier)
        .state
        .deviceType;
    return ScreenWrapper(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppSpacerH(44.h),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                Theme.of(context).scaffoldBackgroundColor == AppColor.black
                    ? "assets/images/png/fabric.png"
                    : "assets/images/png/fabric_touch logo app (1).png",
                width: 150.w,
                height: 80.h,
                fit: BoxFit.contain,
              ),
            ),
            AppSpacerH(8.h),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/svgs/otp.svg",
                width: 123.w,
                height: 123.h,
                fit: BoxFit.contain,
              ),
            ),
            AppSpacerH(40.h),
            Text(
              S.of(context).phnvrfctn,
              style: AppTextStyle(context).bodyTextSmal.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            AppSpacerH(4.h),
            Text(
              "${S.of(context).ndgtotp} ${widget.contact}",
              style: AppTextStyle(
                context,
              ).bodyText.copyWith(color: AppColor.gray),
            ),
            AppSpacerH(16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(controllers.length, (index) {
                return _textFieldOTP(
                  first: index == 0 ? true : false,
                  last: index == controllers.length - 1 ? true : false,
                  controller: controllers[index],
                );
              }),
            ),
            AppSpacerH(12.h),
            otpTime == 0
                ? Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(90, 0),
                      ),
                      onPressed: () {
                        ref
                            .watch(forgotPassProvider.notifier)
                            .forgotPassword(
                              contact: widget.contact,
                              verificatonType: verificationType,
                            );
                        startTimer();
                      },
                      child: const Text(
                        "Resend",
                        style: TextStyle(color: AppColor.green),
                      ),
                    ),
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: S.of(context).otpwillbesnd,
                          style: AppTextStyle(
                            context,
                          ).bodyTextSmal.copyWith(color: AppColor.black),
                        ),
                        TextSpan(
                          text: ' 00:${otpTime > 9 ? otpTime : '0$otpTime'}',
                          style: AppTextStyle(context).bodyTextSmal.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
            AppSpacerH(30.h),
            Consumer(
              builder: (context, ref, child) {
                return ref
                    .watch(forgotPassOtpVerificationProvider)
                    .map(
                      error: (e) {
                        Future.delayed(transissionDuration).then((value) {
                          ref.invalidate(forgotPassOtpVerificationProvider);
                        });
                        return ErrorTextWidget(error: e.error);
                      },
                      loaded: (d) {
                        Future.delayed(transissionDuration).then((value) {
                          ref.invalidate(forgotPassOtpVerificationProvider);
                          if (widget.isSignUp) {
                            // Navigate to the dashboard
                            context.nav.pushNamed(Routes.bottomnavScreen);
                          } else {
                            context.nav.pushNamed(
                              Routes.changePass,
                              arguments: d.data.data!.token,
                            );
                          }
                        });
                        return MessageTextWidget(msg: S.of(context).scs);
                      },
                      initial: (_) {
                        return AppTextButton(
                          buttonColor: Theme.of(context).primaryColor,
                          title: "Confirm OTP",
                          titleColor: AppColor.white,
                          onTap: () {
                            if (controllers[0].text.isEmpty ||
                                controllers[1].text.isEmpty ||
                                controllers[2].text.isEmpty ||
                                controllers[3].text.isEmpty) {
                              return;
                            } else {
                              String otp = '';
                              for (TextEditingController controller
                                  in controllers) {
                                otp += controller.text;
                              }
                              print("OTP: $otp");
                              ref
                                  .watch(
                                    forgotPassOtpVerificationProvider.notifier,
                                  )
                                  .verifyOtp(widget.contact, otp);
                            }
                          },
                        );
                      },
                      loading: (_) {
                        return const LoadingWidget();
                      },
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, last, required controller}) {
    return SizedBox(
      width: 48.w,
      height: 60.h,
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: TextField(
            controller: controller,
            autofocus: false,
            onChanged: (value) {
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && first == false) {
                FocusScope.of(context).previousFocus();
              }
            },
            showCursor: true,
            readOnly: false,
            textAlign: TextAlign.center,
            style: AppTextStyle(
              context,
            ).bodyTextH1.copyWith(color: Theme.of(context).primaryColor),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              hintText: '_',
              hintStyle: AppTextStyle(
                context,
              ).bodyTextSmal.copyWith(color: AppColor.black),
              counter: const Offstage(),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: AppColor.offWhite,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
