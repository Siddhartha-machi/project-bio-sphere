import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/types/callback_typedefs.dart';
import 'package:bio_sphere/constants/catalog_constants.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';

part 'data_source_config.g.dart';

/// Represents one service entry fetched from API
@JsonSerializable()
class DataSourceConfig extends IDataModel {
  final String path;
  final bool isActive;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final FromJson? transformer;
  final List<Backend> backends;

  DataSourceConfig({
    this.path = '',
    this.transformer,
    required super.id,
    this.isActive = true,
    this.backends = const [Backend.api],
  });

  // Auto-generated methods
  factory DataSourceConfig.fromJson(Map<String, dynamic> json) =>
      _$DataSourceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DataSourceConfigToJson(this);

  DataSourceConfig copyWith(FromJson? transformer) {
    return DataSourceConfig(
      id: id,
      path: path,
      backends: backends,
      isActive: isActive,
      transformer: transformer,
    );
  }
}
