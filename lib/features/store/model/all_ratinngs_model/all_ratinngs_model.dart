import 'dart:convert';

import 'data.dart';

class AllRatinngsModel {
	String? message;
	Data? data;

	AllRatinngsModel({this.message, this.data});

	factory AllRatinngsModel.fromMap(Map<String, dynamic> data) {
		return AllRatinngsModel(
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
  /// Parses the string and returns the resulting Json object as [AllRatinngsModel].
	factory AllRatinngsModel.fromJson(String data) {
		return AllRatinngsModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [AllRatinngsModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
