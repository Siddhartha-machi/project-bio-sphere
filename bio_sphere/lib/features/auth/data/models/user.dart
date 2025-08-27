import 'package:json_annotation/json_annotation.dart';

import 'package:bio_sphere/models/interfaces/api_data_model.dart';
import 'package:bio_sphere/features/auth/constants/auth_enums.dart';
import 'package:bio_sphere/features/auth/data/models/user_preferences.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends APIDataModel {
  final String id;
  final Role role;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final DateTime dateJoined;
  final DateTime lastActiveOn;

  @JsonKey(includeFromJson: false)
  final String? password;
  final String? profilePictureURL;
  final String? bio;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.dateJoined,
    required this.lastActiveOn,
    this.role = Role.user,
    this.password,
    this.profilePictureURL,
    this.bio,
  }) : preferences = const UserPreferences();

  // Auto-generated methods
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> get toJson => _$UserToJson(this);
}
