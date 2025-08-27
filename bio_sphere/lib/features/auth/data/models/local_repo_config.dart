import 'package:bio_sphere/models/interfaces/api_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_repo_config.g.dart';

@JsonSerializable()
class LocalRepoConfig extends APIDataModel {
  final String path;
  final DateTime lastAccessed;
  // TODO revisit

  const LocalRepoConfig({required this.path, required this.lastAccessed});

  // Auto-generated methods
  factory LocalRepoConfig.fromJson(Map<String, dynamic> json) =>
      _$LocalRepoConfigFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$LocalRepoConfigToJson(this);
}
