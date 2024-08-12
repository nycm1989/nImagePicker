import 'package:flutter/material.dart';

import './router.dart' if (dart.library.html) './html.dart' if (dart.library.io) './io.dart';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:n_image_picker/src/response_model.dart';
import 'package:flutter/foundation.dart';


abstract class PlatformTools{
  factory PlatformTools() => getInstance();

  Future<ResponseModel> setFile({
    required final Response response,
    final Map<String, dynamic>? headers,
    required int? maxSize,
    ///[format] only works if [maxSize] is not null
    required String? extension
  }) async =>
  ResponseModel(
    platformFile : PlatformFile( name: '', size: 0 ),
    error        : false
  );

  Future<ResponseModel> setFileFromPath({
    required String path,
    required int? maxSize
  }) async =>
  ResponseModel(
    platformFile : PlatformFile( name: '', size: 0 ),
    error        : false
  );

  remove(PlatformFile file) => null;

  Future<PlatformFile> write({
    required String     name,
    required String     extension,
    required Uint8List? bytes,
    required int?       maxSize,
  }) async => PlatformFile(name: '', size: 0);

  Size getSize({required Uint8List? bytes}) => Size(0, 0);
}