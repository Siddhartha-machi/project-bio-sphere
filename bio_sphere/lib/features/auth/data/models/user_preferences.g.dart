// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      localRepoConfig: json['localRepoConfig'] == null
          ? null
          : LocalRepoConfig.fromJson(
              json['localRepoConfig'] as Map<String, dynamic>),
      allowDataShare: json['allowDataShare'] as bool? ?? false,
      themeMode: $enumDecodeNullable(_$ThemeEnumMap, json['themeMode']) ??
          Theme.system,
      savemode: $enumDecodeNullable(_$SaveModeEnumMap, json['savemode']) ??
          SaveMode.remote,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeEnumMap[instance.themeMode]!,
      'savemode': _$SaveModeEnumMap[instance.savemode]!,
      'allowDataShare': instance.allowDataShare,
      'notificationsEnabled': instance.notificationsEnabled,
      'localRepoConfig': instance.localRepoConfig,
    };

const _$ThemeEnumMap = {
  Theme.light: 'light',
  Theme.dark: 'dark',
  Theme.system: 'system',
};

const _$SaveModeEnumMap = {
  SaveMode.remote: 'remote',
  SaveMode.local: 'local',
  SaveMode.remoteAndLocal: 'remoteAndLocal',
};
