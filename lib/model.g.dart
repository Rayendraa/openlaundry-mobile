// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) {
  return BaseModel(
    uuid: json['uuid'] as String?,
    createdAt: json['createdAt'] as int?,
    updatedAt: json['updatedAt'] as int?,
  );
}

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    name: json['name'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
  )
    ..uuid = json['uuid'] as String?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?;
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

LaundryRecord _$LaundryRecordFromJson(Map<String, dynamic> json) {
  return LaundryRecord(
    customerUuid: json['customerUuid'] as String?,
    laundryDocumentUuid: json['laundryDocumentUuid'] as String?,
    weight: (json['weight'] as num?)?.toDouble(),
    price: json['price'] as int?,
    type: json['type'] as int?,
    start: json['start'] as int?,
    done: json['done'] as int?,
    received: json['received'] as int?,
    wash: json['wash'] as bool?,
    dry: json['dry'] as bool?,
    iron: json['iron'] as bool?,
    note: json['note'] as String?,
  )
    ..uuid = json['uuid'] as String?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?
    ..ePayId = json['ePayId'] as String?
    ..deletedAt = json['deletedAt'] as int?;
}

Map<String, dynamic> _$LaundryRecordToJson(LaundryRecord instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'customerUuid': instance.customerUuid,
      'laundryDocumentUuid': instance.laundryDocumentUuid,
      'weight': instance.weight,
      'price': instance.price,
      'type': instance.type,
      'start': instance.start,
      'done': instance.done,
      'received': instance.received,
      'ePayId': instance.ePayId,
      'wash': instance.wash,
      'dry': instance.dry,
      'iron': instance.iron,
      'note': instance.note,
      'deletedAt': instance.deletedAt,
    };

LaundryDocument _$LaundryDocumentFromJson(Map<String, dynamic> json) {
  return LaundryDocument(
    name: json['name'] as String?,
    date: json['date'] as int?,
  )
    ..uuid = json['uuid'] as String?
    ..createdAt = json['createdAt'] as int?
    ..updatedAt = json['updatedAt'] as int?;
}

Map<String, dynamic> _$LaundryDocumentToJson(LaundryDocument instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'name': instance.name,
      'date': instance.date,
    };
