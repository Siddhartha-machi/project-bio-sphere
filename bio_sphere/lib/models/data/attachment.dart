import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/i_data_model.dart';

part 'attachment.g.dart';

@JsonSerializable()
class Attachment extends IDataModel {
  const Attachment({
    required super.id,
    required this.url,
    required this.name,
    required this.size,
    required this.uploadDate,
  });

  final String url;
  final String name;
  final double size;
  final DateTime uploadDate;

  // Auto-generated methods
  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$AttachmentToJson(this);
}
