// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    uuid: json['uuid'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    address: json['address'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };
