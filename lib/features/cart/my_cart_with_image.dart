import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/services/model/hive_cart_item_model.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/generated/l10n.dart';

class MyCartWithImage extends ConsumerStatefulWidget {
  const MyCartWithImage({super.key, required this.carItemHiveModel});
  final CarItemHiveModel carItemHiveModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyCartWithImageState();
}

class _MyCartWithImageState extends ConsumerState<MyCartWithImage> {
  bool inCart = false;
  final Box settingsBox = Hive.box(AppHSC.appSettingsBox);
  final Box cartsBox = Hive.box(AppHSC.cartBox);

  int? keyAt;

  @override
  void initState() {
    checkProduct();
    super.initState();
  }

  void checkProduct() {
    for (int i = 0; i < cartsBox.length; i++) {
      final Map<String, dynamic> processedData = {};
      final Map<dynamic, dynamic> unprocessedData =
          cartsBox.getAt(i) as Map<dynamic, dynamic>;

      unprocessedData.forEach((key, value) {
        processedData[key.toString()] = value;
      });

      final data = CarItemHiveModel.fromMap(processedData);
      if (data.productsId == widget.carItemHiveModel.productsId) {
        inCart = true;
        keyAt = i;
        break;
      }
    }
    setState(() {
      keyAt = keyAt; // just for Updating
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currency = ref
        .read(appSettingDataProvider.notifier)
        .state
        .currency;
    return ValueListenableBuilder(
      valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
      builder: (BuildContext context, Box appSettingsBox, Widget? child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.gray.withOpacity(0.3), width: 1),
            color: AppColor.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.carItemHiveModel.productsImage,
                        width: 56.w,
                        height: 56.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    AppSpacerW(8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 170.w,
                          child: Text(
                            widget.carItemHiveModel.serviceName,
                            style: AppTextStyle(context).bodyTextExtraSmall
                                .copyWith(
                                  fontSize: 10.sp,
                                  color: AppColor.gray,
                                ),
                          ),
                        ),
                        Text(
                          widget.carItemHiveModel.productsName,
                          style: AppTextStyle(context).bodyTextSmal.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.black,
                          ),
                        ),
                        Text(
                          "$currency ${widget.carItemHiveModel.unitPrice} /${S.of(context).item}",
                          style: AppTextStyle(context).bodyTextSmal.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSpacerH(24.h),
                    ValueListenableBuilder(
                      valueListenable: Hive.box(AppHSC.cartBox).listenable(),
                      builder: (context, Box cartbox, Widget? child) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (widget.carItemHiveModel.productsQTY <= 1) {
                                  cartbox.deleteAt(keyAt!);

                                  inCart = false;
                                  checkProduct();
                                } else {
                                  cartbox.putAt(
                                    keyAt!,
                                    widget.carItemHiveModel
                                        .copyWith(
                                          productsQTY:
                                              widget
                                                  .carItemHiveModel
                                                  .productsQTY -
                                              1,
                                        )
                                        .toMap(),
                                  );
                                }
                              },
                              child: Container(
                                width: 28.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: AppColor.offWhite,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                  child: Icon(Icons.remove, size: 24),
                                ),
                              ),
                            ),
                            AppSpacerW(8.w),
                            Text(
                              widget.carItemHiveModel.productsQTY.toString(),
                              style: AppTextStyle(context).bodyText.copyWith(
                                color: AppColor.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AppSpacerW(8.w),
                            GestureDetector(
                              onTap: () {
                                cartbox.putAt(
                                  keyAt!,
                                  widget.carItemHiveModel
                                      .copyWith(
                                        productsQTY:
                                            widget
                                                .carItemHiveModel
                                                .productsQTY +
                                            1,
                                      )
                                      .toMap(),
                                );
                              },
                              child: Container(
                                width: 28.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: AppColor.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
