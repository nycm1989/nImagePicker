import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import './response_model.dart';
import 'dart:io' show File;

Future<ResponseModel> setFile(Response r, String n, String key, Map<String, dynamic> headers) async {
  try{
    final String filename = key + Random().nextInt(10000).toString() + DateTime.now().millisecondsSinceEpoch.toString();

    return await File('${filename}.${n.split('.').last}').writeAsBytes(r.bodyBytes).then((v) =>
      v.length().then((l)=>
        v.readAsBytes().then((b)=>
          ResponseModel(
            platformFile:
            PlatformFile(
              name  : filename,
              size  : l,
              bytes : b,
              path  : v.path
            ),
            error: false
          )
        )
      )
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
        bytes : i.bytes,
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