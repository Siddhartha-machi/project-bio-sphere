import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'package:bio_sphere/shared/utils/chart/chart_formatters.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/models/widget_models/chart/chart_models.dart';

@immutable
class ChartTransformOptions {
  final bool sortBuckets;
  final bool sortSeries;
  final bool aggregateDuplicates;

  const ChartTransformOptions({
    this.sortBuckets = true,
    this.sortSeries = true,
    this.aggregateDuplicates = true,
  });
}

class ChartTransformer {
  ChartTransformer._();

  /// Normalization rules:
  ///  - Builds a bucket -> series -> value matrix (ChartMatrix).
  ///  - Ensures each bucket map contains every series key (missing -> 0.0).
  ///  - Aggregates duplicate (bucket, series) pairs by sum (unless opts says otherwise).
  ///  - Computes maxY across all values (finite values only).
  ///  - Orders `buckets` and `seriesNames` deterministically (sort or insertion order).
  static ChartConfig buildChartConfig({
    required ChartUnits units,
    required List<ChartData> rows,
    ChartTransformOptions options = const ChartTransformOptions(),
  }) {
    // Use LinkedHashSet to preserve insertion order when sorting is disabled.
    final seenSeries = <String>{};
    final seenBuckets = <String>{};

    // Working matrix: bucket -> (series -> value)
    final ChartMatrix matrix = <String, Map<String, double>>{};

    for (final r in rows) {
      final bucket = r.label;
      final series = r.group;
      final value = r.value;

      // track first-seen order
      if (!seenBuckets.contains(bucket)) seenBuckets.add(bucket);
      if (!seenSeries.contains(series)) seenSeries.add(series);

      // ensure bucket map
      matrix.putIfAbsent(bucket, () => <String, double>{});

      final seriesMap = matrix[bucket]!;

      if (!seriesMap.containsKey(series)) {
        seriesMap[series] = 0.0;
      }

      final updated = options.aggregateDuplicates
          ? (seriesMap[series]! + value)
          : value;

      seriesMap[series] = updated;
    }

    // Determine final ordered lists
    final bucketsList = _orderedListFrom(seenBuckets, options.sortBuckets);
    final seriesList = _orderedListFrom(seenSeries, options.sortSeries);

    // Normalize: ensure every bucket has all series keys (missing -> 0.0)
    for (final bucket in bucketsList) {
      final seriesMap = matrix.putIfAbsent(bucket, () => <String, double>{});

      for (final s in seriesList) {
        seriesMap.putIfAbsent(s, () => 0.0);
      }
    }

    /// Compute maxY (only finite values)
    double maxY = _computeMaxY(matrix);

    /// Scale the maxY to nearest figure.
    maxY = ChartUtils.getScaledMaxY(maxY);

    return ChartConfig(
      maxY: maxY,
      units: units,
      matrix: matrix,
      buckets: bucketsList,
      seriesNames: seriesList,
    );
  }

  /// Build a legend-friendly map from the finalized ChartConfig.
  ///
  /// If the chart is single-series, the legend maps each bucket -> value (useful
  /// for pie/category charts). If multi-series, the legend maps each seriesName -> INF
  /// sentinel (caller renders only the label).
  static Map<String, double> buildLegendMap(ChartConfig config) {
    final out = <String, double>{};

    if (config.isSingleSeries) {
      final series = config.seriesNames.first;
      for (final bucket in config.buckets) {
        final v = config.matrix[bucket]?[series] ?? 0.0;
        out[bucket] = v;
      }
    } else {
      for (final s in config.seriesNames) {
        out[s] = double.infinity;
      }
    }

    return out;
  }

  // --------------------
  // Helpers (private)
  // --------------------

  /// Return an ordered list from a set. If sort == true, returns alphabetically
  /// sorted (case-insensitive). If sort == false, preserves original insertion order.
  static List<String> _orderedListFrom(Set<String> set, bool sort) {
    final list = set.toList();

    if (sort) list.sort(_caseInsensitiveCompare);

    return list;
  }

  static int _caseInsensitiveCompare(String a, String b) {
    final al = a.toLowerCase();
    final bl = b.toLowerCase();
    final cmp = al.compareTo(bl);

    if (cmp != 0) return cmp;

    return a.compareTo(b);
  }

  static double _computeMaxY(ChartMatrix mtx) {
    double maxY = 0.0;

    for (final seriesMap in mtx.values) {
      for (final v in seriesMap.values) {
        if (v.isFinite) {
          maxY = math.max(maxY, v);
        }
      }
    }

    return maxY;
  }
}
