import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import './response_model.dart';
import 'dart:io' show File;

Future<ResponseModel> setFile(Response r, String n, String key, Map<String, dynamic> headers) async {
  try{
    // html.Client
    final dynamic i = await File('${key}.${n.split('.').last}').writeAsBytes(r.bodyBytes);

    return ResponseModel(
      platformFile: PlatformFile(
        name  : key,
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