import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/input_field_decorations.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/others/widgets/app_nav_bar.dart';
import 'package:laundrymart/features/profile/logic/profile_providers.dart';
import 'package:laundrymart/features/widgets/icon_button.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  File? image;
  @override
  Widget build(BuildContext context) {
    ref.watch(profileInfoProvider);
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: Hive.box(AppHSC.userBox).listenable(),
          builder: (context, Box userBox, Widget? child) {
            final Map<String, dynamic> processedData = {};
            final Map unprocessedData = userBox.toMap();

            unprocessedData.forEach((key, value) {
              processedData[key.toString()] = value;
            });
            return FormBuilder(
              key: _formkey,
              initialValue: processedData,
              child: ScreenWrapper(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    AppSpacerH(44.h),
                    AppNavbar(
                      height: 80.h,
                      title: S.of(context).edtprfl,
                      onBack: () {
                        context.nav.pop();
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          // AppSpacerH(20.h),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (image == null) {
                                    final ImagePicker picker = ImagePicker();
                                    // Pick an image
                                    final XFile? images = await picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (images != null) {
                                      setState(() {
                                        image = File(images.path);
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      image = null;
                                    });
                                  }
                                },
                                child: (image != null)
                                    ? CircleAvatar(
                                        backgroundColor: AppColor.white,
                                        radius: 42,
                                        backgroundImage: FileImage(image!),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: AppColor.white,
                                        radius: 42,
                                        backgroundImage: NetworkImage(
                                          userBox.get('profile_photo_path')!
                                              as String,
                                        ),
                                      ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 26.h,
                                  width: 26.w,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      image != null
                                          ? Icons.close
                                          : Icons.photo_camera,
                                      color: AppColor.white,
                                      size: 18.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacerH(12.h),
                          Text(
                            userBox.get("name")! as String,
                            style: AppTextStyle(context).bodyTextH1,
                          ),
                          AppSpacerH(6.h),
                          Text(
                            userBox.get('mobile')! as String,
                            style: AppTextStyle(context).bodyTextSmal,
                          ),
                          AppSpacerH(16.h),
                        ],
                      ),
                    ),
                    AppSpacerH(8.h),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              AppSpacerH(16.h),
                              FormBuilderTextField(
                                name: "first_name",
                                style: AppTextStyle(context).bodyTextSmal,
                                decoration: AppInputDecor(context)
                                    .loginPageInputDecor2
                                    .copyWith(
                                      labelText: S.of(context).fullName,
                                      labelStyle: AppTextStyle(context)
                                          .bodyTextSmal
                                          .copyWith(color: AppColor.gray),
                                    ),
                              ),
                              AppSpacerH(20.h),
                              FormBuilderDropdown(
                                name: 'gender',
                                style: AppTextStyle(context).bodyTextSmal,
                                dropdownColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                decoration: AppInputDecor(context)
                                    .loginPageInputDecor2
                                    .copyWith(labelText: S.of(context).gndr),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Male',
                                    child: Text(S.of(context).male),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Female',
                                    child: Text(S.of(context).female),
                                  ),
                                ],
                              ),
                              AppSpacerH(20.h),
                              FormBuilderTextField(
                                name: "email",
                                style: AppTextStyle(context).bodyTextSmal,
                                decoration: AppInputDecor(context)
                                    .loginPageInputDecor2
                                    .copyWith(
                                      labelText: S.of(context).rmladrs,
                                      labelStyle: AppTextStyle(context)
                                          .bodyTextSmal
                                          .copyWith(color: AppColor.gray),
                                    ),
                                readOnly: true,
                              ),
                              AppSpacerH(20.h),
                              FormBuilderTextField(
                                style: AppTextStyle(context).bodyTextSmal,
                                name: "mobile",
                                decoration: AppInputDecor(context)
                                    .loginPageInputDecor2
                                    .copyWith(
                                      labelText: S.of(context).phnn,
                                      labelStyle: AppTextStyle(context)
                                          .bodyTextSmal
                                          .copyWith(color: AppColor.gray),
                                    ),
                                readOnly: true,
                              ),
                              AppSpacerH(20.h),
                              FormBuilderTextField(
                                style: AppTextStyle(context).bodyTextSmal,
                                name: "alternative_phone",
                                decoration: AppInputDecor(context)
                                    .loginPageInputDecor2
                                    .copyWith(
                                      labelText: S.of(context).altrntvphn,
                                      labelStyle: AppTextStyle(context)
                                          .bodyTextSmal
                                          .copyWith(color: AppColor.gray),
                                    ),
                              ),
                              AppSpacerH(20.h),
                              AppIconButton(
                                onTap: () {
                                  context.nav.pushNamed(
                                    Routes.changePasswordScreen,
                                  );
                                },
                                title: S.of(context).chngpswrd,
                                buttonColor: Theme.of(context).primaryColor,
                                borderRadius: 100,
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
          },
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 88.h,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColor.offWhite.withOpacity(0.1),
                  offset: const Offset(0, -6),
                  blurRadius: 14,
                ),
              ],
            ),
            child: ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.userBox).listenable(),
              builder: (BuildContext context, Box userBox, Widget? child) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 20.h,
                  ),
                  child: ref
                      .watch(profileUpdateProvider)
                      .map(
                        initial: (_) => AppIconButton(
                          onTap: () {
                            if (_formkey.currentState!.saveAndValidate()) {
                              ref
                                  .watch(profileUpdateProvider.notifier)
                                  .updateProfile(
                                    _formkey.currentState!.value,
                                    image,
                                  );
                            }
                          },
                          title: S.of(context).updtaprl,
                          buttonColor: Theme.of(context).primaryColor,
                          borderRadius: 100,
                        ),
                        loading: (_) => const LoadingWidget(),
                        loaded: (_) {
                          Future.delayed(transissionDuration).then((value) {
                            ref.invalidate(profileUpdateProvider);
                            ref.invalidate(profileInfoProvider);
                            Future.delayed(buildDuration).then((value) {
                              context.nav.pop();
                            });
                          });
                          return MessageTextWidget(msg: S.of(context).scs);
                        },
                        error: (e) {
                          Future.delayed(transissionDuration).then((_) {
                            ref.invalidate(profileUpdateProvider);
                          });
                          return ErrorTextWidget(error: e.error);
                        },
                      ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
