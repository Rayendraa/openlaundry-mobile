import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class BaseModel {
  BaseModel({this.id, this.createdAt, this.updatedAt});

  int? id;
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

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class LaundryRecord extends BaseModel {
  LaundryRecord(
      {this.customerId,
      this.laundryDocumentId,
      this.weight,
      this.price,
      this.type,
      this.start,
      this.done,
      this.received});

  int? customerId;
  int? laundryDocumentId;
  double? weight;
  int? price;
  int? type; // 0 = cash, 1 = epay
  int? start;
  int? done;
  int? received;
  String? ePayId;

  factory LaundryRecord.fromJson(Map<String, dynamic> json) =>
      _$LaundryRecordFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryRecordToJson(this);
}

@JsonSerializable()
class LaundryDocument extends BaseModel {
  LaundryDocument({this.name, this.date});

  String? name;
  int? date;

  factory LaundryDocument.fromJson(Map<String, dynamic> json) =>
      _$LaundryDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryDocumentToJson(this);
}
