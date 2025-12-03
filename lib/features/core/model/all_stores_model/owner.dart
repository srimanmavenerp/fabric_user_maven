import 'dart:convert';

class Owner {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? mobile;
  dynamic gender;
  DateTime? mobileVerifiedAt;
  bool? isActive;
  dynamic alternativePhone;
  String? profilePhotoPath;
  dynamic drivingLience;
  dynamic dateOfBirth;
  String? joinDate;

  Owner({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.mobile,
    this.gender,
    this.mobileVerifiedAt,
    this.isActive,
    this.alternativePhone,
    this.profilePhotoPath,
    this.drivingLience,
    this.dateOfBirth,
    this.joinDate,
  });

  factory Owner.fromMap(Map<String, dynamic> data) => Owner(
        id: data['id'] as int?,
        firstName: data['first_name'] as String?,
        lastName: data['last_name'] as String?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        mobile: data['mobile'] as String?,
        gender: data['gender'] as dynamic,
        mobileVerifiedAt: data['mobile_verified_at'] == null
            ? null
            : DateTime.parse(data['mobile_verified_at'] as String),
        isActive: data['is_active'] as bool?,
        alternativePhone: data['alternative_phone'] as dynamic,
        profilePhotoPath: data['profile_photo_path'] as String?,
        drivingLience: data['driving_lience'] as dynamic,
        dateOfBirth: data['date_of_birth'] as dynamic,
        joinDate: data['join_date'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'name': name,
        'email': email,
        'mobile': mobile,
        'gender': gender,
        'mobile_verified_at': mobileVerifiedAt?.toIso8601String(),
        'is_active': isActive,
        'alternative_phone': alternativePhone,
        'profile_photo_path': profilePhotoPath,
        'driving_lience': drivingLience,
        'date_of_birth': dateOfBirth,
        'join_date': joinDate,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Owner].
  factory Owner.fromJson(String data) {
    return Owner.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Owner] to a JSON string.
  String toJson() => json.encode(toMap());
}
