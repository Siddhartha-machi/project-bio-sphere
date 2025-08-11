import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// File service models
class PickedFile {
  final File file;
  final PlatformFile config;
  final String error;

  PickedFile({this.error = '', required this.file, required this.config});
}
