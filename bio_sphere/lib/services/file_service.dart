import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/models/service_models/file_service_models.dart';

class FileService {
  /// Default file sized allowed is 1MB
  static const int _defaultMaxFileSizeInBytes = 2048576;

  static List<String> _allowedExtensions(List<String> extns) {
    return extns.isEmpty
        ? [
            'png',
            'jpeg',
            'jpg',
            'pdf',
            'doc',
            'docx',
            'xls',
            'xlsx',
            'ppt',
            'pptx',
            'json',
          ]
        : extns;
  }

  static String _isFileValid(
    PlatformFile file,
    int mSize,
    List<String> aExtns,
  ) {
    if (file.size > mSize) {
      return 'Selected file ${file.name} did not comply with allowed size of ${Global.formatters.unit.bytes(mSize)}';
    }
    if (!_allowedExtensions(aExtns).contains(file.extension)) {
      return 'Unsupported format file was selected, choose from ${aExtns.join(' , ')}';
    }
    return '';
  }

  static Future<PickedFile?> pickSingle({
    int maxFileSizeInBytes = _defaultMaxFileSizeInBytes,
    List<String> allowedFileExtensions = const [],
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: _allowedExtensions(allowedFileExtensions),
      type: FileType.custom,
    );

    if (result != null) {
      final file = result.files.first;
      if (file.path != null) {
        return PickedFile(
          file: File(file.path!),
          config: file,
          error: _isFileValid(file, maxFileSizeInBytes, allowedFileExtensions),
        );
      }
    }

    return null;
  }

  static Future<List<PickedFile>> pickMultiple({
    int maxFileSizeInBytes = _defaultMaxFileSizeInBytes,
    List<String> allowedFileExtensions = const [],
  }) async {
    List<PickedFile> selectedFiles = [];

    final allowedExtns = _allowedExtensions(allowedFileExtensions);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: allowedExtns,
      type: FileType.custom,
    );

    if (result != null) {
      for (final file in result.files) {
        if (file.path != null) {
          selectedFiles.add(
            PickedFile(
              config: file,
              file: File(file.path!),
              error: _isFileValid(file, maxFileSizeInBytes, allowedExtns),
            ),
          );
        }
      }
    }

    return selectedFiles;
  }

  static Future<PickedFile?> pickImage({
    int maxFileSizeInBytes = _defaultMaxFileSizeInBytes,
  }) {
    return pickSingle(
      maxFileSizeInBytes: maxFileSizeInBytes,
      allowedFileExtensions: ['png', 'jpg', 'jpeg'],
    );
  }

  static Future<PickedFile?> pickDocument({
    int maxFileSizeInBytes = _defaultMaxFileSizeInBytes,
  }) {
    return pickSingle(
      maxFileSizeInBytes: maxFileSizeInBytes,
      allowedFileExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
      ],
    );
  }

  static Future<PickedFile?> pickJsonFile({
    int maxFileSizeInBytes = _defaultMaxFileSizeInBytes,
  }) {
    return pickSingle(
      maxFileSizeInBytes: maxFileSizeInBytes,
      allowedFileExtensions: ['json'],
    );
  }
}
