import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:n_image_picker/src/custom_file.dart';
import './response_model.dart';
import 'dart:io' as io show File;

CustomFile getInstance() => IoFile();

class IoFile implements CustomFile{

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
  Future<PlatformFile> w(Uint8List? bytes) async {
    if(bytes == null){
      Exception("bytes cant be null");
      return PlatformFile(name: '', size: 0);
    } else{
      return await io.File.fromRawPath(bytes).create().then((file) => PlatformFile(
        name: DateTime.now().millisecondsSinceEpoch.toString()+'.png',
        size: file.lengthSync(),
        path: file.path
      ));
    }
  }
}