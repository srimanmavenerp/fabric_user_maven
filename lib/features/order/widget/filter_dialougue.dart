// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/misc_providers.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/constants/theme.dart';
import 'package:laundrymart/features/payment/logic/order_providers.dart';
import 'package:laundrymart/utils/entensions.dart';

class FilterDialog extends ConsumerStatefulWidget {
  const FilterDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog> {
  bool? completedChecked = false;
  bool? pendingChecked = false;
  bool? cancelledChecked = false;
  bool? deliveredChecked = false;
  String? status = "";
  @override
  Widget build(BuildContext context) {
    final isChecked = ref.watch(sortProvider);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.ph,
              Text(
                "Filter",
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              15.ph,
              GestureDetector(
                onTap: () {
                  setState(() {
                    ref.watch(sortProvider.notifier).update((state) => 1);
                    // confirmedChecked = !confirmedChecked!;
                    status = "order_confirmed";
                  });
                },
                child: SizedBox(
                  height: 35.h,
                  child: Row(
                    children: [
                      CustomRadioWidget(isSeleceted: isChecked == 1),
                      12.pw,
                      // Checkbox(
                      //   activeColor: AppColors.lightGreen,
                      //   value: confirmedChecked,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       confirmedChecked = value;
                      //     });
                      //   },
                      // ),
                      Expanded(
                        child: Text(
                          "Order Confirmed",
                          style: AppTextStyle(context)
                              .bodyTextSmal
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.watch(sortProvider.notifier).update((state) => 2);
                  status = "picked_order";
                },
                child: SizedBox(
                  height: 35.h,
                  child: Row(
                    children: [
                      CustomRadioWidget(isSeleceted: isChecked == 2),
                      12.pw,
                      // Checkbox(
                      //   activeColor: AppColors.lightGreen,
                      //   value: completedChecked,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       completedChecked = value;

                      //     });
                      //   },
                      // ),
                      Expanded(
                        child: Text(
                          "Picked Order",
                          style: AppTextStyle(context)
                              .bodyTextSmal
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.watch(sortProvider.notifier).update((state) => 3);
                  status = "pending";
                },
                child: SizedBox(
                  height: 35.h,
                  child: Row(
                    children: [
                      CustomRadioWidget(isSeleceted: isChecked == 3),
                      12.pw,
                      // Checkbox(
                      //   activeColor: AppColors.lightGreen,
                      //   value: pendingChecked,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       pendingChecked = value;

                      //     });
                      //   },
                      // ),
                      Expanded(
                        child: Text(
                          "Pending",
                          style: AppTextStyle(context)
                              .bodyTextSmal
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.watch(sortProvider.notifier).update((state) => 4);
                  status = "processing";
                },
                child: SizedBox(
                  height: 35.h,
                  child: Row(
                    children: [
                      CustomRadioWidget(isSeleceted: isChecked == 4),
                      12.pw,
                      // Checkbox(
                      //   activeColor: AppColors.lightGreen,
                      //   value: cancelledChecked,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       cancelledChecked = value;
                      //       status = value == true ? "processing" : "";
                      //     });
                      //   },
                      // ),
                      Expanded(
                        child: Text(
                          "Processing",
                          style: AppTextStyle(context)
                              .bodyTextSmal
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.watch(sortProvider.notifier).update((state) => 5);
                  status = "delivered";
                },
                child: SizedBox(
                  height: 35.h,
                  child: Row(
                    children: [
                      CustomRadioWidget(isSeleceted: isChecked == 5),
                      12.pw,
                      // Checkbox(
                      //   activeColor: AppColors.lightGreen,
                      //   value: deliveredChecked,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       deliveredChecked = value;
                      //       status = value == true ? "delivered" : "";
                      //     });
                      //   },
                      // ),
                      Expanded(
                        child: Text(
                          "Delivered",
                          style: AppTextStyle(context)
                              .bodyTextSmal
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              10.ph,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.nav.pop();
                        ref.watch(sortProvider.notifier).update((state) => 0);
                        ref
                            .watch(orderFilterProvider.notifier)
                            .update((state) => "");
                        ref.refresh(allOrdersProvider);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.05),
                      ),
                      child: Center(
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  10.pw,
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.nav.pop();
                        ref
                            .watch(orderFilterProvider.notifier)
                            .update((state) => status != "" ? status! : "");
                        ref.refresh(allOrdersProvider);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColor.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Apply",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Positioned(
            top: -20.h,
            right: -20.w,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: colors(context).bodyTextColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRadioWidget extends StatelessWidget {
  const CustomRadioWidget({
    super.key,
    required this.isSeleceted,
  });
  final bool isSeleceted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.h,
      width: 16.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.blue),
        borderRadius: BorderRadius.circular(8.h),
      ),
      padding: EdgeInsets.all(3.h),
      child: Container(
        decoration: BoxDecoration(
          color: isSeleceted ? AppColor.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8.h),
        ),
      ),
    );
  }
}
