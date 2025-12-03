import 'dart:convert';

import 'data.dart';

class ProductListModel {
	String? message;
	Data? data;

	ProductListModel({this.message, this.data});

	factory ProductListModel.fromMap(Map<String, dynamic> data) {
		return ProductListModel(
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
  /// Parses the string and returns the resulting Json object as [ProductListModel].
	factory ProductListModel.fromJson(String data) {
		return ProductListModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ProductListModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
