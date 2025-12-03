import 'dart:convert';

import 'data.dart';

class OrderOptionsModel {
	String? message;
	Data? data;

	OrderOptionsModel({this.message, this.data});

	factory OrderOptionsModel.fromMap(Map<String, dynamic> data) {
		return OrderOptionsModel(
			message: data['message'] as String?,
			data: data['data'] == null
						? null
						: Data.fromMap(data['data'] as Map<String, dynamic>),
		);
	}



	Map<String, dynamic> toMap() => {
				'message': message,
				'data': data?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderOptionsModel].
	factory OrderOptionsModel.fromJson(String data) {
		return OrderOptionsModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [OrderOptionsModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
