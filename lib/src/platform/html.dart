import 'dart:html' as html;
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:n_image_picker/src/platform/helpers.dart';
import 'package:n_image_picker/src/platform/tools.dart';
import 'package:n_image_picker/src/response_model.dart';
// import 'dart:js' as js;

PlatformTools getInstance() => WebFile();

class WebFile implements PlatformTools{
  @override
  Future<ResponseModel> setFile({
    required final Response response,
    final String? key,
    final Map<String, dynamic>? headers,
    required int? maxSize,
    required String? extension,
  }) async {
    try{
      final String filename = key??'' + Random().nextInt(1000).toString()  + DateTime.now().millisecondsSinceEpoch.toString();

      final html.File i = html.File( response.bodyBytes, key??'', headers);

      return ResponseModel(
        platformFile: PlatformFile(
          name  : filename,
          size  : i.size,
          bytes : maxSize != null ? Helpers().Rezize(bytes: response.bodyBytes, maxSize: maxSize, extension: extension??'') : response.bodyBytes,
          path  : null
        ),
        error: false
      );
    } catch (e){
      return ResponseModel(
        platformFile: PlatformFile(name: '', size: 0),
        error       : true
      );
    }
  }

  @override
  Future<ResponseModel> setFileFromPath({
    required String path,
    required int? maxSize
  }) async =>
  ResponseModel(
    platformFile : PlatformFile( name: '', size: 0 ),
    error        : false
  );

  @override
  remove(PlatformFile file) => null;

  @override
  Future<PlatformFile> write({
    required String     name,
    required String     extension,
    required Uint8List? bytes,
    required int?       maxSize
  }) async =>
  PlatformFile(
    name  : DateTime.now().millisecondsSinceEpoch.toString() + name + "." + extension,
    size  : bytes?.length??0,
    bytes : maxSize != null ? bytes != null ? Helpers().Rezize(bytes: bytes, maxSize: maxSize, extension: extension) : null : bytes
  );

  @override
  Size getSize({required Uint8List? bytes}) => Size(0, 0);
}