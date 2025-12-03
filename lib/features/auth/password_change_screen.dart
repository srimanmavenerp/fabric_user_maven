import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
import 'package:laundrymart/features/others/widgets/app_nav_bar.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/entensions.dart';
import 'package:laundrymart/utils/routes.dart';

class PasswordChangeScreen extends ConsumerStatefulWidget {
  const PasswordChangeScreen({super.key, required this.token});
  final String token;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends ConsumerState<PasswordChangeScreen> {
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  bool obsecureTextOne = true;
  bool obsecureTextTwo = true;
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ScreenWrapper(
        child: FormBuilder(
          key: _formkey,
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 44.h, 20.w, 0),
            height: 812.h,
            width: 375.w,
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
                        AppSpacerH(20.h),
                        Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/svgs/recoveryPass2.svg',
                            height: 160.h,
                            width: 160.w,
                          ),
                        ),
                        AppSpacerH(40.h),
                        Text(
                          S.of(context).crtnwpswrd,
                          style: AppTextStyle(context).bodyTextH1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                        AppSpacerH(5.h),
                        Text(
                          S.of(context).crturnwpswrd,
                          style: AppTextStyle(context).bodyTextSmal.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AppSpacerH(44.h),
                        Column(
                          children: [
                            AppSpacerH(33.h),
                            FormBuilderTextField(
                              focusNode: fNodes[0],
                              name: 'password',
                              obscureText: obsecureTextOne,
                              decoration: AppInputDecor(context)
                                  .loginPageInputDecor
                                  .copyWith(
                                    hintText: S.of(context).password,
                                    hintStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          obsecureTextOne = !obsecureTextOne;
                                        });
                                      },
                                      child: Icon(
                                        !obsecureTextOne
                                            ? Icons.visibility
                                            : Icons.visibility_off_outlined,
                                        color: AppColor.black,
                                      ),
                                    ),
                                  ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                (value) {
                                  if (value != null && value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ]),
                            ),
                            AppSpacerH(33.h),
                            FormBuilderTextField(
                              focusNode: fNodes[1],
                              name: 'password2',
                              obscureText: obsecureTextTwo,
                              decoration: AppInputDecor(context)
                                  .loginPageInputDecor
                                  .copyWith(
                                    hintStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    hintText: S.of(context).confirmPassword,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          obsecureTextTwo = !obsecureTextTwo;
                                        });
                                      },
                                      child: Icon(
                                        !obsecureTextTwo
                                            ? Icons.visibility
                                            : Icons.visibility_off_outlined,
                                        color: AppColor.black,
                                      ),
                                    ),
                                  ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                (value) {
                                  if (value != null && value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ]),
                            ),
                            AppSpacerH(51.h),
                            SizedBox(
                              height: 50.h,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return ref
                                      .watch(forgotPassResetPassProvider)
                                      .map(
                                        error: (e) {
                                          Future.delayed(
                                            transissionDuration,
                                          ).then((value) {
                                            ref.invalidate(
                                              forgotPassResetPassProvider,
                                            );
                                          });
                                          return ErrorTextWidget(
                                            error: e.error,
                                          );
                                        },
                                        initial: (_) {
                                          return AppTextButton(
                                            buttonColor: Theme.of(
                                              context,
                                            ).primaryColor,
                                            title: S.of(context).rstpswrd,
                                            titleColor: AppColor.white,
                                            onTap: () {
                                              for (final element in fNodes) {
                                                if (element.hasFocus) {
                                                  element.unfocus();
                                                }
                                              }

                                              if (_formkey.currentState !=
                                                      null &&
                                                  _formkey.currentState!
                                                      .saveAndValidate()) {
                                                final formData = _formkey
                                                    .currentState!
                                                    .fields;
                                                // match password
                                                if (formData['password']!
                                                        .value ==
                                                    formData['password2']!
                                                        .value) {
                                                  ref
                                                      .watch(
                                                        forgotPassResetPassProvider
                                                            .notifier,
                                                      )
                                                      .resetPassword(
                                                        formData['password']!
                                                                .value
                                                            as String,
                                                        formData['password2']!
                                                                .value
                                                            as String,
                                                        widget.token,
                                                      );
                                                } else {
                                                  EasyLoading.showError(
                                                    "Password doesn't match",
                                                  );
                                                }
                                              }
                                            },
                                          );
                                        },
                                        loaded: (_) {
                                          Future.delayed(
                                            transissionDuration,
                                          ).then((value) {
                                            EasyLoading.showSuccess(
                                              "Password changed successfully",
                                            );
                                            ref.invalidate(
                                              forgotPassResetPassProvider,
                                            ); //Refresh This so That App Doesn't Auto Login
                                            Future.delayed(buildDuration).then((
                                              value,
                                            ) {
                                              context.nav
                                                  .pushNamedAndRemoveUntil(
                                                    Routes.loginScreen,
                                                    (route) => false,
                                                  );
                                            });
                                          });
                                          return MessageTextWidget(
                                            msg: S.of(context).scs,
                                          );
                                        },
                                        loading: (_) {
                                          return const LoadingWidget();
                                        },
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
      ),
    );
  }
}
