import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/i_data_model.dart';

part 'todo_step.g.dart';

@JsonSerializable()
class TodoStep extends IDataModel {
  const TodoStep({
    required super.id,
    required this.title,
    this.isCompleted = false,
  });

  final String title;
  final bool isCompleted;

  // Auto-generated methods
  factory TodoStep.fromJson(Map<String, dynamic> json) =>
      _$TodoStepFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$TodoStepToJson(this);
}
