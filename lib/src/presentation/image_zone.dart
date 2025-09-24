import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' show MultipartFile;
import 'package:flutter/foundation.dart' show ChangeNotifier, Uint8List, kIsWasm, kIsWeb;
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;

import 'package:n_image_picker/src/domain/dtos/data_dto.dart' show DataDTO;
import 'package:n_image_picker/src/domain/ports/platform_port.dart' show PlatformPort;
import 'package:n_image_picker/src/presentation/image_preview.dart' show showImagePreview;
import 'package:n_image_picker/src/domain/enums.dart/accepted_formats.dart' show AcceptedFormats;
import 'package:n_image_picker/src/application/use_cases/image_use_case.dart' show ImageUseCase;

/// Controller class for managing image data and state.
/// Uses [ChangeNotifier] to notify listeners of state changes.
class ImageController with ChangeNotifier {
  final ImageUseCase _useCase  = ImageUseCase();
  StreamController<bool>? stream;

  /// [WEB] Indicates if there was an error loading or processing the image.
  bool onError = false;

  /// Indicates if a drag operation is currently active.
  bool onDrag = false;

  String                _key;
  int                 ? _maxSize;
  DataDTO             ? _imageData;
  Map<String, String> ? _headers;

  /// Returns the bytes of the current image, if any.
  Uint8List? get bytes => _imageData?.bytes;

  /// Returns the multipart file representation of the image, if any.
  MultipartFile? get multipartFile => _imageData?.multipartFile;

  /// Returns the name of the image file, if any.
  String? get name => _imageData?.name;

  /// Returns the file extension of the image, if any.
  String? get extension => _imageData?.extension;

  /// Returns the size of the image, if any.
  Size? get size => _imageData?.size;

  /// Returns true if there is an image loaded.
  bool get hasImage => _imageData == null ? true : _imageData!.bytes.isEmpty;

  /// Returns true if there is no image loaded.
  bool get hasNoImage => !hasImage;


  /// Creates an [ImageController] with optional [key] and [maxSize] parameters.
  ImageController({
    String key = "image",
    int?   maxSize
  }) :
  _key = key,
  _maxSize = maxSize;


  /// Updates the key used for image data.
  void updateKey(String key) => _key = key;

  /// Updates the maximum allowed size for the image.
  void updateMaxSize(int maxSize) => _maxSize = maxSize;

  /// Updates the HTTP headers used for image requests.
  void updateHeaders(Map<String, String> headers) => _headers = headers;

  /// Starts the loading process and notifies listeners.
  void startLoading() {
    if(stream != null) stream = null;
    stream = StreamController<bool>();
    stream?.add(true);
    notifyListeners();
  }

  /// Stops the loading process and notifies listeners.
  void stopLoading() {
    stream?.close();
    stream = null;
    notifyListeners();
  }

  /// Loads an image from a given [path] asynchronously.
  /// Uses [_useCase.getOnloadingImage] and updates internal state.
  Future<void> getOnloadingImage({
    required final String path,
  }) async {
    startLoading();
    return await _useCase
    .getOnloadingImage(
      path    : path,
      headers : _headers,
      maxSize : _maxSize,
      key     : _key,
    )
    .then(_setData)
    .onError(_setError)
    .whenComplete(() => stopLoading() );
  }

  /// Opens a file picker to select an image, then processes and stores it.
  Future<void> pickImage() async =>
  await FilePicker.platform.pickFiles(
    type              : FileType.custom,
    allowedExtensions : AcceptedFormats.values.map((e) => e.name).toList(),
    allowMultiple     : false,
    withData          : !PlatformPort().requirePath(),
  )
  .then((pick) async {
    if(pick != null){
      if(pick.files.isNotEmpty) {
        startLoading();
        await _useCase
        .createDataFromPlatformFile(
          key     : _key,
          file    : pick.files.first,
          maxSize : _maxSize,
        )
        .then(_setData)
        .onError(_setError)
        .whenComplete(() => stopLoading() );
      }
    }
  });


  /// Shows a preview of the current image using [showImagePreview].
  /// Allows customization of the preview dialog appearance.
  void preview( final BuildContext context, {
    final double        ? sigma,
    final bool          ? barrierDismissible,
    final Object        ? tag,
    final Color         ? barrierColor,
    final Widget        ? closeButton,
    final BoxDecoration ? decoration
  }) => showImagePreview(
    context,
    bytes               : _imageData?.bytes == null ? null : Uint8List.fromList(_imageData!.bytes),
    sigma               : sigma ?? 4,
    barrierDismissible  : barrierDismissible??false,
    tag                 : tag,
    barrierColor        : barrierColor,
    closeButton         : closeButton,
    decoration          : decoration
  );


  /// Removes the currently loaded image and resets error state.
  void removeImage() {
    _imageData = null;
    changeOnErrorState(false);
    notifyListeners();
  }


  /// Creates image data from a [Uint8List] of bytes and a file [name].
  Future<void> fromUint8List({
    required final Uint8List  bytes,
    required final String     name
  }) async {
    startLoading();
    await _useCase
    .createDTO(
      key     : _key,
      maxSize : _maxSize,
      data    : bytes,
      path    : "blob/$name",
    )
    .then(_setData)
    .onError(_setError)
    .whenComplete(() => stopLoading() );
  }


  /// Loads image data from a URL with optional HTTP [headers].
  Future<void> fromUrl({
    required final Map<String, String>? headers,
    required final String url,
  }) async {
    startLoading();
    await _useCase
    .createDataFromURL(
      key     : _key,
      maxSize : _maxSize,
      headers : headers,
      url     : url,
    )
    .then(_setData)
    .onError(_setError)
    .whenComplete(() => stopLoading() );
  }


  /// Loads image data from an asset URL with optional HTTP [headers].
  Future<void> fromAsset({
    required final Map<String, String>? headers,
    required final String url,
  }) async {
    startLoading();
    await _useCase
    .createDataFromURL(
      key     : _key,
      maxSize : _maxSize,
      headers : headers,
      url     : url
    )
    .then(_setData)
    .onError(_setError)
    .whenComplete(() => stopLoading() );
  }


  /// Changes the error state to [state] and notifies listeners.
  void changeOnErrorState(final bool state) {
    onError = state;
    if(state) _imageData = null;
    notifyListeners();
  }


  /// Changes the drag state to [state] and notifies listeners if changed.
  void changeOnDragState(final bool state) {
    if(state != onDrag) {
      onDrag = state;
      notifyListeners();
    }
  }


  /// Attaches the drop body area to a widget identified by [globalKey].
  void _attachDropBody(final GlobalKey globalKey) => _useCase.attachDropBody(
    controller  : this,
    globalKey   : globalKey
  );


  /// Attaches the drop zone area to a widget identified by [globalKey].
  void _attachDropZone(final GlobalKey globalKey) =>
    _useCase.attachDropZone(
      controller: this,
      globalKey : globalKey
    );

  /// Hides the drop zone identified by the hash code of [globalKey].
  void _hideDropZone(final GlobalKey globalKey) =>
    _useCase.hideDropZone(
      hashCode: globalKey.hashCode
    );


  /// Removes the drop zone associated with [globalKey].
  void _removeDropZone(final GlobalKey globalKey) =>
    _useCase.removeDropZone(globalKey);


  /// Sets the internal image data to [data] and updates error state.
  void _setData(DataDTO? data) async {
    _imageData = data;
    changeOnErrorState(data == null);
    notifyListeners();
  }


  /// Handles errors by clearing image data, setting error state, and notifying.
  void _setError(Object? error, StackTrace stackTrace) async {
    _imageData = null;
    changeOnErrorState(true);
    notifyListeners();
  }

}

/// A widget that displays an image with drag-and-drop support and various states.
/// Uses an [ImageController] to manage the image data and state.
class ImageArea extends StatefulWidget {
  /// The controller managing image state and data.
  final ImageController       controller;

  /// Decoration for the container.
  final BoxDecoration       ? decoration;

  /// Margin around the container.
  final EdgeInsetsGeometry  ? margin;

  /// Padding inside the container.
  final EdgeInsetsGeometry  ? padding;

  /// Optional URL or path to an image to load on initialization.
  final String? onLoadingImage;

  /// Width of the container.
  final double  width;

  /// Height of the container.
  final double  height;

  /// Widget to display when no image is loaded.
  final Widget? emptyChild;

  /// Widget to display when an error occurs.
  final Widget? onErrorChild;

  /// Widget to display when a drag operation is active.
  final Widget? onDragChild;

  /// Widget to display while loading.
  final Widget? onLoadingChild;

  /// How to fit the image within the container.
  final BoxFit? fit;

  /// If true, disables drag-and-drop and image picking.
  final bool    readOnly;

  /// Creates an [ImageArea] with specified width and height.
  const ImageArea({
    required this.controller,
    required this.width,
    required this.height,
    this.onLoadingImage,
    this.decoration,
    this.margin,
    this.padding,
    this.emptyChild,
    this.onErrorChild,
    this.onDragChild,
    this.onLoadingChild,
    this.fit,
    this.readOnly = false,
    super.key
  });

  /// Creates a square [ImageArea] with equal width and height [dimension].
  ImageArea.square({
    required this.controller,
    required final double dimension,
    this.onLoadingImage,
    this.decoration,
    this.margin,
    this.padding,
    this.emptyChild,
    this.onErrorChild,
    this.onDragChild,
    this.onLoadingChild,
    this.fit,
    this.readOnly = false,
    super.key
  }) :
  width   = dimension,
  height  = dimension;

  /// Creates an [ImageArea] that expands to fill available space.
  ImageArea.expand({
    required this.controller,
    this.onLoadingImage,
    this.decoration,
    this.margin,
    this.padding,
    this.emptyChild,
    this.onErrorChild,
    this.onDragChild,
    this.onLoadingChild,
    this.fit,
    this.readOnly = false,
    super.key
  }) :
  width   = double.infinity,
  height  = double.infinity;

  @override
  State<ImageArea> createState() => _ImageZoneState();
}

/// State class for [ImageArea] that manages drag-drop attachment and image loading.
class _ImageZoneState extends State<ImageArea> {
  final GlobalKey _globalKey = GlobalKey();

  /// Attaches drag-drop listeners and zones if running on Web or WASM platforms.
  void attachAndListenDropZone() {
    if(kIsWeb || kIsWasm) {

      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        if (mounted) widget.controller._attachDropZone(_globalKey);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.controller .._attachDropBody(_globalKey) .._hideDropZone(_globalKey);
      });

    }
  }


  /// Loads an image from [widget.onLoadingImage] if provided.
  void getOnloadingImage() {
    if(widget.onLoadingImage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async =>
        await widget.controller
        .getOnloadingImage( path: widget.onLoadingImage! )
        .onError((_, __) => null)
      );
    }
  }


  @override
  void initState() {
    super.initState();
    if(!widget.readOnly) attachAndListenDropZone();
    getOnloadingImage();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller._removeDropZone(_globalKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key           : _globalKey,
      width         : widget.width,
      height        : widget.height,
      margin        : widget.margin,
      padding       : widget.padding,
      decoration    : widget.decoration,
      clipBehavior  : widget.decoration == null ? Clip.none : Clip.hardEdge,
      child         :
      StreamBuilder(
        stream  : widget.controller.stream?.stream,
        builder : (context, snapshot) =>
        snapshot.connectionState == ConnectionState.active
        ? (widget.onLoadingChild ?? _Default(loading: true))
        : widget.controller.onDrag
          ? (widget.onDragChild ?? _Default(drag: true))
          : widget.controller.onError
            ? (widget.onErrorChild ?? _Default(error: true))
            : widget.controller.bytes == null
              ? (widget.emptyChild ?? SizedBox.shrink())
              : Image.memory(
                widget.controller.bytes!,
                fit           : widget.fit ?? BoxFit.cover,
                isAntiAlias   : true,
                filterQuality : FilterQuality.high,
              )
      )
    );
  }
}

/// Default widget to display for loading, error, or drag states.
/// Displays a circular progress indicator or icon accordingly.
class _Default extends StatelessWidget {
  final double dimension;
  final double size;
  final bool error;
  final bool drag;
  final bool loading;

  /// Creates a [_Default] widget with optional [error], [drag], and [loading] states.
  _Default({
    this.error    = false,
    this.drag     = false,
    this.loading  = false,
  }) :
  dimension = 30,
  size = 15;

  @override
  Widget build(BuildContext context) =>
  Center(
    child:
    SizedBox.square(
      dimension : dimension,
      child     :
      loading
      ? CircularProgressIndicator(strokeWidth: 1, color: Colors.grey)
      : Icon(
        error ? Icons.error_outline :
        drag  ? Icons.drag_handle :
        Icons.close,
        fontWeight  : FontWeight.w200,
        size        : size,
        color       : Colors.red.shade600,
      )
    )
  );
}