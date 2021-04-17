import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class User {
  User({this.uuid, this.name, this.phone, this.address});

  String? uuid;
  String? name;
  String? phone;
  String? address;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
