import 'dart:convert';

class Rating {
  int? rating;
  String? content;
  String? name;
  String? img;
  String? date;

  Rating({this.rating, this.content, this.name, this.img, this.date});

  factory Rating.fromMap(Map<String, dynamic> data) => Rating(
        rating: data['rating'] as int?,
        content: data['content'] as String?,
        name: data['name'] as String?,
        img: data['img'] as String?,
        date: data['date'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'rating': rating,
        'content': content,
        'name': name,
        'img': img,
        'date': date,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Rating].
  factory Rating.fromJson(String data) {
    return Rating.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Rating] to a JSON string.
  String toJson() => json.encode(toMap());
}
