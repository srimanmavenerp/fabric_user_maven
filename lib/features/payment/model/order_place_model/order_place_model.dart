// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderPlaceModel {
  String? store_id;
  String pick_date;
  String? pick_hour;
  String delivery_date;
  String? delivery_hour;
  String payment_type;
  List<OrderProductModel> products;
  String address_id;
  String? coupon_id;
  List<String> additional_service_id;
  OrderPlaceModel({
    required this.store_id,
    required this.pick_date,
    this.pick_hour,
    required this.delivery_date,
    this.delivery_hour,
    required this.products,
    required this.payment_type,
    required this.address_id,
    this.coupon_id,
    required this.additional_service_id,
  });

  OrderPlaceModel copyWith({
    String? store_id,
    String? pick_date,
    String? pick_hour,
    String? delivery_date,
    String? delivery_hour,
    List<OrderProductModel>? products,
    String? address_id,
    String? coupon_id,
    List<String>? additional_service_id,
    String? payment_type,
  }) {
    return OrderPlaceModel(
      store_id: store_id ?? this.store_id,
      pick_date: pick_date ?? this.pick_date,
      pick_hour: pick_hour ?? this.pick_hour,
      delivery_date: delivery_date ?? this.delivery_date,
      delivery_hour: delivery_hour ?? this.delivery_hour,
      products: products ?? this.products,
      address_id: address_id ?? this.address_id,
      coupon_id: coupon_id ?? this.coupon_id,
      additional_service_id:
          additional_service_id ?? this.additional_service_id,
      payment_type: payment_type ?? this.payment_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "store_id": store_id,
      'pick_date': pick_date,
      'pick_hour': pick_hour,
      'delivery_date': delivery_date,
      'delivery_hour': delivery_hour,
      'products': products.map((x) => x.toMap()).toList(),
      'address_id': address_id,
      'coupon_id': coupon_id,
      'additional_service_id': additional_service_id,
      'payment_type': payment_type,
    };
  }

  factory OrderPlaceModel.fromMap(Map<String, dynamic> map) {
    return OrderPlaceModel(
      store_id: map["store_id"] as String,
      pick_date: map['pick_date'] as String,
      pick_hour: map['pick_hour'] as String,
      delivery_date: map['delivery_date'] as String,
      delivery_hour: map['delivery_hour'] as String,
      products: List<OrderProductModel>.from(
        (map['products'] as List<int>).map<OrderProductModel>(
          (x) => OrderProductModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      address_id: map['address_id'] as String,
      coupon_id: map['coupon_id'] != null ? map['coupon_id'] as String : null,
      additional_service_id: List<String>.from(
        map['additional_service_id'] as List<String>,
      ),
      payment_type: map['payment_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderPlaceModel.fromJson(String source) =>
      OrderPlaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderPlaceModel(store_id:$store_id, pick_date: $pick_date, pick_hour: $pick_hour, delivery_date: $delivery_date, delivery_hour: $delivery_hour, products: $products, address_id: $address_id, coupon_id: $coupon_id, additional_service_id: $additional_service_id)';
  }

  @override
  bool operator ==(covariant OrderPlaceModel other) {
    if (identical(this, other)) return true;

    return other.store_id == store_id &&
        other.pick_date == pick_date &&
        other.pick_hour == pick_hour &&
        other.delivery_date == delivery_date &&
        other.delivery_hour == delivery_hour &&
        listEquals(other.products, products) &&
        other.address_id == address_id &&
        other.coupon_id == coupon_id &&
        listEquals(other.additional_service_id, additional_service_id);
  }

  @override
  int get hashCode {
    return store_id.hashCode ^
        pick_date.hashCode ^
        pick_hour.hashCode ^
        delivery_date.hashCode ^
        delivery_hour.hashCode ^
        products.hashCode ^
        address_id.hashCode ^
        coupon_id.hashCode ^
        additional_service_id.hashCode;
  }
}

class OrderProductModel {
  String id;
  String quantity;
  OrderProductModel({
    required this.id,
    required this.quantity,
  });

  OrderProductModel copyWith({
    String? id,
    String? quantity,
  }) {
    return OrderProductModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
    };
  }

  factory OrderProductModel.fromMap(Map<String, dynamic> map) {
    return OrderProductModel(
      id: map['id'] as String,
      quantity: map['quantity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderProductModel.fromJson(String source) =>
      OrderProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OrderProductModel(id: $id, quantity: $quantity)';

  @override
  bool operator ==(covariant OrderProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.quantity == quantity;
  }

  @override
  int get hashCode => id.hashCode ^ quantity.hashCode;
}
