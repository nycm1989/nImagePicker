import 'package:file_picker/file_picker.dart' show PlatformFile;

class ResponseModel{
  final PlatformFile platformFile;
  final bool error;

  ResponseModel({
    required this.platformFile,
    required this.error,
  });
}