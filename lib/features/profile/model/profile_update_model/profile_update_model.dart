import 'dart:convert';

import 'data.dart';

class ProfileUpdateModel {
	String? message;
	Data? data;

	ProfileUpdateModel({this.message, this.data});

	factory ProfileUpdateModel.fromMap(Map<String, dynamic> data) {
		return ProfileUpdateModel(
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
  /// Parses the string and returns the resulting Json object as [ProfileUpdateModel].
	factory ProfileUpdateModel.fromJson(String data) {
		return ProfileUpdateModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ProfileUpdateModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
