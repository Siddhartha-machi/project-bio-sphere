// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      postId: json['postId'] as String?,
      content: json['content'] as String,
      createdBy: User.fromJson(json['createdBy'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      repliesCount: (json['repliesCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      isDisLiked: json['isDisLiked'] as bool? ?? false,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      parentId: json['parentId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      parentAuthor: json['parentAuthor'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'createdBy': instance.createdBy,
      'postId': instance.postId,
      'isEdited': instance.isEdited,
      'likesCount': instance.likesCount,
      'isLiked': instance.isLiked,
      'content': instance.content,
      'isDisLiked': instance.isDisLiked,
      'parentId': instance.parentId,
      'repliesCount': instance.repliesCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'parentAuthor': instance.parentAuthor,
      'replies': instance.replies,
    };
