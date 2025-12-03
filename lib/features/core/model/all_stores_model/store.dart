import 'dart:convert';
import 'package:laundrymart/features/payment/model/order_details_model/address.dart';

import 'owner.dart';

class Store {
  int? id;
  String? name;
  Owner? owner;
  String? logo;
  String? bannerId;
  double? deliveryCharge;
  dynamic minOrderAmount;
  dynamic maxOrderAmount;
  String? description;
  double? commission;
  String? latitude;
  String? longitude;
  String? distance;
  String? rating;
  int? totalRating;
  Address? address;

  Store({
    this.id,
    this.name,
    this.owner,
    this.logo,
    this.bannerId,
    this.deliveryCharge,
    this.minOrderAmount,
    this.maxOrderAmount,
    this.description,
    this.commission,
    this.latitude,
    this.longitude,
    this.distance,
    this.rating,
    this.totalRating,
    this.address,
  });

  factory Store.fromMap(Map<String, dynamic> data) => Store(
        id: data['id'] as int?,
        name: data['name'] as String?,
        owner: data['owner'] == null
            ? null
            : Owner.fromMap(data['owner'] as Map<String, dynamic>),
        logo: data['logo'] as String?,
        bannerId: data['banner_id'] as String?,
        deliveryCharge: data['delivery_charge'] as double?,
        minOrderAmount: data['min_order_amount'] as dynamic,
        maxOrderAmount: data['max_order_amount'] as dynamic,
        description: data['description'] as String?,
        commission: (data['commission'] as num?)?.toDouble(),
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        distance: data['distance'] as String?,
        rating: data['average_rating'] as String?,
        totalRating: data['total_rating'] as int?,
        address: data['address'] == null
            ? null
            : Address.fromMap(data['address'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'owner': owner?.toMap(),
        'logo': logo,
        'banner_id': bannerId,
        'delivery_charge': deliveryCharge,
        'min_order_amount': minOrderAmount,
        'max_order_amount': maxOrderAmount,
        'description': description,
        'commission': commission,
        'latitude': latitude,
        'longitude': longitude,
        'distance': distance,
        'average_rating': rating,
        'total_rating': totalRating,
        'address': address?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Store].
  factory Store.fromJson(String data) {
    return Store.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Store] to a JSON string.
  String toJson() => json.encode(toMap());
}
