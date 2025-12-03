import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:laundrymart/features/auth/logic/auth_providers.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/input_field_decorations.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/others/widgets/app_nav_bar.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/entensions.dart';
import 'package:laundrymart/utils/routes.dart';

// ignore: must_be_immutable
class RecoverPasswordStageOne extends ConsumerWidget {
  final FocusNode fNode = FocusNode();
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  String contact = '';

  RecoverPasswordStageOne({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String verificationType = ref
        .read(appSettingDataProvider.notifier)
        .state
        .deviceType;
    print(verificationType);
    return ScreenWrapper(
      child: FormBuilder(
        key: _formkey,
        child: Container(
          padding: EdgeInsets.all(16),
          // padding: EdgeInsets.fromLTRB(20.w, 44.h, 20.w, 0),
          // height: 812.h,
          // width: 375.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNavbar(
                onBack: () {
                  context.nav.pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppSpacerH(40.h),
                      Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/svgs/Recover Password.svg',
                          height: 180.h,
                          width: 180.w,
                        ),
                      ),
                      AppSpacerH(40.h),
                      Text(
                        S.of(context).rcvrpswrd,
                        style: AppTextStyle(context).bodyTextH1.copyWith(
                          color: AppColor.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AppSpacerH(5.h),
                      Text(
                        "Enter your phone number to recover Password",
                        style: AppTextStyle(context).bodyTextSmal.copyWith(
                          color: AppColor.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      AppSpacerH(20.h),
                      Column(
                        children: [
                          AppSpacerH(30.h),
                          FormBuilderTextField(
                            focusNode: fNode,
                            name: 'contact',
                            decoration: AppInputDecor(context)
                                .loginPageInputDecor
                                .copyWith(
                                  label: Text(
                                    getlabelText(
                                      verificationType: verificationType,
                                      context: context,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                            textInputAction: TextInputAction.done,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              verificationType == 'mobile'
                                  ? FormBuilderValidators.numeric(
                                      errorText: S.of(context).mobileNumber,
                                    )
                                  : FormBuilderValidators.email(
                                      errorText: S.of(context).emailAddress,
                                    ),
                            ]),
                          ),
                          AppSpacerH(80.h),
                          SizedBox(
                            height: 50.h,
                            child: Consumer(
                              builder: (context, ref, child) {
                                return ref
                                    .watch(forgotPassProvider)
                                    .map(
                                      initial: (_) => AppTextButton(
                                        buttonColor: Theme.of(
                                          context,
                                        ).primaryColor,
                                        title: S.of(context).sndotp,
                                        titleColor: AppColor.white,
                                        onTap: () {
                                          if (fNode.hasFocus) {
                                            fNode.unfocus();
                                          }

                                          if (_formkey.currentState != null &&
                                              _formkey.currentState!
                                                  .saveAndValidate()) {
                                            final formData =
                                                _formkey.currentState!.fields;
                                            contact =
                                                formData['contact']!.value
                                                    as String;
                                            ref
                                                .watch(
                                                  forgotPassProvider.notifier,
                                                )
                                                .forgotPassword(
                                                  contact: contact,
                                                  verificatonType:
                                                      verificationType,
                                                );
                                          }
                                        },
                                      ),
                                      error: (e) {
                                        Future.delayed(
                                          transissionDuration,
                                        ).then((value) {
                                          ref.invalidate(forgotPassProvider);
                                        });
                                        return ErrorTextWidget(error: e.error);
                                      },
                                      loaded: (_) {
                                        Future.delayed(
                                          transissionDuration,
                                        ).then((value) {
                                          ref.invalidate(forgotPassProvider);
                                          context.nav.pushNamed(
                                            Routes.loginOtpScreen,
                                            arguments: {
                                              'phone': contact,
                                              'isSignUp': false,
                                            },
                                          );
                                        });
                                        return MessageTextWidget(
                                          msg: S.of(context).scs,
                                        );
                                      },
                                      loading: (_) => const LoadingWidget(),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getlabelText({
    required String verificationType,
    required BuildContext context,
  }) {
    if (verificationType == 'mobile') {
      return S.of(context).mbl;
    } else {
      return S.of(context).email;
    }
  }
}
