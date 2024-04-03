import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:n_image_picker/src/platform_tools.dart';
import 'dart:io' as io show File;

import 'package:n_image_picker/src/response_model.dart';
import 'package:path_provider/path_provider.dart' as pp show getTemporaryDirectory;

PlatformTools getInstance() => IoFile();

class IoFile implements PlatformTools{

  @override
  Future<ResponseModel> setFile({required final Response response, final String? key, final Map<String, dynamic>? headers}) async {
    try{
      return ResponseModel(
        platformFile:
        PlatformFile(
          name  : Random().nextInt(10000).toString() + DateTime.now().millisecondsSinceEpoch.toString(),
          size  : response.contentLength??0,
          bytes : response.bodyBytes
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
  Future<ResponseModel> setFileFromPath(String p) async {
    try{
      final String filename = Random().nextInt(10000).toString() + DateTime.now().millisecondsSinceEpoch.toString();
      final dynamic file = io.File(p);

      return file.length().then((length)=>
        ResponseModel(
          platformFile:
          PlatformFile(
            name  : filename,
            size  : length,
            bytes : file.bytes,
            path  : file.path
          ),
          error: false
        )
      );

    } catch (e){
      return ResponseModel(
        platformFile: PlatformFile(name: '', size: 0),
        error       : true
      );
    }
  }

  @override
  rm(PlatformFile file) => file.path != null ? io.File(file.path!).delete() : null;

  @override
  Future<PlatformFile> w({
    required String     name,
    required String     extension,
    required Uint8List? bytes
  }) async {
    if(bytes == null){
      Exception("bytes cant be null");
      return PlatformFile(name: '', size: 0);
    } else{
      return await pp.getTemporaryDirectory().then((dir) async {
        io.File file = io.File(dir.path + "/" + name + "." + extension);
        return await file.writeAsBytes(bytes).then((_f) async =>
          _f.readAsBytes().then((_b) => PlatformFile(
            name: name + "." + extension,
            size: _f.lengthSync(),
            path: _f.path,
            bytes: _b
          ))
        );
      });
      // return await io.File.fromRawPath(bytes).create().then((file) => PlatformFile(
      //   name: DateTime.now().millisecondsSinceEpoch.toString() + name + "." + extension,
      //   size: file.lengthSync(),
      //   path: file.path
      // ));
    }
  }
}