import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/i_data_model.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo extends IDataModel {
  final String title;
  final int priority;
  final bool isCompleted;
  final bool isRecurring;
  final DateTime? dueDate;
  final String? description;

  const Todo({
    this.dueDate,
    this.description,
    required super.id,
    this.priority = 1,
    required this.title,
    this.isCompleted = false,
    this.isRecurring = false,
  });

  // Auto-generated methods
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$TodoToJson(this);
}
