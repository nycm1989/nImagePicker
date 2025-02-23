import 'dart:io' as io show File;
import 'dart:math' show Random;
import 'package:http/http.dart' show Response;
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:path_provider/path_provider.dart' as pp show getTemporaryDirectory;

import 'package:n_image_picker/src/shared/helper.dart' show Helper;
import 'package:n_image_picker/src/domain/models/response_model.dart' show ResponseModel;
import 'package:n_image_picker/src/domain/interfaces/image_interface.dart' show ImageInterface;

ImageInterface getInstance() => ImageIoRepository();

class ImageIoRepository implements ImageInterface{

  @override
  Future<ResponseModel> setFile({
    required final Response response,
    final String? key,
    final Map<String, dynamic>? headers,
    final int? maxSize,
    ///[format] only works if [maxSize] is not null
    final String? extension,
  }) async {
    try{
      return ResponseModel(
        platformFile:
        PlatformFile(
          name  : Random().nextInt(10000).toString() + DateTime.now().millisecondsSinceEpoch.toString(),
          size  : response.contentLength??0,
          bytes : maxSize != null ? Helper().Rezize(bytes: response.bodyBytes, maxSize: maxSize, extension: extension??'') : response.bodyBytes
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
    required final String path,
    required final int? maxSize
  }) async {
    try{
      final String filename = Random().nextInt(10000).toString() + DateTime.now().millisecondsSinceEpoch.toString();
      final io.File file = io.File(path);

      final bytes = file.readAsBytesSync();

      return file.length().then((length)=>
        ResponseModel(
          platformFile:
          PlatformFile(
            name  : filename,
            size  : length,
            bytes : maxSize != null ? Helper().Rezize(bytes: bytes, maxSize: maxSize, extension: path.split(".").last) : bytes,
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
  remove(final PlatformFile file) => file.path != null ? io.File(file.path!).delete() : null;

  @override
  Future<PlatformFile> write({
    required final String     name,
    required final String     extension,
    required final Uint8List? bytes,
    ///[format] only works if [maxSize] is not null
    required final int?       maxSize,
  }) async {
    if(bytes == null){
      Exception("bytes cant be null");
      return PlatformFile(name: '', size: 0);
    } else{
      return await pp.getTemporaryDirectory().then((dir) async {
        io.File file = io.File(dir.path + "/" + name + "." + extension);
        return await file.writeAsBytes(bytes).then((_f) async =>
          _f.readAsBytes().then((_b){
            Uint8List? _rb = maxSize != null ? Helper().Rezize(bytes: _b, maxSize: maxSize, extension: extension) : null;
            return PlatformFile(
              name  : name + "." + extension,
              size  : maxSize != null ? _rb?.lengthInBytes??0 : _f.lengthSync(),
              path  : _f.path,
              bytes : maxSize != null ? _rb : _b
            );
          })
        );
      });
    }
  }
}