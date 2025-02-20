import 'dart:js_interop' show JSAny, JSAnyOperatorExtension, JSArray, NumToJSExtension;
import 'dart:math' show Random;
import 'dart:async' show Future;
import 'dart:typed_data' show Uint8List;
import 'package:web/web.dart' as web show File;
import 'package:http/http.dart' show Response;
import 'package:file_picker/file_picker.dart' show PlatformFile;

import 'package:n_image_picker/src/shared/helper.dart' show Helper;
import 'package:n_image_picker/src/domain/models/response_model.dart' show ResponseModel;
import 'package:n_image_picker/src/domain/interfaces/image_interface.dart' show ImageInterface;

ImageInterface getInstance() => ImageWebRepository();

class ImageWebRepository implements ImageInterface{
  @override
  Future<ResponseModel> setFile({
    required final Response response,
    final String? key,
    final Map<String, dynamic>? headers,
    final int? maxSize,
    final String? extension,
  }) async {
    try{
      final String filename = key??'' + Random().nextInt(1000).toString()  + DateTime.now().millisecondsSinceEpoch.toString();
      final jsArray = JSArray<JSAny>();

      for(var byte in response.bodyBytes){
        jsArray.add(byte.toJS);
      }

      final web.File i = web.File(jsArray, key??'');

      return ResponseModel(
        platformFile: PlatformFile(
          name  : filename,
          size  : i.size,
          bytes : maxSize != null ? Helper().Rezize(bytes: response.bodyBytes, maxSize: maxSize, extension: extension??'') : response.bodyBytes,
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
    required final String     name,
    required final String     extension,
    required final Uint8List? bytes,
    required final int?       maxSize
  }) async =>
  PlatformFile(
    name  : DateTime.now().millisecondsSinceEpoch.toString() + name + "." + extension,
    size  : bytes?.length??0,
    bytes : maxSize != null ? bytes != null ? Helper().Rezize(bytes: bytes, maxSize: maxSize, extension: extension) : null : bytes
  );
}

// class _Observer {
//   static body(final GlobalKey widgetKey, {required final ImageController controller}){
//     context.callMethod('eval', ["""
//       let observer;
//       function observeBodySize(callback) {
//         const body = document.body;
//         observer = new ResizeObserver(entries => {
//           const entry = entries[0];
//           const { width, height } = entry.contentRect;
//           callback(width, height);
//         });
//         observer.observe(body);
//       }

//       function stopObservingBodySize() {
//         observer?.disconnect();
//       }
//     """]);

//     void onBodyResize(double width, double height) {
//       if(controller.screenSize.width != width || controller.screenSize.height != height) ImageInterface().updateDrop(widgetKey, controller: controller);
//       controller.changeScreenSize(screenSize: Size(width, height));
//     }

//     final Function resizeCallback = allowInterop(onBodyResize);
//     context.callMethod('observeBodySize', [resizeCallback]);
//   }
// }