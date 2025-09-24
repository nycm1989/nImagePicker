import 'dart:async' show Completer;
import 'dart:typed_data' show ByteBuffer, Uint8List;
import 'package:web/web.dart' as web show DragEvent, ElementEventGetters, File, FileReader, FileReaderEventGEtters, HTMLElement, document;
import 'package:flutter/material.dart' show Size, Offset;
import 'package:flutter/src/rendering/box.dart' show RenderBox;
import 'package:n_image_picker/n_image_picker.dart' show ImageController;

import 'package:n_image_picker/src/domain/ports/platform_port.dart' show PlatformPort;
import 'package:n_image_picker/src/domain/enums.dart/accepted_formats.dart' show AcceptedFormats;

/// Adapter implementation of [PlatformPort] for HTML platform using web APIs.
/// This class handles drag-and-drop image loading functionality in a web environment.
PlatformPort getInstance() => PlatformHTMLAdapter();

class PlatformHTMLAdapter implements PlatformPort{

  /// Indicates that this platform does not require a file path to access image bytes.
  @override
  bool requirePath() => false;

  /// Getting bytes from a path is not implemented for HTML platform.
  @override
  Uint8List getBytesFromPath(String path) =>
    throw UnimplementedError();

  /// Attaches drag-and-drop listeners to the body element to detect drag events globally.
  ///
  /// It manages the drag enter/leave events and updates the drag state in the [ImageController].
  /// Also shows or hides the drop zone UI accordingly.
  @override
  void attachDropBody({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode
  }) {
    int _dragCounter = 0;
    web.HTMLElement? body = web.document.body;
    if(body != null){
      body
      ..onDragEnter.listen((event) {
        _dragCounter++;
        /// Show the drop zone UI when drag enters the body.
        showDropZone(
          renderBox : renderBox,
          hashCode  : hashCode
        );
        controller.changeOnDragState(true);
      })
      ..onDragLeave.listen((event) {
        _dragCounter--;
        /// Hide the drop zone UI and reset drag state when drag leaves completely.
        if (_dragCounter <= 0) {
          hideDropZone(hashCode: hashCode);
          controller.changeOnDragState(false);
          _dragCounter = 0;
        }
      })
      ..onDrop.listen((event) async {
        event.preventDefault();
        _dragCounter = 0;
        /// Hide drop zone and reset drag state on drop.
        hideDropZone(hashCode: hashCode);
        controller.changeOnDragState(false);
      });
    }
  }

  /// Attaches drag-and-drop event listeners to a specific drop zone element identified by [hashCode].
  ///
  /// Handles file drop events, validates accepted formats, reads file bytes,
  /// and updates the [ImageController] accordingly.
  @override
  void attachDropZone({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode,
  }) {
    web.HTMLElement? div = web.document.body?.getElementsByClassName(hashCode.toString()).item(0) as web.HTMLElement?;
    if(div == null) {
      div = web.document.createElement('div') as web.HTMLElement;
      web.document.body?.append(div);

      div
      ..setAttribute("class", hashCode.toString())
      // ..setAttribute("style", _style(renderBox.localToGlobal(Offset.zero), renderBox.size))
      ..onDragOver.listen((event) => event.preventDefault() )
      ..onDrop.listen((event) async {
        event.preventDefault();

        /// Indicate loading state in the controller while processing the dropped file.
        controller.startLoading();

        web.File? file = (event as web.DragEvent).dataTransfer?.files.item(0);

        if (file != null){
          /// Check if the file extension is in the accepted formats.
          if(AcceptedFormats.values.indexWhere((e) => e.name == file.name.split(".").last.trim().toLowerCase()) != -1){
            final Completer<Uint8List> completer = Completer<Uint8List>();
            final web.FileReader reader = web.FileReader();

            /// Read the file as an array buffer and complete the completer with the bytes.
            reader
            ..onLoadEnd
              .listen((event) {
                if (reader.result != null && reader.result is ByteBuffer) {
                  completer.complete((reader.result as ByteBuffer).asUint8List());
                }
              })
              .onError((event) { null; })
            ..readAsArrayBuffer(file);

            /// Once reading is complete, update the controller with the image data.
            await completer.future.then((data) async =>
              await controller.fromUint8List(
                bytes : data,
                name  : file.name,
              )
              .then((_) async =>
                controller ..changeOnErrorState(false) ..stopLoading()
              )
            );
          }
        }
      });
    }
  }

  /// Removes the drop zone element identified by [hashCode] from the DOM.
  @override
  void removeDropZone({
    required final int hashCode,
  }) {
    final div = web.document.body?.getElementsByClassName(hashCode.toString()).item(0) as web.HTMLElement?;
    if(div != null){
      div.style.display = "hidden";
      div.remove();
    }
  }

  /// Generates the CSS style string for positioning the drop zone element.
  ///
  /// Positions the element absolutely at [position] with the given [size].
  String _style(Offset position, Size size)  =>
  "position: absolute;"
  "left: ${position.dx}px;"
  "top: ${position.dy}px;"
  "width: ${size.width}px;"
  "height: ${size.height}px;"
  "display: block;"
  "zIndex: 1000;";

  /// Hides the drop zone by removing the inline style attribute from the element.
  ///
  /// This effectively disables the visible drop zone UI.
  @override
  void hideDropZone({
    required final int hashCode,
  }) {
    final div = web.document.body?.getElementsByClassName(hashCode.toString()).item(0) as web.HTMLElement?;
    if(div != null) div.removeAttribute("style");
  }

  /// Shows the drop zone by applying the calculated style to position and size the element.
  @override
  void showDropZone({
    required final RenderBox renderBox,
    required int hashCode
  }) {
    final div = web.document.body?.getElementsByClassName(hashCode.toString()).item(0) as web.HTMLElement?;
    if(div != null) div.setAttribute("style", _style(renderBox.localToGlobal(Offset.zero), renderBox.size));
  }

}