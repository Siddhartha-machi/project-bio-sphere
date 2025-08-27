// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoStep _$TodoStepFromJson(Map<String, dynamic> json) => TodoStep(
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$TodoStepToJson(TodoStep instance) => <String, dynamic>{
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };
