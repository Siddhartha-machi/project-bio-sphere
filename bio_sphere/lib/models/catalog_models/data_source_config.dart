import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/constants/catalog_constants.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';

part 'data_source_config.g.dart';

/// Represents one service entry fetched from API
@JsonSerializable()
class DataSourceConfig extends IDataModel {
  final bool isCore;
  final bool isActive;
  final Backend backendType;

  // Flexible fields depending on backend
  final String? table;
  final String? endpoint;
  final dynamic localDb; // Placeholder, adapt for your DB
  final String? collection;

  DataSourceConfig({
    this.table,
    this.localDb,
    this.endpoint,
    this.collection,
    required super.id,
    this.isCore = false,
    this.isActive = true,
    required this.backendType,
  });

  // Auto-generated methods
  factory DataSourceConfig.fromJson(Map<String, dynamic> json) =>
      _$DataSourceConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DataSourceConfigToJson(this);
}
