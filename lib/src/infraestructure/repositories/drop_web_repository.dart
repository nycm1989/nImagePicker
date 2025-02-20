import 'package:flutter/material.dart';
import 'package:n_image_picker/src/domain/interfaces/drop_interface.dart';
import 'package:n_image_picker/src/presentation/image_controller.dart';

import 'dart:async' show Completer, Future;
import 'dart:typed_data' show ByteBuffer, Uint8List;
import 'package:web/web.dart' as web show DragEvent, ElementEventGetters, File, FileReader, FileReaderEventGEtters, HTMLElement, document;

DropInterface getInstance() => DropWebRepository();

class DropWebRepository implements DropInterface{
  @override
  Future<void> dragAndDrop({required final ImageController controller, Function()? onAdd}) async {
    final div = web.document.body?.getElementsByClassName(controller.className).item(0) as web.HTMLElement;
    div
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

          await completer.future.then((data) {
            controller.setFromBytes(
              name      : file.name,
              extension : file.name.split(".").last,
              bytes     : data,
              onAdd     : onAdd,
            );
          });
        } else {
          controller.reset(error: true);
          debugPrint("Format not supported [${controller.fileTypes.join(", ")}]");
        }
      }
    });
  }

  @protected
  String _style(Offset position, Size size, {bool hidden = false})  =>
  "display: ${hidden ? "none" : "block"};"
  "position: absolute;"
  "left: ${position.dx}px;"
  "top: ${position.dy}px;"
  "width: ${size.width}px;"
  "height: ${(size.height/2) - 20}px;"
  "z-index: ${hidden ? "-1" : "1000"};";
  // "border: 5px solid red;";
  // "background-color: rgba(0, 0, 0, 0.7); ";
  // "mask: inset(30% 10% 30% 10%); "
  // "-webkit-mask: inset(30% 10% 30% 10%); ";

  @override
  void createDrop({required final RenderBox renderBox, required final ImageController controller}) {
    // _Observer.body(widgetKey, controller: controller);

    final _divs = web.document.body?.getElementsByClassName(controller.className); //.item(0) as web.HTMLElement?;
    bool _create = true;
    if(_divs!.length > 0) if((_divs.item(0) as web.HTMLElement?) != null) _create = false;

    if(_create){
      final div = web.document.createElement('div');
      div ..setAttribute("class", controller.className) ..setAttribute("style", _style(renderBox.localToGlobal(Offset.zero), renderBox.size));
      web.document.body?.append(div);
    } else {
      updateDrop(renderBox: renderBox, controller: controller);
    }
  }

  @override
  void updateDrop({required final RenderBox renderBox, required final ImageController controller}) {
    final web.HTMLElement? div = web.document.body?.getElementsByClassName(controller.className).item(0) as web.HTMLElement?;
    if(div != null) {
      div ..removeAttribute("style") ..setAttribute("style", _style(renderBox.localToGlobal(Offset.zero), renderBox.size));
    }
  }

  @override
  void removeDrop({required final ImageController controller}) {
    final div = web.document.body?.getElementsByClassName(controller.className).item(0) as web.HTMLElement?;
    if(div != null){
      div.style.display = "hidden";
      div.remove();
    }
  }

  @override
  void hideDrop() {
    for(var element in web.document.querySelectorAll('[class^="nImageDiv_"]') as List<web.HTMLElement?>){
      if(element != null){
        element.style.display = "hidden";
        element.style.zIndex = "-1";
      }
    }
  }

  @override
  void showDrop() {
    for(var element in web.document.querySelectorAll('[class^="nImageDiv_"]') as List<web.HTMLElement?>){
      if(element != null){
        element.style.display = "block";
        element.style.zIndex = "1000";
      }
    }
  }
}