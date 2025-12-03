import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundrymart/features/constants/app_string_const.dart';
import 'package:laundrymart/features/misc/misc_providers.dart';
import 'package:laundrymart/features/payment/logic/order_notifiers.dart';
import 'package:laundrymart/features/payment/logic/order_repo.dart';
import 'package:laundrymart/features/payment/model/add_order_model/add_order_model.dart';
import 'package:laundrymart/features/payment/model/all_order_model/all_order_model.dart';
import 'package:laundrymart/features/payment/model/coupon_response_model/coupon_response_model.dart';
import 'package:laundrymart/features/payment/model/order_details_model/order_details_model.dart';

import '../../../services/api_state.dart';
import '../model/schedules_model/schedules_model.dart';

final orderRepoProvider = Provider<IOrderRepo>((ref) {
  return OrderRepo();
});
final orderFilterProvider = StateProvider<String>((ref) {
  return '';
});

final allOrdersProvider = StateNotifierProvider.autoDispose<AllOrdersNotifier,
    ApiState<AllOrderModel>>((ref) {
  return AllOrdersNotifier(
    ref.watch(orderRepoProvider),
    ref.watch(orderFilterProvider),
  );
});

final placeOrdersProvider = StateNotifierProvider.autoDispose<
    PlaceOrderNotifier, ApiState<AddOrderModel>>((ref) {
  return PlaceOrderNotifier(
    ref.watch(orderRepoProvider),
  );
});
final orderDetailsProvider = StateNotifierProvider.autoDispose
    .family<OrderDetailsNotifier, ApiState<OrderDetailsModel>, String>(
        (ref, id) {
  return OrderDetailsNotifier(
    ref.watch(orderRepoProvider),
    id,
  );
});

final cancelOrderProvider = StateNotifierProvider<OrderCancelNotifier, bool>(
  (ref) => OrderCancelNotifier(
    ref.watch(orderRepoProvider),
  ),
);
final orderReviewProvider = StateNotifierProvider<OrderReviewNotifier, bool>(
  (ref) => OrderReviewNotifier(
    ref.watch(orderRepoProvider),
  ),
);
final pickUpScheduleProvider = StateNotifierProvider.autoDispose<
    PickUpScheduleNotifier, ApiState<SchedulesModel>>((ref) {
  final DateTime date =
      ref.watch(dateProvider(AppStrConst.pickup)) ?? DateTime.now();
  // int storeId = ref.watch(storeIdProvider);
  return PickUpScheduleNotifier(ref.watch(orderRepoProvider), date);
});

final deliveryScheduleProvider = StateNotifierProvider.autoDispose<
    DeliveryScheduleNotifier, ApiState<SchedulesModel>>((ref) {
  final DateTime date =
      ref.watch(dateProvider(AppStrConst.delivery)) ?? DateTime.now();

  return DeliveryScheduleNotifier(ref.watch(orderRepoProvider), date);
});
final couponProvider =
    StateNotifierProvider<CouponNotifier, ApiState<CouponResponseModel>>((ref) {
  return CouponNotifier(
    ref.watch(orderRepoProvider),
  );
});
final discountAmountProvider = StateProvider<double>((ref) {
  return 0;
});
