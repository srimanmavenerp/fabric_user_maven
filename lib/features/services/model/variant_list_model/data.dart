import 'dart:convert';

import 'variant.dart';

class Data {
	List<Variant>? variants;

	Data({this.variants});

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				variants: (data['variants'] as List<dynamic>?)
						?.map((e) => Variant.fromMap(e as Map<String, dynamic>))
						.toList(),
			);

	Map<String, dynamic> toMap() => {
				'variants': variants?.map((e) => e.toMap()).toList(),
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
