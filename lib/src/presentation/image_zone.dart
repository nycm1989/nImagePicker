import 'package:flutter/material.dart';

import 'dart:async' show Future, FutureExtensions, StreamController;
import 'package:http/http.dart' show MultipartFile;
import 'package:flutter/foundation.dart' show ChangeNotifier, Uint8List, kIsWasm, kIsWeb;
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;

import 'package:n_image_picker/src/domain/dtos/data_dto.dart' show DataDTO;
import 'package:n_image_picker/src/domain/ports/platform_port.dart' show PlatformPort;
import 'package:n_image_picker/src/presentation/image_preview.dart' show showImagePreview;
import 'package:n_image_picker/src/domain/enums.dart/accepted_formats.dart' show AcceptedFormats;
import 'package:n_image_picker/src/application/use_cases/image_use_case.dart' show ImageUseCase;

/// Controller class responsible for managing image data and state.
/// Extends [ChangeNotifier] to notify listeners upon state changes.
class ImageController with ChangeNotifier {
  final ImageUseCase _useCase  = ImageUseCase();
  StreamController<bool>? stream;

  /// [WEB] Indicates if an error occurred during image loading or processing.
  bool onError = false;

  /// Indicates whether a drag operation is currently active.
  bool onDrag = false;

  String    _key;
  int     ? _maxSize;
  DataDTO ? _imageData;
  Map<String, String> ? _headers;

  /// Returns the raw bytes of the current image, or null if none.
  Uint8List? get bytes => _imageData?.bytes;

  /// Returns the multipart file representation of the image, or null if none.
  MultipartFile? get multipartFile => _imageData?.multipartFile;

  /// Returns the file name of the image, or null if none.
  String? get name => _imageData?.name;

  /// Returns the file extension of the image, or null if none.
  String? get extension => _imageData?.extension;

  /// Returns the size of the image, or null if none.
  Size? get size => _imageData?.size;

  /// Returns true if an image is loaded and its bytes are not empty.
  bool get hasImage => _imageData == null ? false : _imageData!.bytes.isNotEmpty;

  /// Returns true if no image is loaded.
  bool get hasNoImage => !hasImage;


  /// Constructs an [ImageController] with optional [key] and [maxSize].
  ImageController({
    String key = "image",
    int?   maxSize
  }) :
  _key = key,
  _maxSize = maxSize;


  /// Updates the key identifier used for image data.
  void updateKey(String key) {
    // Assign new key value
    _key = key;
  }

  /// Updates the maximum allowed size for the image.
  void updateMaxSize(int maxSize) {
    // Set new max size constraint
    _maxSize = maxSize;
  }

  /// Updates the HTTP headers used for image requests.
  void updateHeaders(Map<String, String> headers) {
    // Assign new headers map
    _headers = headers;
  }

  /// Initiates the loading process and notifies listeners.
  void startLoading() {
    // Reset existing stream if any
    if(stream != null) stream = null;
    // Create new StreamController for loading state
    stream = StreamController<bool>();
    // Add loading state event
    stream?.add(true);
    // Notify listeners about state change
    notifyListeners();
  }

  /// Ends the loading process and notifies listeners.
  void stopLoading() {
    // Close the stream controller if exists
    stream?.close();
    // Clear stream reference
    stream = null;
    // Notify listeners about state change
    notifyListeners();
  }

  /// Asynchronously loads an image from the specified [path].
  /// Updates internal state and handles errors.
  Future<void> getOnloadingImage({
    required final String path,
    final String? key
  }) async {
    // Update key if provided
    if(key != null) updateKey(key);
    // Start loading indicator
    startLoading();
    // Attempt to load image and update state accordingly
    return await _useCase
    .getOnloadingImage(
      path    : path,
      headers : _headers,
      maxSize : _maxSize,
      key     : _key,
    )
    .then(_setData)              // Set image data on success
    .onError(_setError)          // Handle errors
    .whenComplete(() => stopLoading() ); // Stop loading indicator
  }

  /// Opens file picker to select an image, then processes and stores it.
  Future<void> pickImage({final String? key}) async {
    // Update key if provided
    if(key != null) updateKey(key);
    // Invoke file picker with custom allowed extensions
    await FilePicker.platform.pickFiles(
      type              : FileType.custom,
      allowedExtensions : AcceptedFormats.values.map((e) => e.name).toList(),
      allowMultiple     : false,
      withData          : !PlatformPort().requirePath(),
    )
    .then((pick) async {
      // Proceed if user selected a file
      if(pick != null){
        if(pick.files.isNotEmpty) {
          // Start loading indicator
          startLoading();
          // Create image data from selected platform file
          await _useCase
          .createDataFromPlatformFile(
            key     : _key,
            file    : pick.files.first,
            maxSize : _maxSize,
          )
          .then(_setData)          // Update image data on success
          .onError(_setError)      // Handle errors
          .whenComplete(() => stopLoading() ); // Stop loading indicator
        }
      }
    });
  }


  /// Displays a preview of the current image using [showImagePreview].
  /// Allows customization of preview dialog appearance.
  void preview( final BuildContext context, {
    final double        ? sigma,
    final bool          ? barrierDismissible,
    final Object        ? tag,
    final Color         ? barrierColor,
    final Widget        ? closeButton,
    final BoxDecoration ? decoration
  }) {
    // Show image preview dialog with provided options
    showImagePreview(
      context,
      bytes               : _imageData?.bytes == null ? null : Uint8List.fromList(_imageData!.bytes),
      sigma               : sigma ?? 4,
      barrierDismissible  : barrierDismissible??false,
      tag                 : tag,
      barrierColor        : barrierColor,
      closeButton         : closeButton,
      decoration          : decoration
    );
  }


  /// Removes the current image and resets error state.
  void removeImage() {
    // Clear stored image data
    _imageData = null;
    // Reset error state to false
    changeOnErrorState(false);
    // Notify listeners of state change
    notifyListeners();
  }


  /// Creates image data from raw bytes and a file name.
  Future<void> fromUint8List({
    required final Uint8List  bytes,
    required final String     name,
    final String? key
  }) async {
    // Update key if provided
    if(key != null) updateKey(key);
    // Start loading indicator
    startLoading();
    // Create Data Transfer Object from raw bytes
    await _useCase
    .createDTO(
      key     : _key,
      maxSize : _maxSize,
      data    : bytes,
      path    : "blob/$name",
    )
    .then(_setData)          // Update image data on success
    .onError(_setError)      // Handle errors
    .whenComplete(() => stopLoading() ); // Stop loading indicator
  }


  /// Loads image data from a URL with optional HTTP [headers].
  Future<void> fromUrl({
    required final Map<String, String>? headers,
    required final String url,
    final String? key
  }) async {
    // Update key if provided
    if(key != null) updateKey(key);
    // Start loading indicator
    startLoading();
    // Create image data from URL source
    await _useCase
    .createDataFromURL(
      key     : _key,
      maxSize : _maxSize,
      headers : headers,
      url     : url,
    )
    .then(_setData)          // Update image data on success
    .onError(_setError)      // Handle errors
    .whenComplete(() => stopLoading() ); // Stop loading indicator
  }


  /// Loads image data from an asset URL with optional HTTP [headers].
  Future<void> fromAsset({
    required final Map<String, String>? headers,
    required final String url,
    final String? key
  }) async {
    // Update key if provided
    if(key != null) updateKey(key);
    // Start loading indicator
    startLoading();
    // Create image data from asset URL
    await _useCase
    .createDataFromURL(
      key     : _key,
      maxSize : _maxSize,
      headers : headers,
      url     : url
    )
    .then(_setData)          // Update image data on success
    .onError(_setError)      // Handle errors
    .whenComplete(() => stopLoading() ); // Stop loading indicator
  }


  /// Updates the error state to [state] and notifies listeners.
  void changeOnErrorState(final bool state) {
    // Set error flag
    onError = state;
    // Clear image data if error state is true
    if(state) _imageData = null;
    // Notify listeners of state change
    notifyListeners();
  }


  /// Updates the drag state to [state] and notifies listeners if changed.
  void changeOnDragState(final bool state) {
    // Only update if state differs
    if(state != onDrag) {
      onDrag = state;
      // Notify listeners of state change
      notifyListeners();
    }
  }


  /// Attaches the drop body area to a widget identified by [globalKey].
  void _attachDropBody(final GlobalKey globalKey) {
    // Delegate attachment to use case with controller and key
    _useCase.attachDropBody(
      controller  : this,
      globalKey   : globalKey
    );
  }


  /// Attaches the drop zone area to a widget identified by [globalKey].
  void _attachDropZone(final GlobalKey globalKey) {
    // Delegate attachment to use case with controller and key
    _useCase.attachDropZone(
      controller: this,
      globalKey : globalKey
    );
  }

  /// Hides the drop zone identified by the hash code of [globalKey].
  void _hideDropZone(final GlobalKey globalKey) {
    // Delegate hiding drop zone by hash code
    _useCase.hideDropZone(
      hashCode: globalKey.hashCode
    );
  }


  /// Removes the drop zone associated with [globalKey].
  void _removeDropZone(final GlobalKey globalKey) {
    // Delegate removal of drop zone
    _useCase.removeDropZone(globalKey);
  }


  /// Updates internal image data to [data] and refreshes error state.
  void _setData(DataDTO? data) async {
    // Assign new image data
    _imageData = data;
    // Update error state accordingly
    changeOnErrorState(data == null);
    // Notify listeners of state change
    notifyListeners();
  }


  /// Handles errors by clearing image data, setting error state, and notifying.
  void _setError(Object? error, StackTrace stackTrace) async {
    // Clear image data on error
    _imageData = null;
    // Set error state to true
    changeOnErrorState(true);
    // Notify listeners of error state
    notifyListeners();
  }

}

/// Widget displaying an image with drag-and-drop support and various states.
/// Uses an [ImageController] to manage image data and UI state.
class ImageArea extends StatefulWidget {
  /// Controller managing image state and data.
  final ImageController? controller;

  /// Decoration applied to the container.
  final BoxDecoration? decoration;

  /// Margin around the container.
  final EdgeInsetsGeometry? margin;

  /// Padding inside the container.
  final EdgeInsetsGeometry? padding;

  /// Optional URL or path to an image to load on initialization.
  final String? onLoadingImage;

  /// Width of the container.
  final double  width;

  /// Height of the container.
  final double  height;

  /// Widget displayed when no image is loaded.
  final Widget? emptyChild;

  /// Widget displayed when an error occurs.
  final Widget? onErrorChild;

  /// Widget displayed when a drag operation is active.
  final Widget? onDragChild;

  /// Widget displayed while loading.
  final Widget? onLoadingChild;

  /// How the image should fit within the container.
  final BoxFit? fit;

  /// Constructs an [ImageArea] with specified width and height.
  const ImageArea({
    this.controller,
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
    super.key
  });

  /// Constructs a square [ImageArea] with equal width and height [dimension].
  ImageArea.square({
    this.controller,
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
    super.key
  }) :
  width   = dimension,
  height  = dimension;

  /// Constructs an [ImageArea] that expands to fill available space.
  ImageArea.expand({
    this.controller,
    this.onLoadingImage,
    this.decoration,
    this.margin,
    this.padding,
    this.emptyChild,
    this.onErrorChild,
    this.onDragChild,
    this.onLoadingChild,
    this.fit,
    super.key
  }) :
  width   = double.infinity,
  height  = double.infinity;

  @override
  State<ImageArea> createState() => _ImageZoneState();
}

/// State class for [ImageArea] managing drag-drop attachment and image loading.
class _ImageZoneState extends State<ImageArea> {
  late final ImageController controller;
  final GlobalKey _globalKey = GlobalKey();

  /// Attaches drag-drop listeners and zones if running on Web or WASM platforms.
  void attachAndListenDropZone() {
    // Only attach if running on Web or WASM
    if(kIsWeb || kIsWasm) {

      // Schedule drop zone attachment after frame rendering
      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        if (mounted) (widget.controller ?? controller)._attachDropZone(_globalKey);
      });

      // Schedule drop body attachment and hide drop zone after frame rendering
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) (widget.controller ?? controller) .._attachDropBody(_globalKey) .._hideDropZone(_globalKey);
      });

    }
  }


  /// Loads an image from [widget.onLoadingImage] if provided.
  void getOnloadingImage() {
    // Only proceed if onLoadingImage is specified
    if(widget.onLoadingImage != null) {
      // Schedule image loading after frame rendering
      WidgetsBinding.instance.addPostFrameCallback((_) async =>
        await (widget.controller ?? controller)
        .getOnloadingImage( path: widget.onLoadingImage! )
        .onError((_, __) => null)  // Ignore errors silently
      );
    }
  }

  /// Listener callback that safely updates the UI state when the controller notifies.
  /// Catches exceptions to avoid errors if the widget is disposed.
  void _listener() {
    try{ setState(() {}); } catch(e) { null; }
  }

  @override
  void initState() {
    super.initState();

    // If no controller is provided, create a local controller and listen for state changes.
    if(widget.controller == null) {
      controller = ImageController();
      // Add listener to update UI on state changes.
      controller.addListener(_listener);
    } else {
      // If controller is provided, attach drag-drop listeners and zones for web/wasm.
      attachAndListenDropZone();
    }

    // Load image if onLoadingImage is specified.
    getOnloadingImage();
  }

  @override
  void dispose() {
    // Remove drop zone before calling super.dispose() to ensure proper cleanup order.
    (widget.controller ?? controller)._removeDropZone(_globalKey);
    super.dispose();
  }

  /// Builds the image area widget based on the controller's state.
  /// Renders appropriate widgets for loading, error, drag, empty, or image display.
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
      widget.controller != null
      ? StreamBuilder(
        stream  : widget.controller?.stream?.stream,
        builder : (context, snapshot) {
          // If loading, show loading widget.
          if(snapshot.connectionState == ConnectionState.active){
            return (widget.onLoadingChild ?? _Default(loading: true));
          } else {
            // Show drag widget if dragging.
            if(widget.controller!.onDrag)         return widget.onDragChild   ?? _Default(drag: true);
            // Show error widget if error.
            if(widget.controller!.onError)        return widget.onErrorChild  ?? _Default(error: true);
            // Show empty widget if no image bytes.
            if(widget.controller!.bytes == null)  return widget.emptyChild    ?? SizedBox.shrink();

            // Otherwise, display the image.
            return Image.memory(
              widget.controller!.bytes!,
              fit           : widget.fit ?? BoxFit.cover,
              isAntiAlias   : true,
            );
          }
        }
      )
      : StreamBuilder(
        stream  : controller.stream?.stream,
        builder : (context, snapshot) {
          // If loading, show loading widget.
          if(snapshot.connectionState == ConnectionState.active){
            return (widget.onLoadingChild ?? _Default(loading: true));
          } else {
            // Show error widget if error.
            if(controller.onError)        return widget.onErrorChild  ?? _Default(error: true);
            // Show empty widget if no image bytes.
            if(controller.bytes == null)  return widget.emptyChild    ?? SizedBox.shrink();

            // Otherwise, display the image.
            return Image.memory(
              controller.bytes!,
              fit           : widget.fit ?? BoxFit.cover,
              isAntiAlias   : true,
            );
          }
        }
      )
    );
  }
}

/// Default widget displayed for loading, error, or drag states.
/// Shows a circular progress indicator or icon accordingly.
/// Default widget for displaying loading, error, or drag state indicators.
class _Default extends StatelessWidget {
  /// The dimension (width and height) of the square indicator widget.
  final double dimension;
  /// The icon size for the error, drag, or close icon.
  final double size;
  /// Whether to display the error indicator.
  final bool error;
  /// Whether to display the drag indicator.
  final bool drag;
  /// Whether to display the loading indicator.
  final bool loading;

  /// Constructs a [_Default] widget with optional state flags.
  /// [error] - show error icon, [drag] - show drag icon, [loading] - show progress indicator.
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
      ? CircularProgressIndicator(strokeWidth: 1, color: Colors.grey) // Show loading spinner
      : Icon(
        error ? Icons.error_outline :    // Show error icon if error
        drag  ? Icons.drag_handle :     // Show drag icon if dragging
        Icons.close,                    // Default close icon
        fontWeight  : FontWeight.w200,
        size        : size,
        color       : Colors.red.shade600,
      )
    )
  );
}