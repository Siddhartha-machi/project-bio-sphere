// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataSourceConfig _$DataSourceConfigFromJson(Map<String, dynamic> json) =>
    DataSourceConfig(
      path: json['path'] as String? ?? '',
      id: json['id'] as String,
      isActive: json['isActive'] as bool? ?? true,
      backends: (json['backends'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$BackendEnumMap, e))
              .toList() ??
          const [Backend.api, Backend.fallbackBAAS],
    );

Map<String, dynamic> _$DataSourceConfigToJson(DataSourceConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'isActive': instance.isActive,
      'backends': instance.backends.map((e) => _$BackendEnumMap[e]!).toList(),
    };

const _$BackendEnumMap = {
  Backend.api: 'api',
  Backend.localDB: 'localDB',
  Backend.fallbackBAAS: 'fallbackBAAS',
};
