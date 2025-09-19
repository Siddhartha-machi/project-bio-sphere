import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/constants/catalog_constants.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/features/auth/constants/auth_enums.dart';
import 'package:bio_sphere/features/auth/data/models/local_repo_config.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences extends IDataModel {
  final Theme themeMode;
  final bool allowDataShare;
  final bool notificationsEnabled;
  final List<Backend> backendOrder;

  final LocalRepoConfig? localRepoConfig;

  const UserPreferences({
    required super.id,
    this.localRepoConfig,
    this.allowDataShare = false,
    this.themeMode = Theme.system,
    this.notificationsEnabled = false,

    /// Default backend priority order
    this.backendOrder = const [Backend.api, Backend.fallbackBAAS],
  });

  // Auto-generated methods
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);
}
