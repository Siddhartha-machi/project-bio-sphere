// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoStep _$TodoStepFromJson(Map<String, dynamic> json) => TodoStep(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TodoStepToJson(TodoStep instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };
