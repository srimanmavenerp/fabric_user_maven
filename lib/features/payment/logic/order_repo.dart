import 'package:dio/dio.dart';
import 'package:laundrymart/features/payment/model/add_order_model/add_order_model.dart';
import 'package:laundrymart/features/payment/model/all_order_model/all_order_model.dart';
import 'package:laundrymart/features/payment/model/coupon_response_model/coupon_response_model.dart';
import 'package:laundrymart/features/payment/model/order_details_model/order_details_model.dart';
import 'package:laundrymart/features/payment/model/order_place_model/order_place_model.dart';
import 'package:laundrymart/features/payment/model/schedules_model/schedules_model.dart';
import 'package:laundrymart/services/api_service.dart';

abstract class IOrderRepo {
  Future<AllOrderModel> getAllOrders(String status);
  Future<AddOrderModel> addOrder(OrderPlaceModel orderPlaceModel);
  Future<SchedulesModel> getPickUpSchedules(String storeId, DateTime date);
  Future<SchedulesModel> getDeliverySchedules(String storeid, DateTime date);
  Future<CouponResponseModel> applyCoupon({
    required String coupon,
    required String amount,
    required String storeId,
  });
  Future<OrderDetailsModel> getOrderDetails(String id);
  Future<String> cancelOrder(int? orderId);
  Future<String> addOrderReview({
    required double rating,
    required String? comment,
    required int? orderId,
  });
}

class OrderRepo implements IOrderRepo {
  final Dio _dio = getDio();
  @override
  Future<AllOrderModel> getAllOrders(String status) async {
    Map<String, dynamic> qp = {};

    if (status != '') {
      qp = {'status': status};
    }
    final Response response = await _dio.get('/orders', queryParameters: qp);
    return AllOrderModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<AddOrderModel> addOrder(OrderPlaceModel orderPlaceModel) async {
    final response = await _dio.post(
      '/orders',
      data: FormData.fromMap(orderPlaceModel.toMap()),
    );
    return AddOrderModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<OrderDetailsModel> getOrderDetails(String id) async {
    final Response response = await _dio.get(
      '/orders/$id/details',
    );
    return OrderDetailsModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> cancelOrder(int? orderId) async {
    final Response response = await _dio.post(
      '/orders/$orderId/cancle',
    );
    final String message = response.data['message'];
    return message;
  }

  @override
  Future<SchedulesModel> getPickUpSchedules(
      String storeId, DateTime date) async {
    final data = "${date.year}-${date.month}-${date.day}";

    final Response response = await _dio.get(
      '/pick-schedules/$storeId/$data',
    );
    return SchedulesModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<SchedulesModel> getDeliverySchedules(
      String storeId, DateTime date) async {
    final data = "${date.year}-${date.month}-${date.day}";
    final Response response = await _dio.get(
      '/delivery-schedules/$storeId/$data',
    );
    return SchedulesModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<CouponResponseModel> applyCoupon({
    required String coupon,
    required String amount,
    required String storeId,
  }) async {
    final response = await _dio.post(
      '/coupons/$coupon/apply',
      data: FormData.fromMap({'amount': amount, 'store_id': storeId}),
    );
    return CouponResponseModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> addOrderReview({
    required double rating,
    required String? comment,
    required int? orderId,
  }) async {
    final response = await _dio.post('/ratings', data: {
      "rating": rating,
      "content": comment,
      "order_id": orderId,
    });
    return response.data['message'];
  }
}
