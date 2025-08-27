abstract class APIDataModel {
  const APIDataModel();

  /// Converts the model to a full JSON representation.
  Map<String, dynamic> get toJson;

  /// Creates a model instance from a JSON map.
  static APIDataModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJSON() must be implemented in the subclass');
  }
}
