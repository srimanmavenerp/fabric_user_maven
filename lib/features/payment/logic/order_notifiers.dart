import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundrymart/features/constants/hive_contants.dart';
import 'package:laundrymart/features/payment/logic/order_repo.dart';
import 'package:laundrymart/features/payment/model/add_order_model/add_order_model.dart';
import 'package:laundrymart/features/payment/model/all_order_model/all_order_model.dart';
import 'package:laundrymart/features/payment/model/coupon_response_model/coupon_response_model.dart';
import 'package:laundrymart/features/payment/model/order_details_model/order_details_model.dart';
import 'package:laundrymart/features/payment/model/order_place_model/order_place_model.dart';
import 'package:laundrymart/services/api_state.dart';
import 'package:laundrymart/services/network_exceptions.dart';

import '../model/schedules_model/schedules_model.dart';

class AllOrdersNotifier extends StateNotifier<ApiState<AllOrderModel>> {
  AllOrdersNotifier(this._repo, this._filter)
      : super(const ApiState.initial()) {
    getAllOrders();
  }
  final IOrderRepo _repo;
  final String _filter;
  Future<void> getAllOrders() async {
    state = const ApiState.loading();
    // try {
    state = ApiState.loaded(data: await _repo.getAllOrders(_filter));
    // } catch (e) {
    //   state = ApiState.error(error: NetworkExceptions.errorText(e));
    // }
  }
}

class OrderDetailsNotifier extends StateNotifier<ApiState<OrderDetailsModel>> {
  OrderDetailsNotifier(this._repo, this._id) : super(const ApiState.initial()) {
    getOrderDetails();
  }
  final IOrderRepo _repo;
  final String _id;
  Future<void> getOrderDetails() async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(data: await _repo.getOrderDetails(_id));
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class PickUpScheduleNotifier extends StateNotifier<ApiState<SchedulesModel>> {
  PickUpScheduleNotifier(this._repo, this._date)
      : super(const ApiState.initial()) {
    getPickUpSchedules();
  }
  final IOrderRepo _repo;
  final DateTime _date;
  Future<void> getPickUpSchedules() async {
    String storeId = Hive.box(AppHSC.appSettingsBox).get("storeid");
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
          data: await _repo.getPickUpSchedules(storeId.toString(), _date));
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class DeliveryScheduleNotifier extends StateNotifier<ApiState<SchedulesModel>> {
  DeliveryScheduleNotifier(this._repo, this._date)
      : super(const ApiState.initial()) {
    getDeliverySchedules();
  }
  final IOrderRepo _repo;
  final DateTime _date;
  Future<void> getDeliverySchedules() async {
    String storeId = Hive.box(AppHSC.appSettingsBox).get("storeid");
    if (!mounted) return;
    state = const ApiState.loading();
    try {
      if (!mounted) return;
      state = ApiState.loaded(
          data: await _repo.getDeliverySchedules(storeId, _date));
    } catch (e) {
      if (!mounted) return;
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class CouponNotifier extends StateNotifier<ApiState<CouponResponseModel>> {
  CouponNotifier(this._repo) : super(const ApiState.initial());
  final IOrderRepo _repo;

  Future<void> applyCoupon({
    required String coupon,
    required String amount,
    required String storeId,
  }) async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(
        data: await _repo.applyCoupon(
            coupon: coupon, amount: amount, storeId: storeId),
      );
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class PlaceOrderNotifier extends StateNotifier<ApiState<AddOrderModel>> {
  PlaceOrderNotifier(
    this._repo,
  ) : super(const ApiState.initial());
  final IOrderRepo _repo;

  Future<void> addOrder(OrderPlaceModel orderPlaceModel) async {
    state = const ApiState.loading();
    try {
      state = ApiState.loaded(data: await _repo.addOrder(orderPlaceModel));
    } catch (e) {
      debugPrint(e.toString());
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}

class OrderCancelNotifier extends StateNotifier<bool> {
  final IOrderRepo _repo;
  OrderCancelNotifier(this._repo) : super(false);

  Future<String> cancelOrder(int? orderId) async {
    state = true;

    try {
      final message = await _repo.cancelOrder(orderId);
      state = false;
      return message;
    } catch (error) {
      state = false;
      return error.toString();
    }
  }
}

class OrderReviewNotifier extends StateNotifier<bool> {
  final IOrderRepo _repo;
  OrderReviewNotifier(this._repo) : super(false);

  Future<String> addOrderReview(
      {required double rating,
      required String? comment,
      required int? orderId}) async {
    state = true;

    try {
      final message = await _repo.addOrderReview(
          rating: rating, comment: comment, orderId: orderId);
      state = false;
      return message;
    } catch (error) {
      state = false;
      return error.toString();
    }
  }
}
