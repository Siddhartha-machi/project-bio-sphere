import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/features/auth/data/models/user.dart';
import 'package:bio_sphere/models/interfaces/api_data_model.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment extends APIDataModel {
  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    this.likesCount = 0,
    this.repliesCount = 0,
    this.isLiked = false,
    this.isEdited = false,
    this.isDisLiked = false,
    this.replies = const [],
    this.parentId,
    this.updatedAt,
    this.parentAuthor,
  });

  final String id;
  final User createdBy;
  final String? postId;
  final bool isEdited;
  final int likesCount;
  final bool isLiked;
  final String content;
  final bool isDisLiked;
  final String? parentId;
  final int repliesCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? parentAuthor;
  final List<Comment> replies;

  // Auto-generated methods
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$CommentToJson(this);
}
