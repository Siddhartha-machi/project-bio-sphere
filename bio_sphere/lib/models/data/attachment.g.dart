// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
      id: json['id'] as String,
      url: json['url'] as String,
      name: json['name'] as String,
      size: (json['size'] as num).toDouble(),
      uploadDate: DateTime.parse(json['uploadDate'] as String),
    );

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'name': instance.name,
      'size': instance.size,
      'uploadDate': instance.uploadDate.toIso8601String(),
    };
