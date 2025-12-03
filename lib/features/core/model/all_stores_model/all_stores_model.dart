import 'dart:convert';

import 'data.dart';

class AllStoresModel {
	String? message;
	Data? data;

	AllStoresModel({this.message, this.data});

	factory AllStoresModel.fromMap(Map<String, dynamic> data) {
		return AllStoresModel(
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
  /// Parses the string and returns the resulting Json object as [AllStoresModel].
	factory AllStoresModel.fromJson(String data) {
		return AllStoresModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [AllStoresModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
