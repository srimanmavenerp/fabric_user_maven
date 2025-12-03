import 'dart:convert';

import 'data.dart';

class ServiceModel {
	String? message;
	Data? data;

	ServiceModel({this.message, this.data});

	factory ServiceModel.fromMap(Map<String, dynamic> data) => ServiceModel(
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
  /// Parses the string and returns the resulting Json object as [ServiceModel].
	factory ServiceModel.fromJson(String data) {
		return ServiceModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ServiceModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
