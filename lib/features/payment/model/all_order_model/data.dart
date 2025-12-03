import 'dart:convert';

import 'order.dart';

class Data {
	List<Order>? orders;

	Data({this.orders});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				orders: (data['orders'] as List<dynamic>?)
						?.map((e) => Order.fromMap(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toMap() => {
				'orders': orders?.map((e) => e.toMap()).toList(),
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
