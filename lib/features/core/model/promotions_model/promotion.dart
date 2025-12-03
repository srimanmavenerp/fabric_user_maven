import 'dart:convert';

class Promotion {
	String? title;
	String? description;
	String? imagePath;

	Promotion({this.title, this.description, this.imagePath});

	factory Promotion.fromMap(Map<String, dynamic> data) => Promotion(
				title: data['title'] as String?,
				description: data['description'] as String?,
				imagePath: data['image_path'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'title': title,
				'description': description,
				'image_path': imagePath,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Promotion].
	factory Promotion.fromJson(String data) {
		return Promotion.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Promotion] to a JSON string.
	String toJson() => json.encode(toMap());
}
