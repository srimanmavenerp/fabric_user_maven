// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/address/logic/addresss_providers.dart';
import 'package:laundrymart/features/address/model/address_list_model/address.dart';
import 'package:laundrymart/features/cart/my_cart.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/input_field_decorations.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';

class AddAddress extends ConsumerStatefulWidget {
  const AddAddress({super.key, this.address});
  final Address? address;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAddressState();
}

class _AddAddressState extends ConsumerState<AddAddress> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  bool ischeked = false;

  List<String> index = ["HOME", "OFFICE", "OTHER"];
  int getSelectedIndex(Address address) {
    // ignore: unnecessary_null_comparison
    if (address == null) {
      return 0;
    } else if (address.addressName == "HOME") {
      return 0;
    } else if (address.addressName == "OFFICE") {
      return 1;
    } else {
      return 2;
    }
  }

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    ischeked = widget.address?.isDefault == 1 ? true : false;
    // Initialize selectedIndex using the address model
    selectedIndex = widget.address != null
        ? getSelectedIndex(widget.address!)
        : 0;
  }

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(addAddresProvider);
    ref.watch(updateAddresProvider);
    return Stack(
      children: [
        ScreenWrapper(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: FormBuilder(
            key: _formkey,
            initialValue: widget.address != null ? widget.address!.toMap() : {},
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                AppSpacerH(112.h),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      children: [
                        AppSpacerH(16.h),
                        FormBuilderTextField(
                          name: "area",
                          style: AppTextStyle(context).bodyTextSmal,
                          decoration: AppInputDecor(context)
                              .loginPageInputDecor2
                              .copyWith(labelText: S.of(context).areaex),
                          textInputAction: TextInputAction.next,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        AppSpacerH(20.h),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: FormBuilderTextField(
                                  name: "house_no",
                                  style: AppTextStyle(context).bodyTextSmal,
                                  decoration: AppInputDecor(context)
                                      .loginPageInputDecor2
                                      .copyWith(
                                        labelText: S.of(context).houseno,
                                      ),
                                  textInputAction: TextInputAction.next,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ),
                            AppSpacerW(12.w),
                            Expanded(
                              child: SizedBox(
                                child: FormBuilderTextField(
                                  name: "road_no",
                                  style: AppTextStyle(context).bodyTextSmal,
                                  decoration: AppInputDecor(context)
                                      .loginPageInputDecor2
                                      .copyWith(
                                        labelText: "Road No#",
                                        labelStyle: AppTextStyle(context)
                                            .bodyTextSmal
                                            .copyWith(color: AppColor.gray),
                                      ),
                                  textInputAction: TextInputAction.next,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacerH(20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: FormBuilderTextField(
                                  name: "flat_no",
                                  style: AppTextStyle(context).bodyTextSmal,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppInputDecor(context)
                                      .loginPageInputDecor2
                                      .copyWith(labelText: S.of(context).flat),
                                ),
                              ),
                            ),
                            AppSpacerW(12.w),
                            Expanded(
                              child: SizedBox(
                                child: FormBuilderTextField(
                                  name: "post_code",
                                  style: AppTextStyle(context).bodyTextSmal,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppInputDecor(context)
                                      .loginPageInputDecor2
                                      .copyWith(
                                        labelText: S.of(context).postcode,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacerH(20.h),
                        FormBuilderTextField(
                          name: "address_line",
                          style: AppTextStyle(context).bodyTextSmal,
                          decoration: AppInputDecor(context)
                              .loginPageInputDecor2
                              .copyWith(labelText: S.of(context).adrsline),
                          textInputAction: TextInputAction.done,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        AppSpacerH(20.h),
                        // FormBuilderTextField(
                        //   name: "address_line2",
                        //   decoration: AppInputDecor.loginPageInputDecor2.copyWith(
                        //       labelText: S.of(context).adrsline_two,
                        //       labelStyle: AppTextDecor.regular14LightBlack
                        //           .copyWith(color: AppColors.icongray)),
                        // ),
                        // AppSpacerH(20.h)
                      ],
                    ),
                  ),
                ),
                AppSpacerH(8.h),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacerH(8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).addrsstag,
                              style: AppTextStyle(
                                context,
                              ).bodyText.copyWith(fontWeight: FontWeight.w700),
                            ),
                            AppSpacerH(8.h),
                            Row(
                              children: index
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = e.key;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: e.key == 0
                                                ? 0.h
                                                : Hive.box(
                                                            AppHSC
                                                                .appSettingsBox,
                                                          )
                                                          .get(AppHSC.appLocal)
                                                          .toString() ==
                                                      "ar"
                                                ? 0
                                                : 16.h,
                                            right: e.key == 0
                                                ? 0.h
                                                : Hive.box(
                                                            AppHSC
                                                                .appSettingsBox,
                                                          )
                                                          .get(AppHSC.appLocal)
                                                          .toString() ==
                                                      "ar"
                                                ? 16
                                                : 0.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: selectedIndex == e.key
                                                  ? Theme.of(
                                                      context,
                                                    ).primaryColor
                                                  : AppColor.offWhite,
                                              width: 1,
                                            ),
                                            color: AppColor.offWhite,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.h,
                                              vertical: 12.h,
                                            ),
                                            child: Center(
                                              child: Text(
                                                e.value,
                                                style: selectedIndex == e.key
                                                    ? AppTextStyle(
                                                        context,
                                                      ).bodyTextSmal.copyWith(
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                      )
                                                    : AppTextStyle(
                                                        context,
                                                      ).bodyTextSmal.copyWith(
                                                        color: AppColor.gray,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      AppSpacerH(8.h),
                      const Divider(color: AppColor.gray, thickness: 1),
                      AppSpacerH(8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: Checkbox(
                                value: ischeked,
                                activeColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    ischeked = !ischeked;
                                  });
                                },
                              ),
                            ),
                            AppSpacerW(8.w),
                            Text(
                              S.of(context).mkitdfltadrs,
                              style: AppTextStyle(context).bodyTextSmal
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      AppSpacerH(8.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: AppbarContainer(
            title: widget.address == null
                ? S.of(context).addadrs
                : S.of(context).updtadrs,
            ontap: () {
              context.nav.pop(context);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 70.h,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColor.offWhite.withOpacity(0.1),
                  offset: const Offset(0, -6),
                  blurRadius: 24,
                ),
              ],
            ),
            child: widget.address == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50.h,
                      child: ref
                          .watch(addAddresProvider)
                          .map(
                            initial: (_) => AppTextButton(
                              title: 'Add Address',
                              onTap: () {
                                if (_formkey.currentState!.saveAndValidate()) {
                                  final user = _formkey.currentState!.value;
                                  final Map<String, dynamic> arguments = {
                                    "address_name": index[selectedIndex],
                                    "is_default": ischeked ? true : false,
                                    ...user,
                                  };
                                  debugPrint(arguments.toString());
                                }
                                if (_formkey.currentState!.saveAndValidate()) {
                                  final user = _formkey.currentState!.value;
                                  final Map<String, dynamic> arguments = {
                                    "address_name": index[selectedIndex],
                                    "is_default": ischeked ? true : false,
                                    ...user,
                                  };
                                  ref
                                      .watch(addAddresProvider.notifier)
                                      .addAddress(address: arguments);
                                }
                              },
                            ),
                            loading: (_) => const LoadingWidget(),
                            loaded: (_) {
                              Future.delayed(transissionDuration).then((value) {
                                ref.refresh(updateAddresProvider);
                                ref.refresh(addresListProvider);
                                ref.refresh(addAddresProvider);
                                Future.delayed(transissionDuration).then((
                                  value,
                                ) {
                                  context.nav.pop();
                                });
                              });
                              return const MessageTextWidget(msg: 'Success');
                            },
                            error: (e) {
                              Future.delayed(transissionDuration).then(
                                (value) => {
                                  ref.refresh(updateAddresProvider),
                                  ref.refresh(addresListProvider),
                                  ref.refresh(addAddresProvider),
                                },
                              );
                              return ErrorTextWidget(error: e.error);
                            },
                          ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50.h,
                      child: ref
                          .watch(updateAddresProvider)
                          .map(
                            initial: (_) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.h),
                              child: AppTextButton(
                                title: 'Update Address',
                                onTap: () {
                                  if (_formkey.currentState!
                                      .saveAndValidate()) {
                                    final user = _formkey.currentState!.value;
                                    final Map<String, dynamic> arguments = {
                                      "address_name": index[selectedIndex],
                                      "is_default": ischeked ? true : false,
                                      ...user,
                                    };
                                    ref
                                        .watch(updateAddresProvider.notifier)
                                        .updateAddress(
                                          address: arguments,
                                          addressID: widget.address!.id!
                                              .toString(),
                                        );
                                  }
                                },
                              ),
                            ),
                            loading: (_) => const LoadingWidget(),
                            loaded: (_) {
                              Future.delayed(transissionDuration).then((value) {
                                ref.refresh(updateAddresProvider);
                                ref.refresh(addresListProvider);
                                ref.refresh(addAddresProvider);
                                Future.delayed(transissionDuration).then((
                                  value,
                                ) {
                                  context.nav.pop();
                                });
                              });
                              return const MessageTextWidget(msg: 'Success');
                            },
                            error: (e) {
                              Future.delayed(transissionDuration).then(
                                (value) => {
                                  ref.refresh(updateAddresProvider),
                                  ref.refresh(addresListProvider),
                                  ref.refresh(addAddresProvider),
                                },
                              );
                              return ErrorTextWidget(error: e.error);
                            },
                          ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
