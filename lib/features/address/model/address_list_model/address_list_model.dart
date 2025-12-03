import 'dart:convert';

import 'data.dart';

class AddressListModel {
	String? message;
	Data? data;

	AddressListModel({this.message, this.data});

	factory AddressListModel.fromMap(Map<String, dynamic> data) {
		return AddressListModel(
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
  /// Parses the string and returns the resulting Json object as [AddressListModel].
	factory AddressListModel.fromJson(String data) {
		return AddressListModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [AddressListModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
