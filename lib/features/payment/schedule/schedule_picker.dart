import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:laundrymart/features/constants/app_string_const.dart';
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

import '../../misc/misc_providers.dart';

class SchedulerPicker extends ConsumerStatefulWidget {
  const SchedulerPicker({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SchedulerPickerState();
}

class _SchedulerPickerState extends ConsumerState<SchedulerPicker> {
  @override
  Widget build(BuildContext context) {
    final dateSelect = ref.watch(dateProvider(AppStrConst.pickup));

    if (dateSelect == null) {
      if (DateTime.now().weekday == DateTime.sunday) {
        Future.delayed(buildDuration).then((value) {
          ref.watch(dateProvider(AppStrConst.pickup).notifier).state =
              DateTime.now().add(const Duration(days: 1));
        });
      } else {
        Future.delayed(buildDuration).then((value) {
          ref.watch(dateProvider(AppStrConst.pickup).notifier).state =
              DateTime.now();
        });
      }
    }
    ref.watch(pickUpScheduleProvider);
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 812.h,
        width: 375.w,
        color: AppColor.green,
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
                        '${AppStrConst.pickup == "Pick Up" ? S.of(context).pckup : ""} ${S.of(context).schdl}',
                    onBack: () {
                      context.nav.pop();
                    },
                  ),
                  TableCalendar(
                    rowHeight: 50.h,
                    currentDay: DateTime.now(),
                    firstDay: DateTime.now(),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: dateSelect ?? DateTime.now(),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      if ((!selectDay.isBefore(DateTime.now()) ||
                          isSameDay(selectDay, DateTime.now()))
                      //     &&
                      // selectDay.weekday != DateTime.sunday
                      ) {
                        ref
                                .watch(
                                  dateProvider(AppStrConst.pickup).notifier,
                                )
                                .state =
                            selectDay;
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
                  .watch(pickUpScheduleProvider)
                  .map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => const LoadingWidget(),
                    loaded: (d) {
                      final List<Schedule> schedules = d.data.data!.schedules!;

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
                                        AppStrConst.pickup,
                                      ).notifier,
                                    )
                                    .state = ScheduleModel(
                                  schedule: e,
                                  dateTime: dateSelect!,
                                );

                                ref
                                        .watch(
                                          dateProvider('Delivery').notifier,
                                        )
                                        .state =
                                    null;
                                ref
                                        .watch(
                                          scheduleProvider('Delivery').notifier,
                                        )
                                        .state =
                                    null;

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
