import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/api_data_model.dart';

part 'todo_step.g.dart';

@JsonSerializable()
class TodoStep implements APIDataModel {
  const TodoStep({required this.title, this.isCompleted = false});

  final String title;
  final bool isCompleted;

  // Auto-generated methods
  factory TodoStep.fromJson(Map<String, dynamic> json) =>
      _$TodoStepFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$TodoStepToJson(this);
}
