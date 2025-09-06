// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceConfig _$DataSourceConfigFromJson(Map<String, dynamic> json) =>
    DataSourceConfig(
      table: json['table'] as String?,
      localDb: json['localDb'],
      endpoint: json['endpoint'] as String?,
      collection: json['collection'] as String?,
      id: json['id'] as String,
      isCore: json['isCore'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      backendType: $enumDecode(_$BackendEnumMap, json['backendType']),
    );

Map<String, dynamic> _$DataSourceConfigToJson(DataSourceConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isCore': instance.isCore,
      'isActive': instance.isActive,
      'backendType': _$BackendEnumMap[instance.backendType]!,
      'table': instance.table,
      'endpoint': instance.endpoint,
      'localDb': instance.localDb,
      'collection': instance.collection,
    };

const _$BackendEnumMap = {
  Backend.api: 'api',
  Backend.localDB: 'localDB',
  Backend.firebase: 'firebase',
};
