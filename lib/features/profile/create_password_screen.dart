import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/input_field_decorations.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/others/widgets/app_nav_bar.dart';
import 'package:laundrymart/features/profile/logic/profile_providers.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/utils/context_less_nav.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool createObsecureText = true;
  bool confirmObsecureText = true;
  bool newObsecureText = true;

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              AppSpacerH(40.h),
              AppNavbar(
                title: "Change Password",
                onBack: () {
                  context.nav.pop();
                },
              ),
              AppSpacerH(30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'current_password',
                      obscureText: createObsecureText,
                      style: AppTextStyle(context).bodyTextSmal,
                      decoration: AppInputDecor(context).loginPageInputDecor2
                          .copyWith(
                            labelText: "Current Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  createObsecureText = !createObsecureText;
                                });
                              },
                              child: Icon(
                                createObsecureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    AppSpacerH(20.h),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: newObsecureText,
                      style: AppTextStyle(context).bodyTextSmal,
                      decoration: AppInputDecor(context).loginPageInputDecor2
                          .copyWith(
                            labelText: "New Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  newObsecureText = !newObsecureText;
                                });
                              },
                              child: Icon(
                                newObsecureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                                color: colors(context).bodyTextColor,
                              ),
                            ),
                          ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    AppSpacerH(20.h),
                    FormBuilderTextField(
                      name: 'password_confirmation',
                      obscureText: confirmObsecureText,
                      style: AppTextStyle(context).bodyTextSmal,
                      decoration: AppInputDecor(context).loginPageInputDecor
                          .copyWith(
                            labelText: "Confirm Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  confirmObsecureText = !confirmObsecureText;
                                });
                              },
                              child: Icon(
                                confirmObsecureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                                color: colors(context).bodyTextColor,
                              ),
                            ),
                          ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    AppSpacerH(40.h),
                    ref
                        .watch(changePassProvider)
                        .map(
                          loading: (_) {
                            return const LoadingWidget();
                          },
                          error: (e) {
                            Future.delayed(transissionDuration).then((value) {
                              ref.invalidate(changePassProvider);
                            });
                            return ErrorTextWidget(error: e.error);
                          },
                          initial: (_) {
                            return AppTextButton(
                              title: "Save password".toUpperCase(),
                              onTap: () {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  final formData =
                                      _formKey.currentState!.fields;
                                  ref
                                      .watch(changePassProvider.notifier)
                                      .changePassword(
                                        formData["current_password"]!.value
                                            as String,
                                        formData["password"]!.value as String,
                                        formData["password_confirmation"]!.value
                                            as String,
                                      );
                                }
                              },
                            );
                          },
                          loaded: (_) {
                            Future.delayed(transissionDuration).then((value) {
                              ref.invalidate(
                                changePassProvider,
                              ); //Refresh This so That App Doesn't Auto Login

                              Future.delayed(buildDuration).then((value) {
                                context.nav.pop();
                              });
                            });
                            return const MessageTextWidget(msg: 'Success');
                          },
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
