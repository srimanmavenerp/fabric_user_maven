import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/auth/logic/auth_providers.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/input_field_decorations.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/others/logic/settings_provider.dart';
import 'package:laundrymart/features/widgets/icon_button2.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final List<FocusNode> fNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool obsecureText = true;
  bool obsecureTextTwo = true;
  bool shouldRemember = false;

  Country? country;
  @override
  void initState() {
    super.initState();
    for (final element in fNodes) {
      if (element.hasFocus) {
        element.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final bool twoStepVerification = ref
        .read(appSettingDataProvider.notifier)
        .state
        .twoStepVerification;
    final String verificationType = ref
        .read(appSettingDataProvider.notifier)
        .state
        .deviceType;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // resizeToAvoidBottomInset: true,
        body: FormBuilder(
          key: _formkey,
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 250.h,
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Center(
                              child: Hero(
                                tag: 'logo',
                                child: Image.asset(
                                  Theme.of(context).scaffoldBackgroundColor ==
                                          AppColor.black
                                      ? "assets/images/png/fabric.png"
                                      : "assets/images/png/fabric_touch logo app (1).png",
                                  width: 152.w,
                                  height: 80.h,
                                ),
                              ),
                            ),
                            AppSpacerH(15.h),
                            Center(
                              child: Image.asset(
                                'assets/images/png/signup_asset.png',
                                height: 145.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10.h),
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            focusNode: fNodes[0],
                            name: 'first_name',
                            style: AppTextStyle(context).bodyTextSmal,
                            decoration: AppInputDecor(context)
                                .loginPageInputDecor2
                                .copyWith(
                                  labelText: "Full Name *",
                                  labelStyle: AppTextStyle(
                                    context,
                                  ).bodyTextSmal.copyWith(color: AppColor.gray),
                                ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),

                          AppSpacerH(20.h),
                          FormBuilderTextField(
                            focusNode: fNodes[2],
                            name: 'email',
                            style: AppTextStyle(context).bodyTextSmal,
                            controller: emailController,
                            decoration: AppInputDecor(context)
                                .loginPageInputDecor2
                                .copyWith(
                                  labelText: 'Email (Optional)',
                                  labelStyle: AppTextStyle(
                                    context,
                                  ).bodyTextSmal.copyWith(color: AppColor.gray),
                                ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.email(),
                            ]),
                          ),
                          AppSpacerH(20.h),
                          FormBuilderTextField(
                            focusNode: fNodes[3],
                            name: 'mobile',
                            style: AppTextStyle(context).bodyTextSmal,
                            controller: mobileController,
                            decoration: AppInputDecor(context)
                                .loginPageInputDecor2
                                .copyWith(
                                  isDense: true,
                                  labelText: "${S.of(context).phoneNumber} *",
                                  labelStyle: AppTextStyle(
                                    context,
                                  ).bodyTextSmal.copyWith(color: AppColor.gray),
                                ),
                            keyboardType: TextInputType.phone,
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
                          ),

                          AppSpacerH(20.h),
                          FormBuilderTextField(
                            focusNode: fNodes[4],
                            name: 'password',
                            obscureText: obsecureText,
                            style: AppTextStyle(context).bodyTextSmal,
                            decoration: AppInputDecor(context)
                                .loginPageInputDecor2
                                .copyWith(
                                  labelText:
                                      "${S.of(context).createPassword} *",
                                  labelStyle: AppTextStyle(
                                    context,
                                  ).bodyTextSmal.copyWith(color: AppColor.gray),
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
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          AppSpacerH(20.h),
                          FormBuilderTextField(
                            focusNode: fNodes[5],
                            name: 'password_confirmation',
                            obscureText: obsecureTextTwo,
                            style: AppTextStyle(context).bodyTextSmal,
                            decoration: AppInputDecor(context)
                                .loginPageInputDecor2
                                .copyWith(
                                  labelText:
                                      "${S.of(context).confirmPassword} *",
                                  labelStyle: AppTextStyle(
                                    context,
                                  ).bodyTextSmal.copyWith(color: AppColor.gray),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obsecureTextTwo = !obsecureTextTwo;
                                      });
                                    },
                                    child: Icon(
                                      obsecureTextTwo
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
                          AppSpacerH(8.h),
                          // reduce checkbox button size
                          FormBuilderCheckbox(
                            name: 'accept_terms',
                            initialValue: false,
                            activeColor: Theme.of(context).primaryColor,
                            checkColor: AppColor.white,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            contentPadding: EdgeInsets.zero,
                            title: Wrap(
                              children: [
                                Text(
                                  "I agree to the ",
                                  style: AppTextStyle(
                                    context,
                                  ).bodyTextExtraSmall,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Consumer(
                                            builder: (context, ref, child) {
                                              ref.watch(tosProvider);
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        20.h,
                                                      ),
                                                ),
                                                child: ref
                                                    .watch(tosProvider)
                                                    .map(
                                                      initial: (_) =>
                                                          const SizedBox(),
                                                      loading: (_) =>
                                                          const LoadingWidget(),
                                                      loaded: (d) => Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              10.0,
                                                            ),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              d
                                                                  .data
                                                                  .data!
                                                                  .setting!
                                                                  .title!,
                                                              style:
                                                                  AppTextStyle(
                                                                    context,
                                                                  ).bodyTextH1.copyWith(
                                                                    color: AppColor
                                                                        .black,
                                                                  ),
                                                            ),
                                                            const AppSpacerH(
                                                              20,
                                                            ),
                                                            Expanded(
                                                              child: SingleChildScrollView(
                                                                child: Html(
                                                                  style: {
                                                                    '*': Style(
                                                                      color: AppColor
                                                                          .black,
                                                                      fontSize:
                                                                          FontSize(
                                                                            14.sp,
                                                                          ),
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                    ),
                                                                  },
                                                                  data:
                                                                      '${d.data.data!.setting!.content!}<p></p><p></p><p></p><p></p><p></p>',
                                                                ),
                                                              ),
                                                            ),
                                                            AppTextButton(
                                                              title: S
                                                                  .of(context)
                                                                  .okay,
                                                              onTap: () {
                                                                context.nav
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      error: (e) =>
                                                          ErrorTextWidget(
                                                            error: e.error,
                                                          ),
                                                    ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    "Terms and Conditions",
                                    style: AppTextStyle(context)
                                        .bodyTextExtraSmall
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),

                          AppSpacerH(10.h),
                          SizedBox(
                            height: 50.h,
                            child: Consumer(
                              builder: (context, ref, child) {
                                return ref
                                    .watch(registrationProvider)
                                    .map(
                                      initial: (_) {
                                        return AppIconButton2(
                                          buttonColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                          title: S.of(context).signUp,
                                          titleColor: AppColor.white,
                                          onTap: () {
                                            for (final element in fNodes) {
                                              if (element.hasFocus) {
                                                element.unfocus();
                                              }
                                            }
                                            if (_formkey.currentState != null &&
                                                _formkey.currentState!
                                                    .saveAndValidate()) {
                                              final value = {
                                                ..._formkey.currentState!.value,
                                              };

                                              if (value["accept_terms"] ==
                                                  true) {
                                                if (value["password"] ==
                                                    value["password_confirmation"]) {
                                                  final Map<String, dynamic>
                                                  udata = {
                                                    ...value,
                                                    "type": "mobile",
                                                  };
                                                  debugPrint(udata.toString());
                                                  ref
                                                      .watch(
                                                        registrationProvider
                                                            .notifier,
                                                      )
                                                      .register(udata);
                                                } else {
                                                  EasyLoading.showError(
                                                    "Password doesn't match",
                                                  );
                                                }
                                              } else {
                                                EasyLoading.showToast(
                                                  toastPosition:
                                                      EasyLoadingToastPosition
                                                          .bottom,
                                                  "Please accept terms and conditions",
                                                );
                                                return;
                                              }
                                            }
                                          },
                                        );
                                      },
                                      loading: (_) => const LoadingWidget(),
                                      loaded: (d) {
                                        final Box box = Hive.box(
                                          AppHSC.authBox,
                                        ); //Stores Auth Data
                                        final Box userBox = Hive.box(
                                          AppHSC.userBox,
                                        ); //Stores User Data
                                        box.putAll(
                                          d.data.data!.access!.toMap(),
                                        );
                                        userBox.putAll(
                                          d.data.data!.user!.toMap(),
                                        );
                                        Future.delayed(
                                          transissionDuration,
                                        ).then((value) {
                                          ref.invalidate(
                                            registrationProvider,
                                          ); //Refresh This so That App Doesn't Auto Login
                                          Future.delayed(buildDuration).then((
                                            value,
                                          ) {
                                            ref
                                                .watch(
                                                  homeScreenIndexProvider
                                                      .notifier,
                                                )
                                                .update((state) => 0);
                                            if (twoStepVerification) {
                                              ref
                                                  .read(
                                                    forgotPassProvider.notifier,
                                                  )
                                                  .forgotPassword(
                                                    contact:
                                                        verificationType ==
                                                            'mobile'
                                                        ? mobileController.text
                                                        : emailController.text,
                                                    verificatonType:
                                                        verificationType,
                                                  )
                                                  .then((value) {
                                                    context.nav.pushNamed(
                                                      Routes.loginOtpScreen,
                                                      arguments: {
                                                        'contact':
                                                            verificationType ==
                                                                'mobile'
                                                            ? mobileController
                                                                  .text
                                                            : emailController
                                                                  .text,
                                                        'isSignUp': true,
                                                      },
                                                    );
                                                  });
                                            } else {
                                              context.nav.pushNamed(
                                                Routes.bottomnavScreen,
                                              );
                                            }
                                          });
                                        });
                                        return MessageTextWidget(
                                          msg: S.of(context).scs,
                                        );
                                      },
                                      error: (e) {
                                        Future.delayed(
                                          transissionDuration,
                                        ).then((value) {
                                          ref.invalidate(registrationProvider);
                                        });
                                        return ErrorTextWidget(error: e.error);
                                      },
                                    );
                              },
                            ),
                          ),
                          AppSpacerH(15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${S.of(context).alreadyHaveAnAccount} ",
                                style: AppTextStyle(context).bodyTextExtraSmall,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.nav.pop();
                                },
                                child: Text(
                                  "${S.of(context).login} Here",
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacerH(44.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
