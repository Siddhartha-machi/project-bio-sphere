// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoDetail _$TodoDetailFromJson(Map<String, dynamic> json) => TodoDetail(
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'] as String?,
      assignedTo: json['assignedTo'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      info: TodoDetail._todoFromJson(json['info'] as Map<String, dynamic>),
      steps: json['steps'] == null
          ? const []
          : TodoDetail._todoStepFromJson(
              json['steps'] as List<Map<String, dynamic>>),
      recurrencePattern: json['recurrencePattern'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$TodoDetailToJson(TodoDetail instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'info': TodoDetail._todoToJson(instance.info),
      'steps': TodoDetail._todoStepToJson(instance.steps),
      'tags': instance.tags,
      'category': instance.category,
      'assignedTo': instance.assignedTo,
      'location': instance.location,
      'notes': instance.notes,
      'completedAt': instance.completedAt?.toIso8601String(),
      'comments': instance.comments,
      'recurrencePattern': instance.recurrencePattern,
      'attachments': instance.attachments,
    };
