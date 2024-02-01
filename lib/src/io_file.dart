import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import './response_model.dart';
import 'dart:io' show File;

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

Future<ResponseModel> setFileFromPath(String p) async {
  try{
    final String filename = Random().nextInt(10000).toString() + DateTime.now().millisecondsSinceEpoch.toString();
    final dynamic file = File(p);

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

rm(PlatformFile file) => file.path != null ? File(file.path!).delete() : null;