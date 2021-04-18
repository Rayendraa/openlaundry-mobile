// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) {
  return BaseModel(
    id: json['id'] as int?,
    createdAt: json['createdAt'] as int?,
    updatedAt: json['updatedAt'] as int?,
  );
}

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    name: json['name'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
  )
    ..id = json['id'] as int?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?;
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

LaundryRecord _$LaundryRecordFromJson(Map<String, dynamic> json) {
  return LaundryRecord(
    customerId: json['customerId'] as int?,
    laundryDocumentId: json['laundryDocumentId'] as int?,
    weight: (json['weight'] as num?)?.toDouble(),
    price: json['price'] as int?,
    type: json['type'] as int?,
    start: json['start'] as int?,
    done: json['done'] as int?,
    received: json['received'] as int?,
  )
    ..id = json['id'] as int?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?
    ..ePayId = json['ePayId'] as String?;
}

Map<String, dynamic> _$LaundryRecordToJson(LaundryRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'customerId': instance.customerId,
      'laundryDocumentId': instance.laundryDocumentId,
      'weight': instance.weight,
      'price': instance.price,
      'type': instance.type,
      'start': instance.start,
      'done': instance.done,
      'received': instance.received,
      'ePayId': instance.ePayId,
    };

LaundryDocument _$LaundryDocumentFromJson(Map<String, dynamic> json) {
  return LaundryDocument(
    name: json['name'] as String?,
    date: json['date'] as int?,
  )
    ..id = json['id'] as int?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?;
}

Map<String, dynamic> _$LaundryDocumentToJson(LaundryDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'name': instance.name,
      'date': instance.date,
    };
