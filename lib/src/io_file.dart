import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import './response_model.dart';
import 'dart:io' show File;

Future<ResponseModel> setFile(Response r, String n, String key, Map<String, dynamic> headers) async {
  try{
    final String filename = key + Random().nextInt(10000).toString() + DateTime.now().millisecondsSinceEpoch.toString();

    final dynamic i = await File('${filename}.${n.split('.').last}').writeAsBytes(r.bodyBytes);

    return ResponseModel(
      platformFile:
      PlatformFile(
        name  : filename,
        size  : await i.length(),
        bytes : null,
        path  : i.path
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
    final dynamic i = await File(p);

    return ResponseModel(
      platformFile:
      PlatformFile(
        name  : filename,
        size  : await i.length(),
        bytes : null,
        path  : i.path
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

rm(PlatformFile file) => file.path != null ? File(file.path!).delete() : null;