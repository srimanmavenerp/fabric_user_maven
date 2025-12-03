import 'dart:convert';

class Shop {
  final int id;
  final String name;
  final Owner owner;
  final String logo;
  Shop({
    required this.id,
    required this.name,
    required this.owner,
    required this.logo,
  });

  Shop copyWith({
    int? id,
    String? name,
    Owner? owner,
    String? logo,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      logo: logo ?? this.logo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'owner': owner.toMap(),
      'logo': logo,
    };
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      owner: Owner.fromMap(map['owner'] as Map<String, dynamic>),
      logo: map['logo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Shop.fromJson(String source) =>
      Shop.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Shop(id: $id, name: $name, owner: $owner, logo: $logo)';
  }

  @override
  bool operator ==(covariant Shop other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.owner == owner &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ owner.hashCode ^ logo.hashCode;
  }
}

class Owner {
  final int id;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final String mobile;
  Owner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.mobile,
  });

  Owner copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? mobile,
  }) {
    return Owner(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      id: map['id'].toInt() as int,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      mobile: map['mobile'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) =>
      Owner.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Owner(id: $id, first_name: $firstName, last_name: $lastName, name: $name, email: $email, mobile: $mobile)';
  }

  @override
  bool operator ==(covariant Owner other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.name == name &&
        other.email == email &&
        other.mobile == mobile;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        name.hashCode ^
        email.hashCode ^
        mobile.hashCode;
  }
}
