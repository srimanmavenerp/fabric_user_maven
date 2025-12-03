import 'dart:convert';

import 'data.dart';

class VariantListModel {
	String? message;
	Data? data;

	VariantListModel({this.message, this.data});

	factory VariantListModel.fromMap(Map<String, dynamic> data) {
		return VariantListModel(
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
  /// Parses the string and returns the resulting Json object as [VariantListModel].
	factory VariantListModel.fromJson(String data) {
		return VariantListModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [VariantListModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
