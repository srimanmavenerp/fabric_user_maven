import 'dart:convert';

import 'data.dart';

class AllOrderModel {
	String? message;
	Data? data;

	AllOrderModel({this.message, this.data});

	factory AllOrderModel.fromMap(Map<String, dynamic> data) => AllOrderModel(
				message: data['message'] as String?,
				data: data['data'] == null
						? null
						: Data.fromMap(data['data'] as Map<String, dynamic>),
			);

	Map<String, dynamic> toMap() => {
				'message': message,
				'data': data?.toMap(),
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AllOrderModel].
	factory AllOrderModel.fromJson(String data) {
		return AllOrderModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [AllOrderModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
