// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      description: json['description'] as String?,
      id: json['id'] as String,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isRecurring: json['isRecurring'] as bool? ?? false,
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'priority': instance.priority,
      'isCompleted': instance.isCompleted,
      'isRecurring': instance.isRecurring,
      'dueDate': instance.dueDate?.toIso8601String(),
      'description': instance.description,
    };
