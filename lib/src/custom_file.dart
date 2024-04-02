import './router_helper.dart' if (dart.library.html) './web_file.dart' if (dart.library.io) './io_file.dart';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:n_image_picker/src/response_model.dart';
import 'package:flutter/foundation.dart';


abstract class CustomFile{
  factory CustomFile() => getInstance();

  Future<ResponseModel> setFile({required final Response response, final String? key, final Map<String, dynamic>? headers}) async =>
  ResponseModel(
    platformFile : PlatformFile( name: '', size: 0 ),
    error        : false
  );

  Future<ResponseModel> setFileFromPath(String p) async =>
  ResponseModel(
    platformFile : PlatformFile( name: '', size: 0 ),
    error        : false
  );

  rm(PlatformFile file) => null;

  Future<PlatformFile> w(Uint8List? bytes) async => PlatformFile(name: '', size: 0);
}