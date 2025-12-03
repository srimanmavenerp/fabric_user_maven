import 'dart:convert';

class AboutUs {
  final String message;
  final Data data;
  AboutUs({
    required this.message,
    required this.data,
  });

  AboutUs copyWith({
    String? message,
    Data? data,
  }) {
    return AboutUs(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'data': data.toMap(),
    };
  }

  factory AboutUs.fromMap(Map<String, dynamic> map) {
    return AboutUs(
      message: map['message'] as String,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutUs.fromJson(String source) =>
      AboutUs.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AboutUs(message: $message, data: $data)';

  @override
  bool operator ==(covariant AboutUs other) {
    if (identical(this, other)) return true;

    return other.message == message && other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class Data {
  final String? title;
  final String? desceiption;
  final String? phone;
  final String? whatsapp;
  final String? email;
  Data({
    this.title,
    this.desceiption,
    this.phone,
    this.whatsapp,
    this.email,
  });

  Data copyWith({
    String? title,
    String? desceiption,
    String? phone,
    String? whatsapp,
    String? email,
  }) {
    return Data(
      title: title ?? this.title,
      desceiption: desceiption ?? this.desceiption,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'desceiption': desceiption,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      title: map['title'] as String?,
      desceiption: map['desceiption'] as String?,
      phone: map['phone'] as String?,
      whatsapp: map['whatsapp'] as String?,
      email: map['email'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(title: $title, desceiption: $desceiption, phone: $phone, whatsapp: $whatsapp, email: $email)';
  }

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.desceiption == desceiption &&
        other.phone == phone &&
        other.whatsapp == whatsapp &&
        other.email == email;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        desceiption.hashCode ^
        phone.hashCode ^
        whatsapp.hashCode ^
        email.hashCode;
  }
}
