import './platform/router.dart' if (dart.library.html) './platform/html.dart' if (dart.library.io) './platform/io.dart';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:n_image_picker/src/response_model.dart';
import 'package:flutter/foundation.dart';


abstract class PlatformTools{
  factory PlatformTools() => getInstance();

  Future<ResponseModel> setFile({required final Response response, final Map<String, dynamic>? headers}) async =>
  ResponseModel(
    platformFile : PlatformFile( name: '', size: 0 ),
    error        : false
  );

  Future<ResponseModel> setFileFromPath(String path) async =>
  ResponseModel(
    platformFile : PlatformFile( name: '', size: 0 ),
    error        : false
  );

  rm(PlatformFile file) => null;

  Future<PlatformFile> w({
    required String     name,
    required String     extension,
    required Uint8List? bytes
  }) async => PlatformFile(name: '', size: 0);
}