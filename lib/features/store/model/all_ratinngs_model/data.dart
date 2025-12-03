import 'dart:convert';

import 'rating.dart';

class Data {
  int? totalStar;
  String? average;
  String? star5;
  String? star4;
  String? star3;
  String? star2;
  String? star1;
  List<Rating>? ratings;

  Data({
    this.totalStar,
    this.average,
    this.star5,
    this.star4,
    this.star3,
    this.star2,
    this.star1,
    this.ratings,
  });

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        totalStar: data['total_star'] as int?,
        average: data['average'] as String?,
        star5: data['star_5'] as String?,
        star4: data['star_4'] as String?,
        star3: data['star_3'] as String?,
        star2: data['star_2'] as String?,
        star1: data['star_1'] as String?,
        ratings: (data['ratings'] as List<dynamic>?)
            ?.map((e) => Rating.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'total_star': totalStar,
        'average': average,
        'star_5': star5,
        'star_4': star4,
        'star_3': star3,
        'star_2': star2,
        'star_1': star1,
        'ratings': ratings?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
