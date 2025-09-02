// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_repo_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalRepoConfig _$LocalRepoConfigFromJson(Map<String, dynamic> json) =>
    LocalRepoConfig(
      id: json['id'] as String,
      path: json['path'] as String,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
    );

Map<String, dynamic> _$LocalRepoConfigToJson(LocalRepoConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'lastAccessed': instance.lastAccessed.toIso8601String(),
    };
