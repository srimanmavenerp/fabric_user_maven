import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/color.dart';
import 'package:laundrymart/features/misc/misc_global_variables.dart';
import 'package:laundrymart/features/others/widgets/app_nav_bar.dart';
import 'package:laundrymart/features/payment/logic/order_providers.dart';
import 'package:laundrymart/features/payment/model/schedule_model.dart';
import 'package:laundrymart/features/payment/model/schedules_model/schedule.dart';
import 'package:laundrymart/features/widgets/misc_widgets.dart';
import 'package:laundrymart/features/widgets/screen_wrapper.dart';
import 'package:laundrymart/generated/l10n.dart';
import 'package:laundrymart/utils/context_less_nav.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/app_string_const.dart';
import '../../misc/misc_providers.dart';

class DeliverySchedulerPicker extends ConsumerStatefulWidget {
  const DeliverySchedulerPicker({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliverySchedulerPickerState();
}

class _DeliverySchedulerPickerState
    extends ConsumerState<DeliverySchedulerPicker> {
  @override
  Widget build(BuildContext context) {
    final dateSelect = ref.watch(dateProvider(AppStrConst.delivery));
    final ScheduleModel? pickSchedule = ref.watch(
      scheduleProvider(AppStrConst.pickup),
    );

    if (pickSchedule != null && dateSelect == null) {
      Future.delayed(buildDuration).then((value) {
        final autoDate = pickSchedule.dateTime.add(const Duration(days: 1));

        if (autoDate.weekday == DateTime.sunday) {
          ref.watch(dateProvider(AppStrConst.delivery).notifier).state =
              autoDate.add(const Duration(days: 1));
        } else {
          ref.watch(dateProvider(AppStrConst.delivery).notifier).state =
              autoDate;
        }
      });
    }

    ref.watch(deliveryScheduleProvider);
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColor.gray,
        child: Column(
          children: [
            Container(
              color: AppColor.white,
              width: 375.w,
              child: Column(
                children: [
                  AppSpacerH(44.h),
                  AppNavbar(
                    title:
                        '${AppStrConst.delivery == "Delivery" ? S.of(context).dlvry : ""} ${S.of(context).schdl}',
                    onBack: () {
                      context.nav.pop();
                    },
                  ),
                  TableCalendar(
                    rowHeight: 50.h,
                    firstDay: DateTime.now(),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: dateSelect ?? DateTime.now(),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      if (!selectDay.isBefore(DateTime.now()) ||
                          isSameDay(selectDay, DateTime.now())
                      //     &&
                      // selectDay.weekday != DateTime.sunday
                      ) {
                        if (pickSchedule != null) {
                          if (!selectDay.isBefore(pickSchedule.dateTime) &&
                              !isSameDay(selectDay, pickSchedule.dateTime)) {
                            ref
                                    .watch(
                                      dateProvider(
                                        AppStrConst.delivery,
                                      ).notifier,
                                    )
                                    .state =
                                selectDay;
                          }
                        } else {
                          EasyLoading.showError(
                            S.of(context).plsslctpckupschdl,
                          );
                        }
                      }
                      // else if (selectDay.weekday == DateTime.sunday) {
                      //   EasyLoading.showError(S.of(context).noslctavlbl);
                      // }
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(dateSelect, date);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ref
                  .watch(deliveryScheduleProvider)
                  .map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => const LoadingWidget(),
                    loaded: (d) {
                      List<Schedule> schedules = d.data.data!.schedules!;

                      final ScheduleModel? pickSchedule = ref.watch(
                        scheduleProvider('Pick Up'),
                      );
                      if (pickSchedule != null &&
                          isSameDay(
                            dateSelect,
                            pickSchedule.dateTime.add(const Duration(days: 1)),
                          )) {
                        final List<Schedule> temp = [];
                        for (final element in d.data.data!.schedules!) {
                          if (int.parse(element.hour!.split('-').first) >=
                              int.parse(
                                pickSchedule.schedule.hour!.split('-').first,
                              )) {
                            temp.add(element);
                          }
                        }
                        schedules = temp;
                      }
                      return GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.9,
                        children: [
                          ...schedules.map(
                            (e) => GestureDetector(
                              onTap: () {
                                ref
                                    .watch(
                                      scheduleProvider(
                                        AppStrConst.delivery,
                                      ).notifier,
                                    )
                                    .state = ScheduleModel(
                                  schedule: e,
                                  dateTime: dateSelect!,
                                );

                                context.nav.pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  padding: EdgeInsets.all(5.h),
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(5.h),
                                  ),
                                  child: Center(child: Text(e.title ?? '')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (e) => ErrorTextWidget(error: e.error),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
