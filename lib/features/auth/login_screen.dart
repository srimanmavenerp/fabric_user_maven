import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/address/logic/addresss_providers.dart';
import 'package:laundrymart/features/auth/logic/auth_providers.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/input_field_decorations.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/widgets/icon_button2.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Country? country2;
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  final TextEditingController textEditingController = TextEditingController();
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    final bool verificationType = ref
        .read(appSettingDataProvider.notifier)
        .state
        .twoStepVerification;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: FormBuilder(
        key: _formkey,
        child: ScreenWrapper(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                    width: 152.w,
                    height: 80.h,
                    fit: BoxFit.contain,
                  ),
                ),
                AppSpacerH(8.h),
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/svgs/login_asset.svg",
                    height: 123.h,
                    width: 123.w,
                  ),
                ),
                AppSpacerH(8.h),
                Text(
                  S.of(context).eztogetservice,
                  style: AppTextStyle(context).bodyTextSmal,
                ),
                AppSpacerH(6.h),
                Text(
                  "Just Enter Phone Number to Login",
                  style: AppTextStyle(context).bodyTextH1,
                ),
                AppSpacerH(32.h),
                FormBuilderTextField(
                  focusNode: fNodes[0],
                  keyboardType: TextInputType.text,
                  style: AppTextStyle(context).bodyTextSmal,
                  decoration: AppInputDecor(context).loginPageInputDecor2
                      .copyWith(
                        isDense: true,
                        labelText: S.of(context).emailOrPhone,
                      ),
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(
                      6,
                      errorText: S.of(context).entravalidphnnmbr,
                    ),
                    FormBuilderValidators.maxLength(
                      12,
                      errorText: S.of(context).entravalidphnnmbr,
                    ),
                    FormBuilderValidators.required(),
                  ]),
                  name: 'mobile',
                ),
                AppSpacerH(20.h),
                FormBuilderTextField(
                  focusNode: fNodes[1],
                  name: 'password',
                  obscureText: obsecureText,
                  style: AppTextStyle(context).bodyTextSmal,
                  decoration: AppInputDecor(context).loginPageInputDecor2
                      .copyWith(
                        labelText: S.of(context).password,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obsecureText = !obsecureText;
                            });
                          },
                          child: Icon(
                            obsecureText
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    GestureDetector(
                      onTap: () {
                        if (verificationType) {
                          context.nav.pushNamed(
                            Routes.recoveryPasswordStageOne,
                          );
                        } else {
                          EasyLoading.showError(
                            "Two-step verification is not yet enabled. You cannot change your password without enabling two-step verification",
                          );
                        }
                      },
                      child: Text(
                        S.of(context).forgotPassword,
                        style: AppTextStyle(context).bodyTextExtraSmall
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
                AppSpacerH(32.h),
                ref
                    .watch(loginProvider)
                    .map(
                      initial: (_) {
                        return AppIconButton2(
                          onTap: () {
                            for (final elements in fNodes) {
                              if (elements.hasFocus) {
                                elements.unfocus();
                              }
                            }
                            if (_formkey.currentState != null &&
                                _formkey.currentState!.saveAndValidate()) {
                              final formData = _formkey.currentState!.value;

                              ref
                                  .watch(loginProvider.notifier)
                                  .login(
                                    formData["mobile"],
                                    formData["password"],
                                  );
                            }
                            final Box appSettingsBox = Hive.box(
                              AppHSC.appSettingsBox,
                            );
                            appSettingsBox.put(
                              AppHSC.hasSeenSplashScreen,
                              true,
                            );
                          },
                          title: S.of(context).login,
                          buttonColor: Theme.of(context).primaryColor,
                        );
                      },
                      error: (e) {
                        Future.delayed(transissionDuration).then((value) {
                          ref.invalidate(loginProvider);
                        });
                        return ErrorTextWidget(error: e.error);
                      },
                      loaded: (d) {
                        final Box box = Hive.box(AppHSC.authBox);
                        final Box userBox = Hive.box(AppHSC.userBox);
                        box.putAll(d.data.data!.access!.toMap());
                        userBox.putAll(d.data.data!.user!.toMap());
                        Future.delayed(transissionDuration).then((value) {
                          ref.invalidate(loginProvider);
                          ref.invalidate(addresListProvider);
                          Future.delayed(buildDuration).then((value) {
                            ref
                                .watch(homeScreenIndexProvider.notifier)
                                .update((state) => 0);
                            context.nav.pushNamedAndRemoveUntil(
                              Routes.bottomnavScreen,
                              (route) => false,
                            );
                          });
                        });
                        return MessageTextWidget(msg: S.of(context).scs);
                      },
                      loading: (_) {
                        return const LoadingWidget();
                      },
                    ),
                AppSpacerH(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${S.of(context).dontHaveAccount} ",
                      style: AppTextStyle(context).bodyTextExtraSmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.nav.pushNamed(Routes.signUpScreen);
                      },
                      child: Text(
                        "Sign Up Here",
                        style: AppTextStyle(context).bodyTextExtraSmall
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
                AppSpacerH(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
