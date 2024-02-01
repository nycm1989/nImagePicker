import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import './response_model.dart';
import 'dart:html' as html;

Future<ResponseModel> setFile({required final Response response, required final String key, required final Map<String, dynamic> headers}) async {
  try{
    final String filename = key + Random().nextInt(1000).toString()  + DateTime.now().millisecondsSinceEpoch.toString();

    final dynamic i = html.File( response.bodyBytes, key, headers);

    return ResponseModel(
      platformFile: PlatformFile(
        name  : filename,
        size  : i.size,
        bytes : response.bodyBytes,
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
