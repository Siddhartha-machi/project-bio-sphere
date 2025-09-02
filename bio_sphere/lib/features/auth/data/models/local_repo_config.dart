import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/i_data_model.dart';

part 'local_repo_config.g.dart';

@JsonSerializable()
class LocalRepoConfig extends IDataModel {
  final String path;
  final DateTime lastAccessed;
  // TODO revisit

  const LocalRepoConfig({
    required super.id,
    required this.path,
    required this.lastAccessed,
  });

  // Auto-generated methods
  factory LocalRepoConfig.fromJson(Map<String, dynamic> json) =>
      _$LocalRepoConfigFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$LocalRepoConfigToJson(this);
}
