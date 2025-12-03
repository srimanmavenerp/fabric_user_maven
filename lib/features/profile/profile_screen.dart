import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:laundrymart/features/auth/logic/auth_providers.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/input_field_decorations.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/profile/logic/profile_providers.dart';
import 'package:laundrymart/features/profile/widgets/profile_page_container.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/rounder_button.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  logoutpopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          return Center(
            child: ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.authBox).listenable(),
              builder: (context, Box authBox, Widget? child) {
                return ValueListenableBuilder(
                  valueListenable: Hive.box(AppHSC.userBox).listenable(),
                  builder: (context, Box userBox, Widget? child) {
                    return Padding(
                      padding: EdgeInsets.all(20.w),
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box(AppHSC.cartBox).listenable(),
                        builder: (context, Box cartbox, Widget? child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            height: 200.h,
                            width: 335.w,
                            padding: EdgeInsets.all(20.h),
                            child: ref
                                .watch(logOutProvider)
                                .map(
                                  initial: (_) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          S.of(context).urabttolgot,
                                          style: AppTextStyle(context).bodyText
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        AppSpacerH(10.h),
                                        Text(
                                          S.of(context).arusre,
                                          style: AppTextStyle(
                                            context,
                                          ).bodyTextSmal,
                                          textAlign: TextAlign.center,
                                        ),
                                        AppSpacerH(20.h),
                                        SizedBox(
                                          height: 50.h,
                                          width: 335.w,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: AppTextButton(
                                                  title: S.of(context).no,
                                                  titleColor: AppColor.black,
                                                  onTap: () {
                                                    context.nav.pop();
                                                  },
                                                ),
                                              ),
                                              AppSpacerW(10.w),
                                              Expanded(
                                                child: AppTextButton(
                                                  buttonColor: AppColor.white,
                                                  title: S.of(context).y,
                                                  titleColor: AppColor.black,
                                                  onTap: () {
                                                    ref
                                                        .watch(
                                                          logOutProvider
                                                              .notifier,
                                                        )
                                                        .logout();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  loading: (value) => const LoadingWidget(),
                                  error: (e) {
                                    Future.delayed(buildDuration).then((value) {
                                      ref.invalidate(logOutProvider);
                                    });
                                    return ErrorTextWidget(error: e.error);
                                  },
                                  loaded: (value) {
                                    Future.delayed(buildDuration).then((value) {
                                      context.nav.pop();
                                      userBox.clear();
                                      authBox.clear();
                                      cartbox.clear();
                                      ref.invalidate(logOutProvider);
                                      ref.invalidate(profileInfoProvider);
                                      context.nav.pushNamed(Routes.loginScreen);
                                    });
                                    return MessageTextWidget(
                                      msg: S.of(context).lgdot,
                                    );
                                  },
                                ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.authBox).listenable(),
      builder: (context, Box authBox, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.userBox).listenable(),
          builder: (context, Box userBox, Widget? child) {
            return ScreenWrapper(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    // height: 150.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          child: Row(
                            children: [
                              AppSpacerH(150.h),
                              SizedBox(
                                width: 66.w,
                                height: 66.h,
                                child: userBox.get('profile_photo_path') != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          50.h,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: userBox
                                              .get('profile_photo_path')
                                              .toString(),
                                          height: 100.h,
                                          width: 100.h,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error, size: 100.h),
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 60.h,
                                        color: colors(context).bodyTextColor,
                                      ),
                              ),
                              AppSpacerW(12.w),
                              InkWell(
                                onTap: () {
                                  if (authBox.get('token') != null) {
                                    context.nav.pushNamed(
                                      Routes.myProfileScreen,
                                    );
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userBox.get('profile_photo_path') != null
                                          ? userBox.get('name')! as String
                                          : S.of(context).plslgin,
                                      style: AppTextStyle(context).bodyText
                                          .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    AppSpacerH(6.h),
                                    if (userBox.get('mobile') != null)
                                      Text(
                                        userBox.get('mobile')! as String,
                                        style: AppTextStyle(
                                          context,
                                        ).bodyTextSmal,
                                      ),
                                  ],
                                ),
                              ),
                              if (authBox.get('token') == null)
                                Expanded(
                                  child: Align(
                                    alignment:
                                        Hive.box(
                                              AppHSC.appSettingsBox,
                                            ).get(AppHSC.appLocal).toString() ==
                                            "ar"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: AppRountedTextButton(
                                      title: S
                                          .of(context)
                                          .login, // S.of(context).password

                                      width: 90.w,
                                      onTap: () {
                                        context.nav.pushNamed(
                                          Routes.loginScreen,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else
                                Expanded(
                                  child: Align(
                                    alignment:
                                        Hive.box(
                                              AppHSC.appSettingsBox,
                                            ).get(AppHSC.appLocal).toString() ==
                                            "ar"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (authBox.get('token') != null) {
                                          context.nav.pushNamed(
                                            Routes.myProfileScreen,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 32.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF3F4F6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AppSpacerH(40.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: Hive.box(
                                    AppHSC.appSettingsBox,
                                  ).listenable(),
                                  builder: (context, box, _) {
                                    final isDarkTheme = box.get(
                                      AppHSC.isDarkTheme,
                                    );

                                    return LiteRollingSwitch(
                                      width: 120,
                                      textOnColor: AppColor.white,
                                      textOffColor: AppColor.blue,
                                      value: isDarkTheme ?? false,
                                      textOn: 'Dark',
                                      textOff: 'Light',
                                      colorOn:
                                          colors(context).primaryColor ??
                                          AppColor.offWhite,
                                      colorOff: AppColor.black,
                                      iconOn: Icons.dark_mode,
                                      iconOff: Icons.dark_mode,
                                      textSize: 16.0,
                                      onTap: () {},
                                      onDoubleTap: () {},
                                      onSwipe: () {},

                                      onChanged: (bool isDark) {
                                        setTheme(value: isDark);
                                      },
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: 120.w,
                                  child: const LocaLizationSelector(),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            if (authBox.get('token') != null)
                              ProfilePageContainer(
                                ontap: () {
                                  context.nav.pushNamed(
                                    Routes.manageAddressScreen,
                                    arguments: true,
                                  );
                                },
                                icon: 'assets/svgs/map_icon.svg',
                                text: S.of(context).mngaddrs,
                                isborder: true,
                              ),
                            AppSpacerH(8.h),
                            ProfilePageContainer(
                              ontap: () {
                                context.nav.pushNamed(
                                  Routes.termsandConditionsScreen,
                                );
                              },
                              icon: 'assets/svgs/t&c_icon.svg',
                              text: S.of(context).termsAndConditions,
                              isborder: true,
                            ),
                            AppSpacerH(8.h),
                            ProfilePageContainer(
                              ontap: () {
                                context.nav.pushNamed(
                                  Routes.privacyPolicyScreen,
                                );
                              },
                              icon: 'assets/svgs/p&p_icon.svg',
                              text: S.of(context).privacyPolicy,
                              isborder: true,
                            ),
                            AppSpacerH(8.h),
                            ProfilePageContainer(
                              ontap: () {
                                context.nav.pushNamed(Routes.aboutusScreen);
                              },
                              icon: 'assets/svgs/aboutus_icon.svg',
                              text: S.of(context).abt,
                              isborder: false,
                            ),
                            AppSpacerH(8.h),
                            if (authBox.get('token') != null)
                              ProfilePageContainer(
                                ontap: () {
                                  ref
                                      .watch(logOutProvider.notifier)
                                      .logout()
                                      .then((value) {
                                        Future.delayed(buildDuration).then((
                                          value,
                                        ) {
                                          context.nav.pop();
                                          userBox.clear();
                                          authBox.clear();
                                          ref.invalidate(logOutProvider);
                                          ref.invalidate(profileInfoProvider);
                                          context.nav.pushNamed(
                                            Routes.loginScreen,
                                          );
                                        });
                                      });
                                },
                                icon: 'assets/svgs/delete.svg',
                                text: S.of(context).deleteAccount,
                                isborder: true,
                              ),
                            AppSpacerH(25.h),
                            if (authBox.get('token') != null)
                              TextButton(
                                onPressed: () {
                                  logoutpopup(context);
                                },
                                style: TextButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  minimumSize: Size(335.w, 48.h),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svgs/logout_icon.svg",
                                    ),
                                    AppSpacerW(10.w),
                                    Text(
                                      "Log out",
                                      style: AppTextStyle(context).bodyText
                                          .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.red,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpacerH(30.h),
                  AppSpacerH(30.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class LocaLizationSelector extends StatefulWidget {
  const LocaLizationSelector({super.key});

  @override
  State<LocaLizationSelector> createState() => _LocaLizationSelectorState();
}

class _LocaLizationSelectorState extends State<LocaLizationSelector> {
  final List<AppLanguage> languages = [
    AppLanguage(name: '\ud83c\uddfa\ud83c\uddf8 ENG', value: 'en'),
    AppLanguage(name: '🇪🇬 مصر', value: 'ar'),
    AppLanguage(name: '🇹🇷 Tür', value: 'tr'),
    AppLanguage(name: '🇮🇳 हिंदी', value: 'in'),
    AppLanguage(name: '🇧🇩 বাংলা', value: 'bn'),
  ];

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<String>(
      isExpanded: true,
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      decoration: AppInputDecor(context).loginPageInputDecor.copyWith(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      initialValue:
          Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal) as String?,
      iconEnabledColor: colors(context).bodyTextColor,
      name: 'language',
      items: languages
          .map(
            (e) => DropdownMenuItem(
              value: e.value,
              child: FittedBox(
                child: Text(
                  e.name,
                  style: AppTextStyle(
                    context,
                  ).bodyTextSmal.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null && value != '') {
          Hive.box(AppHSC.appSettingsBox).put(AppHSC.appLocal, value);
        }
      },
    );
  }
}

class AppLanguage {
  String name;
  String value;
  AppLanguage({required this.name, required this.value});
}

Future setTheme({required bool value}) async {
  final appSettingsBox = await Hive.openBox(AppHSC.appSettingsBox);
  appSettingsBox.put(AppHSC.isDarkTheme, value);
}
