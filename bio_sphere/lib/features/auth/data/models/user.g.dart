// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      dateJoined: DateTime.parse(json['dateJoined'] as String),
      lastActiveOn: DateTime.parse(json['lastActiveOn'] as String),
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']) ?? Role.user,
      profilePictureURL: json['profilePictureURL'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'role': _$RoleEnumMap[instance.role]!,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'dateJoined': instance.dateJoined.toIso8601String(),
      'lastActiveOn': instance.lastActiveOn.toIso8601String(),
      'profilePictureURL': instance.profilePictureURL,
      'bio': instance.bio,
    };

const _$RoleEnumMap = {
  Role.user: 'user',
  Role.admin: 'admin',
};
