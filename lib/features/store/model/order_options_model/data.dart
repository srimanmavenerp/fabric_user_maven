import 'dart:convert';

class Data {
	String? deliveryCharge;
	String? minOrderAmount;
	String? maxOrderAmount;

	Data({this.deliveryCharge, this.minOrderAmount, this.maxOrderAmount});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				deliveryCharge: data['delivery_charge'] as String?,
				minOrderAmount: data['min_order_amount'] as String?,
				maxOrderAmount: data['max_order_amount'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'delivery_charge': deliveryCharge,
				'min_order_amount': minOrderAmount,
				'max_order_amount': maxOrderAmount,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
	factory Data.fromJson(String data) {
		return Data.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
	String toJson() => json.encode(toMap());
}
