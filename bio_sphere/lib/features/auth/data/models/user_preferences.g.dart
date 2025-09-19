// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      id: json['id'] as String,
      localRepoConfig: json['localRepoConfig'] == null
          ? null
          : LocalRepoConfig.fromJson(
              json['localRepoConfig'] as Map<String, dynamic>),
      allowDataShare: json['allowDataShare'] as bool? ?? false,
      themeMode: $enumDecodeNullable(_$ThemeEnumMap, json['themeMode']) ??
          Theme.system,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      backendOrder: (json['backendOrder'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$BackendEnumMap, e))
              .toList() ??
          const [Backend.api, Backend.fallbackBAAS],
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'id': instance.id,
      'themeMode': _$ThemeEnumMap[instance.themeMode]!,
      'allowDataShare': instance.allowDataShare,
      'notificationsEnabled': instance.notificationsEnabled,
      'backendOrder':
          instance.backendOrder.map((e) => _$BackendEnumMap[e]!).toList(),
      'localRepoConfig': instance.localRepoConfig,
    };

const _$ThemeEnumMap = {
  Theme.light: 'light',
  Theme.dark: 'dark',
  Theme.system: 'system',
};

const _$BackendEnumMap = {
  Backend.api: 'api',
  Backend.localDB: 'localDB',
  Backend.fallbackBAAS: 'fallbackBAAS',
};
