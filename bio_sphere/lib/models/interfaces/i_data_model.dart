import 'package:isar/isar.dart';

abstract class IDataModel {
  final String id;
  /// Primary key used for DB schema
  final Id pk = Isar.autoIncrement;

  const IDataModel({required this.id});

  /// Converts the model to a full JSON representation.
  Map<String, dynamic> toJson();

  /// Creates a model instance from a JSON map.
  static IDataModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJSON() must be implemented in the subclass');
  }
}
