abstract class BaseDataModel {
  const BaseDataModel();

  /// Converts the model to a minimal JSON representation.
  Map<String, dynamic> get toMinJson;

  /// Converts the model to a full JSON representation.
  Map<String, dynamic> get toJson;

  /// Creates a model instance from a JSON map.
  static BaseDataModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJSON() must be implemented in the subclass');
  }
}
