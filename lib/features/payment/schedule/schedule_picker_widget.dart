import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:laundrymart/features/constants/app_string_const.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/constants/text_style.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/payment/model/schedule_model.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:laundrymart/utils/routes.dart';

class ShedulePicker extends ConsumerStatefulWidget {
  const ShedulePicker({
    super.key,
    required this.image,
    required this.title,
  });
  final String image;
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShedulePickerState();
}

class _ShedulePickerState extends ConsumerState<ShedulePicker>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    String modifiedtitle = "";
    if (widget.title == AppStrConst.pickup ||
        widget.title == S.of(context).pickupat) {
      modifiedtitle = AppStrConst.pickup;
    } else {
      modifiedtitle = AppStrConst.delivery;
    }
    final ScheduleModel? data = ref.watch(
      scheduleProvider(modifiedtitle),
    );
    return GestureDetector(
      onTap: () {
        if (widget.title == AppStrConst.pickup ||
            widget.title == S.of(context).pickupat) {
          context.nav.pushNamed(Routes.schedulePickerScreen);
        } else {
          context.nav.pushNamed(Routes.deilverySchedulePickerScreen);
        }
      },
      child: Container(
        padding: EdgeInsets.all(5.h),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10.h),
          border: Border.all(color: AppColor.blue),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  widget.image,
                  height: 30.h,
                  width: 30.w,
                ),
                AppSpacerW(5.w),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.title,
                        style: AppTextStyle(context).bodyTextSmal.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                      ),
                      TextSpan(
                        text: ' *',
                        style:
                            AppTextStyle(context).bodyTextExtraSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.red,
                                ),
                      )
                    ],
                  ),
                )
              ],
            ),
            AppSpacerH(10.h),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined),
                AppSpacerW(5.w),
                Expanded(
                  child: FittedBox(
                    child: Text(
                      data != null
                          ? DateFormat('MMMM d, yyyy').format(data.dateTime)
                          : S.of(context).unslctd,
                    ),
                  ),
                )
              ],
            ),
            AppSpacerH(10.h),
            Row(
              children: [
                const Icon(Icons.schedule_outlined),
                AppSpacerW(5.w),
                Text(
                  data != null ? data.schedule.title! : S.of(context).unslctd,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
