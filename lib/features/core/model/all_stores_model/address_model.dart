// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  int id;
  String addressName;
  String roadNo;
  String houseNo;
  String houseName;
  String flatNo;
  String block;
  String area;
  String subDistrictId;
  String districtId;
  String addressLine;
  String addressLine2;
  String deliveryNote;
  String postCode;
  String latitude;
  String longitude;
  int isDefault;

  AddressModel({
    required this.id,
    required this.addressName,
    required this.roadNo,
    required this.houseNo,
    required this.houseName,
    required this.flatNo,
    required this.block,
    required this.area,
    required this.subDistrictId,
    required this.districtId,
    required this.addressLine,
    required this.addressLine2,
    required this.deliveryNote,
    required this.postCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        addressName: json["address_name"],
        roadNo: json["road_no"],
        houseNo: json["house_no"],
        houseName: json["house_name"],
        flatNo: json["flat_no"],
        block: json["block"],
        area: json["area"],
        subDistrictId: json["sub_district_id"],
        districtId: json["district_id"],
        addressLine: json["address_line"],
        addressLine2: json["address_line2"],
        deliveryNote: json["delivery_note"],
        postCode: json["post_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isDefault: json["is_default"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_name": addressName,
        "road_no": roadNo,
        "house_no": houseNo,
        "house_name": houseName,
        "flat_no": flatNo,
        "block": block,
        "area": area,
        "sub_district_id": subDistrictId,
        "district_id": districtId,
        "address_line": addressLine,
        "address_line2": addressLine2,
        "delivery_note": deliveryNote,
        "post_code": postCode,
        "latitude": latitude,
        "longitude": longitude,
        "is_default": isDefault,
      };
}
