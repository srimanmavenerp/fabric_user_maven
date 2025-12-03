import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/cart/my_cart_with_image.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/misc/global_functions.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/order/my_order_sceen.dart';
import 'package:laundrymart/features/services/model/hive_cart_item_model.dart';
import 'package:laundrymart/features/store/logic/store_providers.dart';
import 'package:laundrymart/features/widgets/icon_button2.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class MyCartScreen extends ConsumerStatefulWidget {
  const MyCartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends ConsumerState<MyCartScreen> {
  final Box appSettingsBox = Hive.box(AppHSC.appSettingsBox);
  double? deliver;
  double? minamount;
  double? maxamount;
  @override
  Widget build(BuildContext context) {
    final String currency = ref
        .read(appSettingDataProvider.notifier)
        .state
        .currency;
    String? storeId = Hive.box(AppHSC.appSettingsBox).get("storeid");
    if (storeId != null) {
      ref
          .watch(orderOptionsProvider(storeId))
          .maybeWhen(
            loaded: (d) {
              deliver = double.parse(d.data!.deliveryCharge!);
              minamount = double.parse(d.data!.minOrderAmount!);
              maxamount = double.parse(d.data!.maxOrderAmount!);
            },
            orElse: () {},
          );
    }

    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.authBox).listenable(),
      builder: (BuildContext context, Box authbox, Widget? child) {
        return ValueListenableBuilder(
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
              debugPrint(
                "calculate total ${AppGFunctions.calculateTotal(cartItems).toStringAsFixed(2)}",
              );
            }

            return Stack(
              children: [
                ScreenWrapper(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      AppbarContainer(
                        title: S.of(context).myCart,
                        ontap: () {
                          context.nav.pop(context);
                        },
                      ),
                      if (authbox.get(AppHSC.authToken) != null) ...[
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: cartItems.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    addAutomaticKeepAlives: true,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: cartItems.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.h,
                                        ),
                                        child: MyCartWithImage(
                                          carItemHiveModel: cartItems[index],
                                        ),
                                      );
                                    },
                                  )
                                : MessageTextWidget(
                                    msg: S.of(context).noitmcrt,
                                  ),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: const NotSignedInwidget(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (authbox.get(AppHSC.authToken) != null)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          // color: AppColor.offWhite,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.offWhite.withOpacity(0.1),
                            offset: const Offset(0, -6),
                            spreadRadius: 0,
                            blurRadius: 16,
                          ),
                        ],
                        color:
                            Theme.of(context).scaffoldBackgroundColor ==
                                AppColor.black
                            ? AppColor.black
                            : AppColor.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 16.h,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (cartBox.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      // showModalBottomSheet(
                                      //     backgroundColor: Colors.transparent,
                                      //     context: context,
                                      //     builder: (context) {
                                      //       return Container(
                                      //         width: double.infinity,
                                      //         height: 240.h,
                                      //         decoration: const BoxDecoration(
                                      //             borderRadius: BorderRadius.only(
                                      //                 topLeft: Radius.circular(12),
                                      //                 topRight: Radius.circular(12)),
                                      //             color: AppColors.white),
                                      //         child: Padding(
                                      //           padding: EdgeInsets.symmetric(
                                      //               horizontal: 16.h, vertical: 16.h),
                                      //           child: Column(
                                      //             children: [
                                      //               Row(
                                      //                 mainAxisAlignment:
                                      //                     MainAxisAlignment.spaceBetween,
                                      //                 children: [
                                      //                   Text(
                                      //                     S.of(context).pricingbrkdwn,
                                      //                     style: AppTextDecor
                                      //                         .bold12PrimaryBlue
                                      //                         .copyWith(
                                      //                             fontSize: 14,
                                      //                             color: AppColors.black),
                                      //                   ),
                                      //                   GestureDetector(
                                      //                       onTap: () {
                                      //                         context.nav.pop();
                                      //                       },
                                      //                       child: const Icon(Icons.close)),
                                      //                 ],
                                      //               ),
                                      //               AppSpacerH(20.h),
                                      //               SizedBox(
                                      //                 width:
                                      //                     MediaQuery.of(context).size.width,
                                      //                 height: 90.h,
                                      //                 child: ListView.builder(
                                      //                   shrinkWrap: true,
                                      //                   itemCount: 3,
                                      //                   itemBuilder: (context, index) {
                                      //                     return Padding(
                                      //                       padding: EdgeInsets.only(
                                      //                           bottom: 10.h),
                                      //                       child: const PriceRow(),
                                      //                     );
                                      //                   },
                                      //                 ),
                                      //               ),
                                      //               const Divider(
                                      //                 color: AppColors.dividergray,
                                      //               ),
                                      //               AppSpacerH(8.h),
                                      //               Row(
                                      //                 mainAxisAlignment:
                                      //                     MainAxisAlignment.spaceBetween,
                                      //                 children: [
                                      //                   Text(
                                      //                     S.of(context).ttl,
                                      //                     style: AppTextDecor
                                      //                         .bold12PrimaryBlue
                                      //                         .copyWith(
                                      //                             fontSize: 14,
                                      //                             color:
                                      //                                 AppColors.lightBlack),
                                      //                   ),
                                      //                   Text(
                                      //                     "৳120.00",
                                      //                     style: AppTextDecor
                                      //                         .bold12PrimaryBlue
                                      //                         .copyWith(
                                      //                             fontSize: 14,
                                      //                             color: AppColors.black),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       );
                                      //     });
                                    },
                                    child: Container(
                                      color:
                                          Theme.of(
                                                context,
                                              ).scaffoldBackgroundColor ==
                                              AppColor.black
                                          ? AppColor.black
                                          : AppColor.offWhite,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 5.h,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$currency ${AppGFunctions.calculateTotal(cartItems).toStringAsFixed(2)}",
                                            style: AppTextStyle(context)
                                                .bodyText
                                                .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          if (cartBox.isNotEmpty)
                                            Text(
                                              "${S.of(context).dlvrychrg}:\n$currency $deliver",
                                              style: AppTextStyle(context)
                                                  .bodyTextExtraSmall
                                                  .copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (cartItems.isNotEmpty)
                                  Column(
                                    children: [
                                      minamount != 0.0
                                          ? Text(
                                              "Minimum order amount $currency$minamount",
                                              style: AppTextStyle(context)
                                                  .bodyTextExtraSmall
                                                  .copyWith(
                                                    color: AppColor.red,
                                                  ),
                                            )
                                          : const SizedBox(),
                                      AppSpacerH(4.h),
                                      SizedBox(
                                        width: 196.w,
                                        height: 48.h,
                                        child: AppIconButton2(
                                          onTap: () {
                                            if (AppGFunctions.calculateTotal(
                                                  cartItems,
                                                ) >=
                                                minamount!) {
                                              context.nav.pushNamed(
                                                Routes.shippingPaymentScreen,
                                              );
                                            } else {
                                              EasyLoading.showError(
                                                "Minimum Order Amount is $currency$minamount",
                                              );
                                            }
                                          },
                                          title: S.of(context).chckout,
                                          buttonColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                // else
                                //   Text(
                                //     "Please Add Items in Your Cart",
                                //     style:
                                //         AppTextDecor.regular12LightGreen,
                                //   )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class AppbarContainer extends StatelessWidget {
  const AppbarContainer({super.key, required this.title, this.ontap});
  final String title;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.h,
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(color: AppColor.offWhite, width: 1),
        ),
        color: Theme.of(context).scaffoldBackgroundColor == AppColor.black
            ? AppColor.black
            : AppColor.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          children: [
            AppSpacerH(40.h),
            Row(
              children: [
                IconButton(
                  onPressed: ontap,
                  icon: Icon(
                    Icons.arrow_back,
                    color: colors(context).bodyTextColor,
                  ),
                ),
                // GestureDetector(
                //   onTap: ontap,
                //   child: Hive.box(AppHSC.appSettingsBox)
                //               .get(AppHSC.appLocal)
                //               .toString() ==
                //           "ar"
                //       ? RotatedBox(
                //           quarterTurns: 2,
                //           child: SvgPicture.asset(
                //             "assets/svgs/back_arrow_icon.svg",
                //             fit: BoxFit.cover,
                //             color: colors(context).bodyTextColor,
                //           ),
                //         )
                //       : SvgPicture.asset(
                //           "assets/svgs/back_arrow_icon.svg",
                //           fit: BoxFit.cover,
                //           color: colors(context).bodyTextColor,
                //         ),
                // ),
                AppSpacerW(39.w),
                Text(
                  title,
                  style: AppTextStyle(
                    context,
                  ).bodyText.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
