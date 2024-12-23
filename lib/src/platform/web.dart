import 'package:flutter/material.dart';

import 'dart:js_interop' show JSAny, JSAnyOperatorExtension, JSArray, NumToJSExtension;
import 'dart:math' show Random;
import 'dart:async' show Completer, Future;
import 'dart:typed_data' show ByteBuffer, Uint8List;
import 'package:web/web.dart' as web show DragEvent, ElementEventGetters, File, FileReader, FileReaderEventGEtters, HTMLElement, document;
import 'package:http/http.dart' show Response;
import 'package:file_picker/file_picker.dart' show PlatformFile;

import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/platform/tools.dart' show PlatformTools;
import 'package:n_image_picker/src/response_model.dart' show ResponseModel;
import 'package:n_image_picker/src/platform/helpers.dart' show Helpers;
// import 'dart:js' as js;

PlatformTools getInstance() => WebFile();

class WebFile implements PlatformTools{
  @override
  Future<ResponseModel> setFile({
    required final Response response,
    final String? key,
    final Map<String, dynamic>? headers,
    required final int? maxSize,
    required final String? extension,
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
    required final String     name,
    required final String     extension,
    required final Uint8List? bytes,
    required final int?       maxSize
  }) async =>
  PlatformFile(
    name  : DateTime.now().millisecondsSinceEpoch.toString() + name + "." + extension,
    size  : bytes?.length??0,
    bytes : maxSize != null ? bytes != null ? Helpers().Rezize(bytes: bytes, maxSize: maxSize, extension: extension) : null : bytes
  );

  @override
  void dragAndDrop({required final ImageController controller, required final String className}) async {
    final body = web.document.body?.getElementsByClassName(className).item(0) as web.HTMLElement;

    // ..onDragEnter.listen((event) {
    //   event.preventDefault();
    //   controller.changeOnDragState(true);
    // })
    // ..onDragOver.listen((event) {
    //   event.preventDefault();
    //   controller.changeOnDragState(false);
    // })
    body
    ..onDragOver.listen((event) => event.preventDefault() )
    ..onDrop.listen((event) async {
      event.preventDefault();
      // body.style.pointerEvents = "none";
      web.File? file = (event as web.DragEvent).dataTransfer?.files.item(0);
      if (file != null){
        if(controller.fileTypes.contains(file.name.split(".").last)){
          final Completer<Uint8List> completer = Completer<Uint8List>();
          final web.FileReader reader = web.FileReader();

          reader
          ..onLoadEnd
            .listen((event) {
              if (reader.result != null && reader.result is ByteBuffer) {
                completer.complete((reader.result as ByteBuffer).asUint8List());
              }
            })
            .onError((event) { null; })
          ..readAsArrayBuffer(file);

          await completer.future.then((data) =>
            controller.setFromBytes(
              name      : file.name,
              extension : file.name.split(".").last,
              bytes     : data
            )
          );
        }
      }
    });
  }

  @override
  void createDiv(final GlobalKey widgetKey, {required final String className}) {
    final div = web.document.createElement('div');
    final RenderBox renderObject = widgetKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    div
    ..setAttribute("class", className)
    ..setAttribute("style", style(position, size));
    web.document.body?.append(div);
  }

  @override
  void updateDiv(final GlobalKey widgetKey, {required final String className}) {
    final div = web.document.createElement('div');
    final RenderBox renderObject = widgetKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    div
    ..removeAttribute("style")
    ..setAttribute("style", style(position, size));
  }

  String style(Offset position, Size size)  =>
  "position: absolute; "
  "left: ${position.dx}px; "
  "top: ${position.dy}px; "
  "width: ${size.width}px; "
  "height: ${size.height/2}px; ";
  // "mask: inset(30% 10% 30% 10%); "
  // "-webkit-mask: inset(30% 10% 30% 10%); "

  @override
  void removeDiv({required final String className}) {
    try{
      final div = web.document.body?.getElementsByClassName(className).item(0) as web.HTMLElement;
      div.remove();
    }catch(e){ null; }
  }

}