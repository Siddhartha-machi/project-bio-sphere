import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/api_data_model.dart';

part 'attachment.g.dart';

@JsonSerializable()
class Attachment implements APIDataModel {
  const Attachment({
    required this.id,
    required this.url,
    required this.name,
    required this.size,
    required this.uploadDate,
  });

  final String id;
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
