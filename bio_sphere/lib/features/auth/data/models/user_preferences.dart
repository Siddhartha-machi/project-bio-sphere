import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/api_data_model.dart';
import 'package:bio_sphere/features/auth/constants/auth_enums.dart';
import 'package:bio_sphere/features/auth/data/models/local_repo_config.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences extends APIDataModel {
  final Theme themeMode;
  final SaveMode savemode;
  final bool allowDataShare;
  final bool notificationsEnabled;

  final LocalRepoConfig? localRepoConfig;

  const UserPreferences({
    this.localRepoConfig,
    this.allowDataShare = false,
    this.themeMode = Theme.system,
    this.savemode = SaveMode.remote,
    this.notificationsEnabled = false,
  });

  // Auto-generated methods
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$UserPreferencesToJson(this);
}
