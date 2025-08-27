// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartData _$ChartDataFromJson(Map<String, dynamic> json) => ChartData(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
      group: json['group'] as String,
    );

Map<String, dynamic> _$ChartDataToJson(ChartData instance) => <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'group': instance.group,
    };
