import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/data/comment.dart';
import 'package:bio_sphere/models/data/attachment.dart';
import 'package:bio_sphere/models/interfaces/api_data_model.dart';
import 'package:bio_sphere/features/extensions/todos/models/todo.dart';
import 'package:bio_sphere/features/extensions/todos/models/todo_step.dart';

part 'todo_detail.g.dart';

@JsonSerializable()
class TodoDetail extends APIDataModel {
  const TodoDetail({
    this.tags,
    this.notes,
    this.location,
    this.comments,
    this.category,
    this.assignedTo,
    this.attachments,
    this.completedAt,
    required this.info,
    this.steps = const [],
    this.recurrencePattern,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  @JsonKey(fromJson: _todoFromJson, toJson: _todoToJson)
  final Todo info;
  @JsonKey(fromJson: _todoStepFromJson, toJson: _todoStepToJson)
  final List<TodoStep> steps;
  final List<String>? tags;
  final String? category;
  final String? assignedTo;
  final String? location;
  final String? notes;
  final DateTime? completedAt;
  final List<Comment>? comments;
  final String? recurrencePattern;
  final List<Attachment>? attachments;

  // Auto-generated methods
  factory TodoDetail.fromJson(Map<String, dynamic> json) =>
      _$TodoDetailFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$TodoDetailToJson(this);

  // Custom deserialization function for `Todo`
  static Todo _todoFromJson(Map<String, dynamic> json) {
    return Todo.fromJson(json);
  }

  static Map<String, dynamic> _todoToJson(Todo todo) {
    return todo.toJson;
  }

  // Custom deserialization function for `Todo`
  static List<TodoStep> _todoStepFromJson(List<Map<String, dynamic>> json) {
    return json.map((e) => TodoStep.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> _todoStepToJson(List<TodoStep> steps) {
    return steps.map((step) => step.toJson).toList();
  }
}
