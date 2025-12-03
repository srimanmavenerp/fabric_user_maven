import 'dart:convert';

class ChangePasswordModel {
	String? message;

	ChangePasswordModel({this.message});

	factory ChangePasswordModel.fromMap(Map<String, dynamic> data) {
		return ChangePasswordModel(
			message: data['message'] as String?,
		);
	}



	Map<String, dynamic> toMap() => {
				'message': message,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChangePasswordModel].
	factory ChangePasswordModel.fromJson(String data) {
		return ChangePasswordModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ChangePasswordModel] to a JSON string.
	String toJson() => json.encode(toMap());
}
