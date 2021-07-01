import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class BaseModel {
  BaseModel({this.uuid, this.createdAt, this.updatedAt});

  String? uuid;
  int? createdAt;
  int? updatedAt;

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}

@JsonSerializable()
class Customer extends BaseModel {
  Customer({this.name, this.phone, this.address});

  String? name;
  String? phone;
  String? address;

  static Customer fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class LaundryRecord extends BaseModel {
  LaundryRecord(
      {this.customerUuid,
      this.laundryDocumentUuid,
      this.weight,
      this.price,
      this.type,
      this.start,
      this.done,
      this.received,
      this.wash,
      this.dry,
      this.iron,
      this.note});

  String? customerUuid;
  String? laundryDocumentUuid;
  double? weight;
  int? price;
  int? type; // 0 = cash, 1 = epay
  int? start;
  int? done;
  int? received;
  String? ePayId;
  bool? wash;
  bool? dry;
  bool? iron;
  String? note;

  static LaundryRecord fromJson(Map<String, dynamic> json) =>
      _$LaundryRecordFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryRecordToJson(this);
}

@JsonSerializable()
class LaundryDocument extends BaseModel {
  LaundryDocument({this.name, this.date});

  String? name;
  int? date;

  static LaundryDocument fromJson(Map<String, dynamic> json) =>
      _$LaundryDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryDocumentToJson(this);
}
