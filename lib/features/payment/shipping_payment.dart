// ignore_for_file: use_build_context_synchronously, unused_result
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:laundrymart/features/address/logic/addresss_providers.dart';
import 'package:laundrymart/features/address/model/address_list_model/address.dart';
import 'package:laundrymart/features/cart/my_cart.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/global_functions.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/payment/logic/order_providers.dart';
import 'package:laundrymart/features/payment/model/order_place_model/order_place_model.dart';
import 'package:laundrymart/features/services/model/hive_cart_item_model.dart';
import 'package:laundrymart/features/store/logic/store_providers.dart';
import 'package:laundrymart/features/widgets/busy_loader.dart';
import 'package:laundrymart/features/widgets/icon_button.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/features/widgets/text_button.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class ShippingAndPaymentScreen extends ConsumerStatefulWidget {
  const ShippingAndPaymentScreen({super.key, this.address});
  final Address? address;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShippingAndPaymentScreenState();
}

class _ShippingAndPaymentScreenState
    extends ConsumerState<ShippingAndPaymentScreen> {
  int? couponID;
  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
  double deliver = 0.0;
  double? total;
  final TextEditingController coupon = TextEditingController();
  final TextEditingController pickDateController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();
  PaymentType selectedPaymentType = PaymentType.cod;

  String? selectedAddressId;

  DateTime? pickupDate;
  DateTime? deliveryDate;

  @override
  void initState() {
    super.initState();
    pickupDate = DateTime.now();
    deliveryDate = DateTime.now();
  }

  void pickDate() {
    showDatePicker(
      context: context,
      initialDate: pickupDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((value) {
      if (value != null) {
        setState(() {
          pickupDate = value;
          pickDateController.text = value.toString().split(" ")[0];
        });
      }
    });
  }

  void pickDeliveryDate() {
    showDatePicker(
      context: context,
      initialDate: pickupDate!.add(const Duration(days: 1)),
      firstDate: pickupDate!.add(const Duration(days: 1)),
      lastDate: pickupDate!.add(const Duration(days: 30)),
    ).then((value) {
      if (value != null) {
        setState(() {
          deliveryDate = value;
          deliveryDateController.text = value.toString().split(" ")[0];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currency = ref
        .read(appSettingDataProvider.notifier)
        .state
        .currency;
    String storeId = Hive.box(AppHSC.appSettingsBox).get("storeid");
    ref
        .watch(orderOptionsProvider(storeId))
        .maybeWhen(
          loaded: (d) {
            deliver = double.parse(d.data!.deliveryCharge!);
          },
          orElse: () {},
        );

    // ref.watch(couponProvider);
    // ref.watch(discountAmountProvider);
    String? addressid;
    // ref.watch(couponProvider).maybeWhen(
    //   orElse: () {
    //     print("DDD e");
    //   },
    //   loaded: (_) {
    //     couponID = _.data?.coupon?.id;
    //     print("DDD ${_.data?.coupon?.id}");
    //   },
    // );
    return Stack(
      children: [
        ScreenWrapper(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              AppSpacerH(112.h),
              // Pickup Schedule
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).scaffoldBackgroundColor ==
                          AppColor.black
                      ? AppColor.black
                      : AppColor.white,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.offWhite,
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacerH(16.h),
                      Text(
                        S.of(context).schdl,
                        style: AppTextStyle(
                          context,
                        ).bodyTextSmal.copyWith(fontWeight: FontWeight.w700),
                      ),
                      AppSpacerH(15.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onTap: () {
                                if (deliveryDateController.text.isNotEmpty) {
                                  deliveryDateController.clear();
                                  deliveryDate = null;
                                }
                                pickDate();
                              },
                              style: AppTextStyle(context).bodyTextSmal,
                              controller: pickDateController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColor.blue,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColor.blue,
                                    width: 1,
                                  ),
                                ),
                                hintText: "Pickup Date",
                                hintStyle: AppTextStyle(context).bodyTextSmal,
                                label: Text(
                                  "Pickup Date",
                                  style: AppTextStyle(context).bodyTextSmal,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(10.0.r),
                                  child: SvgPicture.asset(
                                    "assets/svgs/calendar.svg",
                                    height: 18.r,
                                  ),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                          AppSpacerW(10.w),
                          Expanded(
                            child: TextField(
                              onTap: () {
                                if (pickDateController.text.isNotEmpty) {
                                  pickDeliveryDate();
                                } else {
                                  EasyLoading.showError(
                                    "Please Select Pickup Date First",
                                  );
                                }
                              },
                              controller: deliveryDateController,
                              style: AppTextStyle(context).bodyTextSmal,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColor.blue,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColor.blue,
                                    width: 1,
                                  ),
                                ),
                                hintText: "Delivery Date",
                                hintStyle: AppTextStyle(context).bodyTextSmal,
                                label: Text(
                                  "Delivery Date",
                                  style: AppTextStyle(context).bodyTextSmal,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(10.0.r),
                                  child: SvgPicture.asset(
                                    "assets/svgs/calendar.svg",
                                    height: 18.r,
                                  ),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      AppSpacerH(16.h),
                    ],
                  ),
                ),
              ),
              AppSpacerH(8.h),
              // shipping Address
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).scaffoldBackgroundColor ==
                          AppColor.black
                      ? AppColor.black
                      : AppColor.white,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.offWhite,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacerH(16.h),
                      Text(
                        S.of(context).shpngadrs,
                        style: AppTextStyle(
                          context,
                        ).bodyTextSmal.copyWith(fontWeight: FontWeight.w700),
                      ),
                      AppSpacerH(16.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ref
                            .watch(addresListProvider)
                            .map(
                              initial: (_) {
                                return const LoadingWidget();
                              },
                              loading: (_) {
                                return const LoadingWidget();
                              },
                              loaded: (d) {
                                if (d.data.data!.addresses!.isNotEmpty) {
                                  addressid = d.data.data!.addresses!.first.id
                                      .toString();
                                  selectedAddressId = widget.address != null
                                      ? widget.address!.id.toString()
                                      : d.data.data!.addresses!.first.id
                                            .toString();
                                  return AddressContainer(
                                    ontap: () {
                                      context.nav.pushNamed(
                                        Routes.manageAddressScreen,
                                        arguments: false,
                                      );
                                    },
                                    change: true,
                                    buttonTitle: S.of(context).chng,
                                    address: widget.address != null
                                        ? widget.address!
                                        : d.data.data!.addresses!.first,
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40.w,
                                    ),
                                    child: SizedBox(
                                      height: 40.h,
                                      child: AppTextButton(
                                        onTap: () {
                                          context.nav.pushNamed(
                                            Routes.addAddressScreen,
                                          );
                                        },
                                        title: "Add Address",
                                      ),
                                    ),
                                  );
                                }
                              },
                              error: (e) => ErrorTextWidget(error: e.error),
                            ),
                      ),
                      AppSpacerH(16.h),
                    ],
                  ),
                ),
              ),
              AppSpacerH(8.h),
              // Coupon and Summary
              ValueListenableBuilder(
                valueListenable: Hive.box(AppHSC.cartBox).listenable(),
                builder: (BuildContext context, Box cartBox, Widget? child) {
                  // ref.watch(couponProvider);
                  // ref.watch(discountAmountProvider);
                  final List<CarItemHiveModel> cartItems = [];
                  for (var i = 0; i < cartBox.length; i++) {
                    final Map<String, dynamic> processedData = {};
                    final Map<dynamic, dynamic> unprocessedData =
                        cartBox.getAt(i) as Map<dynamic, dynamic>;

                    unprocessedData.forEach((key, value) {
                      processedData[key.toString()] = value;
                    });

                    cartItems.add(CarItemHiveModel.fromMap(processedData));
                  }
                  // start
                  // ref.watch(couponProvider).maybeWhen(
                  //       initial: () {
                  //         ref
                  //             .read(
                  //               couponProvider.notifier,
                  //             )
                  //             .applyCoupon(
                  //               coupon: coupon.text,
                  //               storeId: storeId,
                  //               amount: calculateTotal(
                  //                 cartItems,
                  //               ).toStringAsFixed(
                  //                 2,
                  //               ),
                  //             );
                  //       },
                  //       orElse: () {},
                  //       error: (_) {
                  //         print(_);
                  //         EasyLoading.showError("Invalid Coupon Code");
                  //         ref.refresh(couponProvider);
                  //       },
                  //       loaded: (_) {
                  //         if (_.data?.coupon?.discount != null) {
                  //           if (_.data!.coupon!.type!.toLowerCase() ==
                  //               "percent".toLowerCase()) {
                  //             final double subToatalAmount = calculateTotal(
                  //               cartItems,
                  //             );
                  //             Future.delayed(buildDuration).then((value) {
                  //               ref
                  //                       .watch(
                  //                         discountAmountProvider.notifier,
                  //                       )
                  //                       .state =
                  //                   subToatalAmount *
                  //                       (_.data!.coupon!.discount! / 100);
                  //             });
                  //           } else {
                  //             Future.delayed(buildDuration).then((value) {
                  //               ref
                  //                       .watch(
                  //                         discountAmountProvider.notifier,
                  //                       )
                  //                       .state =
                  //                   _.data!.coupon!.discount!.toDouble();
                  //             });
                  //           }
                  //         }
                  //       },
                  //     );
                  // end
                  total =
                      AppGFunctions.calculateTotal(cartItems) -
                      ref.watch(discountAmountProvider) +
                      deliver;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).scaffoldBackgroundColor ==
                              AppColor.black
                          ? AppColor.black
                          : AppColor.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpacerH(16.h),
                          // Coupon Code
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: AppColor.offWhite,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColor.blue,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.h,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgs/code_icon.svg",
                                          width: 24.w,
                                          height: 24.h,
                                          fit: BoxFit.cover,
                                        ),
                                        AppSpacerW(14.w),
                                        SizedBox(
                                          width: 162.w,
                                          height: 20.h,
                                          child: FormBuilderTextField(
                                            controller: coupon,
                                            name: "code",
                                            decoration:
                                                InputDecoration.collapsed(
                                                  hintText: S
                                                      .of(context)
                                                      .couponCode,
                                                  hintStyle:
                                                      AppTextStyle(
                                                        context,
                                                      ).bodyTextSmal.copyWith(
                                                        color: AppColor.gray,
                                                      ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AppSpacerW(10.w),
                              ref
                                  .watch(couponProvider)
                                  .map(
                                    initial: (_) {
                                      return PaymentContainer(
                                        ontap: () {
                                          ref
                                              .watch(couponProvider.notifier)
                                              .applyCoupon(
                                                coupon: coupon.text,
                                                storeId: storeId,
                                                amount: calculateTotal(
                                                  cartItems,
                                                ).toStringAsFixed(2),
                                              );
                                        },
                                        title: S.of(context).apply,
                                        width: 88.w,
                                        height: 48.h,
                                        radius: 8,
                                      );
                                    },
                                    loading: (_) {
                                      return SizedBox(
                                        height: 50.h,
                                        width: 70.w,
                                        child: const BusyLoader(),
                                      );
                                    },
                                    error: (e) {
                                      EasyLoading.showError(e.error);
                                      Future.delayed(50.milisec, () {
                                        ref.refresh(couponProvider);
                                      });
                                      return TextButton(
                                        onPressed: () {},
                                        child: const Text("Error"),
                                      );
                                    },
                                    loaded: (d) {
                                      if (d.data.data?.coupon?.discount !=
                                          null) {
                                        couponID = d.data.data?.coupon?.id;
                                        if (d.data.data?.coupon?.type!
                                                .toLowerCase() ==
                                            "percent".toLowerCase()) {
                                          final double subToatalAmount =
                                              calculateTotal(cartItems);
                                          Future.delayed(buildDuration).then((
                                            value,
                                          ) {
                                            ref.invalidate(couponProvider);
                                            ref
                                                    .watch(
                                                      discountAmountProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                subToatalAmount *
                                                (d
                                                        .data
                                                        .data!
                                                        .coupon!
                                                        .discount! /
                                                    100);
                                          });
                                        } else {
                                          Future.delayed(buildDuration).then((
                                            value,
                                          ) {
                                            ref
                                                .watch(
                                                  discountAmountProvider
                                                      .notifier,
                                                )
                                                .state = d
                                                .data
                                                .data!
                                                .coupon!
                                                .discount!
                                                .toDouble();
                                          });
                                        }
                                      }
                                      return PaymentContainer(
                                        ontap: () {
                                          Future.delayed(50.milisec, () {
                                            ref.refresh(couponProvider);
                                            ref.refresh(discountAmountProvider);
                                          });
                                        },
                                        title: 'Remove',
                                        textColor: AppColor.red,
                                        width: 88.w,
                                        height: 48.h,
                                        radius: 8,
                                      );
                                    },
                                  ),
                            ],
                          ),
                          AppSpacerH(46.h),
                          Text(
                            S.of(context).odrdsmry,
                            style: AppTextStyle(context).bodyTextSmal.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          AppSpacerH(8.h),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColor.offWhite,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.h,
                                vertical: 16.h,
                              ),
                              child: Column(
                                children: [
                                  SummaryContainer(
                                    type: S.of(context).sbttl,
                                    amount:
                                        "$currency ${AppGFunctions.calculateTotal(cartItems).toStringAsFixed(2)}",
                                  ),
                                  AppSpacerH(8.h),
                                  SummaryContainer(
                                    type: S.of(context).dscnt,
                                    amount:
                                        "$currency ${ref.watch(discountAmountProvider).toStringAsFixed(2)}",
                                    style: AppTextStyle(context).bodyTextSmal
                                        .copyWith(color: AppColor.red),
                                  ),
                                  AppSpacerH(8.h),
                                  const Divider(
                                    color: AppColor.gray,
                                    thickness: 1,
                                  ),
                                  AppSpacerH(8.h),
                                  SummaryContainer(
                                    type: S.of(context).ttl,
                                    amount:
                                        "$currency ${(AppGFunctions.calculateTotal(cartItems) - ref.watch(discountAmountProvider)).toStringAsFixed(2)}",
                                  ),
                                  AppSpacerH(8.h),
                                  SummaryContainer(
                                    type: S.of(context).dlvrychrg,
                                    amount: "$currency $deliver",
                                  ),
                                  AppSpacerH(8.h),
                                  const Divider(
                                    color: AppColor.gray,
                                    thickness: 1,
                                  ),
                                  AppSpacerH(8.h),
                                  SummaryContainer(
                                    style2: AppTextStyle(context).bodyTextSmal
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.black,
                                        ),
                                    type: S.of(context).pyblamnt,
                                    amount:
                                        "$currency ${(AppGFunctions.calculateTotal(cartItems) - ref.watch(discountAmountProvider) + deliver).toStringAsFixed(2)}",
                                    style: AppTextStyle(context).bodyTextSmal
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.black,
                                        ),
                                  ),
                                  AppSpacerH(12.h),
                                ],
                              ),
                            ),
                          ),
                          AppSpacerH(16.h),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: AppColor.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSpacerH(16.h),
                                  Text(
                                    S.of(context).pymntmthd,
                                    style: AppTextStyle(context).bodyTextSmal
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.black,
                                        ),
                                  ),
                                  AppSpacerH(8.h),
                                  PaymentMethodContainer(
                                    ontap: () {
                                      setState(() {
                                        selectedPaymentType = PaymentType.cod;
                                      });
                                    },
                                    icon: "assets/images/png/cod_icon.png",
                                    isselected:
                                        selectedPaymentType == PaymentType.cod,
                                    type: S.of(context).cshondlvry,
                                  ),
                                  // AppSpacerH(8.h),
                                  // PaymentMethodContainer(
                                  //   ontap: () {
                                  //     setState(() {
                                  //       selectedPaymentType =
                                  //           PaymentType.onlinePayment;
                                  //     });
                                  //   },
                                  //   icon:
                                  //       "assets/images/png/online_payment_icon.png",
                                  //   isselected: selectedPaymentType ==
                                  //       PaymentType.onlinePayment,
                                  //   type: S.of(context).payonlinewithcard,
                                  // ),
                                  AppSpacerH(16.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              AppSpacerH(140.h),
            ],
          ),
        ),
        Positioned(
          child: AppbarContainer(
            title: S.of(context).shpngndpymnt,
            ontap: () {
              context.nav.pop(context);
              ref.refresh(couponProvider);
              ref.refresh(discountAmountProvider);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.cartBox).listenable(),
            builder: (BuildContext context, Box cartBox, Widget? child) {
              final List<CarItemHiveModel> cartItems = [];
              for (var i = 0; i < cartBox.length; i++) {
                final Map<String, dynamic> processedData = {};
                final Map<dynamic, dynamic> unprocessedData =
                    cartBox.getAt(i) as Map<dynamic, dynamic>;

                unprocessedData.forEach((key, value) {
                  processedData[key.toString()] = value;
                });

                cartItems.add(CarItemHiveModel.fromMap(processedData));
              }
              final pickUp = ref.watch(scheduleProvider('Pick Up'));
              final delivery = ref.watch(scheduleProvider('Delivery'));
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 116.h,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).scaffoldBackgroundColor ==
                          AppColor.black
                      ? AppColor.black
                      : AppColor.white,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.offWhite,
                      offset: Offset(0, -1),
                      spreadRadius: 0,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: ref
                      .watch(placeOrdersProvider)
                      .map(
                        initial: (_) {
                          return Column(
                            children: [
                              AppSpacerH(18.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).pyblamnt,
                                    style: AppTextStyle(
                                      context,
                                    ).bodyTextExtraSmall,
                                  ),
                                  Text(
                                    "$currency ${(AppGFunctions.calculateTotal(cartItems) - ref.watch(discountAmountProvider) + deliver).toStringAsFixed(2)}",
                                    style: AppTextStyle(context)
                                        .bodyTextExtraSmall
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              AppSpacerH(10.h),
                              AppIconButton(
                                onTap: () async {
                                  /*
                                      Order Placement Data Validation and Logic Processed Here
                                      */
                                  final DateFormat formatter = DateFormat(
                                    'yyyy-MM-dd',
                                    'en_US',
                                  );
                                  final isOrderProcessing = ref.watch(
                                    orderProcessingProvider,
                                  );

                                  if (!isOrderProcessing) {
                                    ref
                                            .watch(
                                              orderProcessingProvider.notifier,
                                            )
                                            .state =
                                        true;
                                    // final pickUp = ref.watch(
                                    //   scheduleProvider('Pick Up'),
                                    // );
                                    // final delivery = ref.watch(
                                    //   scheduleProvider('Delivery'),
                                    // );

                                    //Cheks All Reguired Data Is AvailAble
                                    if (pickDateController.text.isNotEmpty &&
                                        deliveryDateController
                                            .text
                                            .isNotEmpty &&
                                        cartItems.isNotEmpty) {
                                      //Has All Data

                                      await ref
                                          .watch(placeOrdersProvider.notifier)
                                          .addOrder(
                                            OrderPlaceModel(
                                              store_id: storeId,
                                              address_id: widget.address != null
                                                  ? widget.address!.id
                                                        .toString()
                                                  : addressid!,
                                              pick_date: formatter.format(
                                                pickupDate!,
                                              ),
                                              // pick_hour: pickUp.schedule.hour
                                              //     .toString(),
                                              delivery_date: formatter.format(
                                                deliveryDate!,
                                              ),
                                              // delivery_hour: delivery
                                              //     .schedule.hour
                                              //     .toString(),
                                              coupon_id:
                                                  couponID?.toString() ?? '',
                                              payment_type:
                                                  selectedPaymentType ==
                                                      PaymentType.cod
                                                  ? "cash_on_delivery"
                                                  : "online_payment",
                                              products: cartItems
                                                  .map(
                                                    (e) => OrderProductModel(
                                                      id: e.productsId
                                                          .toString(),
                                                      quantity: e.productsQTY
                                                          .toString(),
                                                    ),
                                                  )
                                                  .toList(),
                                              additional_service_id: [],
                                            ),
                                          );
                                    } else {
                                      //Missing Data
                                      EasyLoading.showError(
                                        'Please Select All Fields',
                                      );
                                    }
                                    ref
                                            .watch(
                                              orderProcessingProvider.notifier,
                                            )
                                            .state =
                                        false;
                                  } else {
                                    EasyLoading.showError(
                                      'We are processing your Previous Request.\nPlease Wait',
                                    );
                                  }
                                },
                                title: S.of(context).ordrnow,
                                buttonColor: AppColor.blue,
                              ),
                            ],
                          );
                        },
                        loading: (_) => const LoadingWidget(),
                        loaded: (d) {
                          Future.delayed(buildDuration).then((value) async {
                            final double amount =
                                (calculateTotal(cartItems) -
                                ref.watch(discountAmountProvider));

                            final double totalAmount =
                                amount +
                                d.data.data!.order!.deliveryCharge!.toDouble();

                            // final ispaid = await PaymentLogic.makePayment(
                            //   amount: amount,
                            //   orderID: _.data.data!.order!.id.toString(),
                            //   couponID: couponID?.toString(),
                            //   ref: ref,
                            //   context: context,
                            // );

                            await cartBox.clear();
                            ref.refresh(placeOrdersProvider);
                            ref.refresh(couponProvider);
                            ref.refresh(discountAmountProvider);
                            ref.watch(dateProvider('Pick Up').notifier).state =
                                null;
                            ref.watch(dateProvider('Delivery').notifier).state =
                                null;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.h,
                                      vertical: 10.h,
                                    ),
                                    child: Center(
                                      child: Container(
                                        height:
                                            Hive.box(AppHSC.appSettingsBox)
                                                    .get(AppHSC.appLocal)
                                                    .toString() ==
                                                "ar"
                                            ? 480.h
                                            : 412.h,
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: AppColor.white,
                                        ),
                                        child: Column(
                                          children: [
                                            AppSpacerH(32.h),
                                            SvgPicture.asset(
                                              "assets/svgs/right_circular_icon.svg",
                                            ),
                                            AppSpacerH(20.h),
                                            Text(
                                              S.of(context).ordrplcdscsfly,
                                              style: AppTextStyle(context)
                                                  .bodyTextH1
                                                  .copyWith(
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.black,
                                                  ),
                                            ),
                                            AppSpacerH(32.h),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.h,
                                              ),
                                              child: Column(
                                                children: [
                                                  SummaryContainer(
                                                    type: S.of(context).ordrid,
                                                    amount:
                                                        "#${d.data.data!.order!.orderCode}",
                                                  ),
                                                  AppSpacerH(12.h),
                                                  SummaryContainer(
                                                    type: S
                                                        .of(context)
                                                        .pickupat,
                                                    amount:
                                                        d
                                                            .data
                                                            .data!
                                                            .order!
                                                            .pickDate ??
                                                        '',
                                                  ),
                                                  AppSpacerH(12.h),
                                                  SummaryContainer(
                                                    type: S.of(context).dlvryat,
                                                    amount:
                                                        d
                                                            .data
                                                            .data!
                                                            .order!
                                                            .deliveryDate ??
                                                        '',
                                                  ),
                                                  AppSpacerH(12.h),
                                                  SummaryContainer(
                                                    type: S
                                                        .of(context)
                                                        .pymntmthd,
                                                    amount: "Cash on Delivery",
                                                  ),
                                                  AppSpacerH(12.h),
                                                  SummaryContainer(
                                                    type: S.of(context).ttl,
                                                    amount:
                                                        "$currency ${(amount + d.data.data!.order!.deliveryCharge!.toDouble()).toStringAsFixed(2)}",
                                                  ),
                                                  AppSpacerH(32.h),
                                                  AppIconButton(
                                                    onTap: () {
                                                      ref.refresh(
                                                        couponProvider,
                                                      );
                                                      ref.refresh(
                                                        discountAmountProvider,
                                                      );
                                                      ref
                                                          .watch(
                                                            homeScreenIndexProvider
                                                                .notifier,
                                                          )
                                                          .update((state) => 0);
                                                      context.nav
                                                          .pushNamedAndRemoveUntil(
                                                            Routes
                                                                .bottomnavScreen,
                                                            (route) => false,
                                                          );
                                                    },
                                                    title: S
                                                        .of(context)
                                                        .gotohome,
                                                    buttonColor: AppColor.blue,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                          return null;
                        },
                        error: (e) {
                          Future.delayed(const Duration(seconds: 2)).then((
                            value,
                          ) {
                            ref.refresh(placeOrdersProvider);
                          });
                          return ErrorTextWidget(error: e.error);
                        },
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double calculateTotal(List<CarItemHiveModel> cartItems) {
    double amount = 0;
    for (final element in cartItems) {
      amount += element.productsQTY * element.unitPrice;
    }

    return amount;
  }
}

class AddressContainer extends StatelessWidget {
  const AddressContainer({
    super.key,
    this.ontap,
    this.buttonTitle,
    required this.change,
    required this.address,
  });
  final Function()? ontap;
  final String? buttonTitle;
  final bool change;
  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.offWhite, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacerH(16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColor.blue),
                    AppSpacerW(8.w),
                    if (address.addressName != null)
                      Container(
                        width: 37.w,
                        height: 16.h,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: AppColor.black,
                        ),
                        child: Center(
                          child: Text(
                            address.addressName.toString(),
                            style: AppTextStyle(context).bodyTextExtraSmall
                                .copyWith(
                                  color: AppColor.offWhite,
                                  fontSize: 10.sp,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (change)
                  PaymentContainer(
                    title: buttonTitle ?? S.of(context).chng,
                    ontap: ontap,
                  ),
              ],
            ),
            AppSpacerH(8.h),
            ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.userBox).listenable(),
              builder: (BuildContext context, Box userbox, Widget? child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 34.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userbox.get("name"),
                        style: AppTextStyle(context).bodyTextExtraSmall
                            .copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.gray,
                            ),
                      ),
                      AppSpacerH(4.h),
                      Text(
                        userbox.get("mobile"),
                        style: AppTextStyle(context).bodyTextExtraSmall
                            .copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.gray,
                            ),
                      ),
                      AppSpacerH(4.h),
                      // Text(
                      //   processAddess(),
                      //   style: AppTextDecor.regular12TextGray,
                      // ),
                      Wrap(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      address.houseNo != null ||
                                          address.houseNo != ''
                                      ? "House No: "
                                      : '',
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(color: AppColor.gray),
                                ),
                                TextSpan(
                                  text: address.houseNo ?? "",
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                ),
                                // for road no
                                TextSpan(
                                  text:
                                      address.roadNo != null ||
                                          address.roadNo != ''
                                      ? ", Road No: "
                                      : '',
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                ),
                                TextSpan(
                                  text: address.roadNo ?? "",
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                ),
                                // for block
                                TextSpan(
                                  text:
                                      address.block != null ||
                                          address.block != ''
                                      ? ", Block: "
                                      : '',
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                ),
                                TextSpan(
                                  text: address.block ?? "",
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.black,
                                      ),
                                ),
                                // for address line
                                TextSpan(
                                  text:
                                      address.addressLine != null ||
                                          address.addressLine != ''
                                      ? ", Address Line: "
                                      : '',
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                ),
                                TextSpan(
                                  text: address.addressLine ?? "",
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.black,
                                      ),
                                ),

                                // for area
                                TextSpan(
                                  text:
                                      address.area != null || address.area != ''
                                      ? ", Area: "
                                      : '',
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                ),
                                TextSpan(
                                  text: address.area ?? "",
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.black,
                                      ),
                                ),
                                // for post code
                                TextSpan(
                                  text:
                                      address.postCode != null ||
                                          address.postCode != ''
                                      ? ", Post Code: "
                                      : '',
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                ),
                                TextSpan(
                                  text: address.postCode ?? "",
                                  style: AppTextStyle(context)
                                      .bodyTextExtraSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            AppSpacerH(24.h),
          ],
        ),
      ),
    );
  }

  String processAddess() {
    String addres = '';
    if (address.houseNo != null) {
      addres = '$addres${address.houseNo}, ';
    }
    if (address.roadNo != null || address.roadNo != '') {
      addres = '$addres${address.roadNo}, ';
    }
    if (address.block != null) {
      addres = '$addres${address.block}, ';
    }
    if (address.addressLine != null) {
      addres = '$addres${address.addressLine}, ';
    }
    if (address.addressLine2 != null) {
      addres = '$addres${address.addressLine2}, ';
    }
    if (address.area != null) {
      addres = '$addres${address.area}, ';
    }
    if (address.postCode != null) {
      addres = '$addres${address.postCode}';
    }

    return addres;
  }
}

class PaymentMethodContainer extends StatelessWidget {
  const PaymentMethodContainer({
    super.key,
    required this.icon,
    required this.type,
    required this.isselected,
    this.ontap,
  });
  final String icon;
  final String type;
  final bool isselected;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.offWhite, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    icon,
                    width: 48.w,
                    height: 48.h,
                    fit: BoxFit.cover,
                  ),
                  AppSpacerW(8.w),
                  Text(
                    type,
                    style: AppTextStyle(
                      context,
                    ).bodyTextSmal.copyWith(color: AppColor.black),
                  ),
                ],
              ),
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isselected ? AppColor.blue : AppColor.gray,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: isselected ? AppColor.blue : AppColor.gray,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryContainer extends StatelessWidget {
  const SummaryContainer({
    super.key,
    required this.type,
    required this.amount,
    this.style,
    this.style2,
  });
  final String type;
  final String amount;
  final TextStyle? style;
  final TextStyle? style2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type,
          style:
              style2 ??
              AppTextStyle(context).bodyTextSmal.copyWith(color: AppColor.gray),
        ),
        Text(
          amount,
          style:
              style ??
              AppTextStyle(
                context,
              ).bodyTextSmal.copyWith(color: AppColor.black),
        ),
      ],
    );
  }
}

class PaymentContainer extends StatelessWidget {
  const PaymentContainer({
    super.key,
    this.width,
    this.height,
    required this.title,
    this.radius,
    this.ontap,
    this.textColor,
  });
  final double? width;
  final double? height;
  final double? radius;
  final String title;
  final Color? textColor;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width ?? 65.w,
        height: height ?? 28.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 14),
          border: Border.all(color: AppColor.blue, width: 1),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle(
              context,
            ).bodyTextExtraSmall.copyWith(color: textColor ?? AppColor.blue),
          ),
        ),
      ),
    );
  }
}

enum PaymentType { cod, onlinePayment }
