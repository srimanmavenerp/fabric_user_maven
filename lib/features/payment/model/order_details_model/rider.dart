import 'dart:convert';

class Rider {
  final int id;
  final String name;
  final String phone;
  final String profilePhoto;
  Rider({
    required this.id,
    required this.name,
    required this.phone,
    required this.profilePhoto,
  });

  Rider copyWith({
    int? id,
    String? name,
    String? phone,
    String? profilePhoto,
  }) {
    return Rider(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'profile_photo': profilePhoto,
    };
  }

  factory Rider.fromMap(Map<String, dynamic> map) {
    return Rider(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      profilePhoto: map['profile_photo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rider.fromJson(String source) =>
      Rider.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Rider(id: $id, name: $name, phone: $phone, profile_photo: $profilePhoto)';
  }

  @override
  bool operator ==(covariant Rider other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.profilePhoto == profilePhoto;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ phone.hashCode ^ profilePhoto.hashCode;
  }
}
