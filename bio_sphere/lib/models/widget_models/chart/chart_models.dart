import 'package:flutter/foundation.dart';

import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/api_data_model.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';

part 'chart_models.g.dart';

/// A single raw record used as input for charting.
/// Example rows:
///   { label: 'Jan', value: 120.0, group: 'Revenue' }
///   { label: 'Jan', value: 80.0,  group: 'Cost' }
@immutable
@JsonSerializable()
class ChartData implements APIDataModel {
  /// X-axis bucket (category/period), e.g. "Jan", "2025-01-01", "Q1".
  final String label;

  /// Numeric magnitude for this (label, group).
  final double value;

  /// Series/group name (for stacked/multi-series charts), e.g. "Revenue".
  final String group;

  const ChartData({
    required this.label,
    required this.value,
    required this.group,
  });

  /// JSON (de)serialization
  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$ChartDataToJson(this);

  ChartData copyWith({String? label, double? value, String? group}) {
    return ChartData(
      label: label ?? this.label,
      value: value ?? this.value,
      group: group ?? this.group,
    );
  }
}

/// Nested value matrix used by widgets:
/// label (x bucket) -> { group (series) -> value }
typedef ChartMatrix = Map<String, Map<String, double>>;

@immutable
class ChartConfig {
  /// Display units (currency, percent, none, etc.).
  final ChartUnits units;

  /// Maximum Y across all buckets/series (post-aggregation).
  final double maxY;

  /// Deterministic, unique list of series names (used for colors/legend).
  final List<String> seriesNames;

  /// Deterministic, unique list of x-axis buckets, in display order.
  final List<String> buckets;

  /// Values matrix: [bucket -> series -> value].
  final ChartMatrix matrix;

  const ChartConfig({
    required this.matrix,
    required this.maxY,
    required this.buckets,
    required this.seriesNames,
    this.units = ChartUnits.none,
  });

  bool get isSingleSeries => seriesNames.length == 1;

  ChartConfig copyWith({
    double? maxY,
    ChartUnits? units,
    ChartMatrix? matrix,
    List<String>? buckets,
    List<String>? seriesNames,
  }) {
    return ChartConfig(
      maxY: maxY ?? this.maxY,
      units: units ?? this.units,
      matrix: matrix ?? this.matrix,
      buckets: buckets ?? this.buckets,
      seriesNames: seriesNames ?? this.seriesNames,
    );
  }
}
