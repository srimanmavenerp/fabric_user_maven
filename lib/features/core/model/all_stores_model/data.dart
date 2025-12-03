import 'dart:convert';

import 'store.dart';

class Data {
	List<Store>? stores;

	Data({this.stores});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				stores: (data['stores'] as List<dynamic>?)
						?.map((e) => Store.fromMap(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toMap() => {
				'stores': stores?.map((e) => e.toMap()).toList(),
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
