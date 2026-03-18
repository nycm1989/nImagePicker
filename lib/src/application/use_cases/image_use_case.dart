import 'dart:typed_data' show Uint8List;
import 'package:http/http.dart' show MultipartFile, get;
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart' show GlobalKey, RenderBox;
import 'package:flutter/services.dart' show rootBundle, Size;
import 'package:file_picker/file_picker.dart' show PlatformFile;

import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/domain/dtos/data_dto.dart' show DataDTO;
import 'package:n_image_picker/src/domain/ports/platform_port.dart' show PlatformPort;
import 'package:n_image_picker/src/domain/enums/resize_formats.dart' show ResizeFormats;

class ImageUseCase{

  /// Instance of [PlatformPort] to interact with platform-specific functionality.
  PlatformPort _platformPort = PlatformPort();

  /// Validates whether the given [url] is a valid image URL.
  ///
  /// Returns `true` if the [url] matches the expected pattern for image URLs, otherwise `false`.
  bool _isValidUrl(String url) =>
  RegExp(
    r'^(https?:\/\/(?:localhost|\d{1,3}(?:\.\d{1,3}){3}|[^\s/$.?#]+\.[^\s/$.?#]+)(:[0-9]+)?[^\s]*\.(jpg|jpeg|png|gif|bmp|tiff|tga|pvr|ico|webp|psd|exr|pnm))$',
    caseSensitive: false
  ).hasMatch(url);

  /// Creates a [DataDTO] from raw image [data] bytes.
  ///
  /// Uses the [path] to extract the file name and extension.
  /// Optionally resizes the image if [maxSize] is provided.
  /// The [key] is used to identify the multipart file.
  ///
  /// Returns a [DataDTO] object containing image metadata and multipart file, or `null` if creation fails.
  Future<DataDTO?> createDTO({
    required final Uint8List  data,
    required final String     path,
    required final int      ? maxSize,
    required final String     key,
    final MultipartFile? file,
  }) async {
    return await Future<DataDTO?>(() async {
      try{

        final List<String> nameData = path.split("/").last.split(".");
        final String name = nameData.join(".");

        final Uint8List bytes = maxSize == null
        ? data
        : resizeImage(
          data      : data,
          extension : nameData.last,
          maxSize   : maxSize
        ) ?? data;

        final img.Image? image = getImageData(bytes);
        if(image == null) return null;

        return DataDTO(
          key       : key,
          name      : nameData.first,
          extension : nameData.last,
          size      : Size(image.width.toDouble(), image.height.toDouble()),
          bytes     : bytes,
          multipartFile : file ??
          MultipartFile.fromBytes(
            key,
            bytes,
            filename    : name,
          )
        );
      } catch (e) {
        return null;
      }
    });
  }


  /// Retrieves a [DataDTO] for an image loading from either a URL or an asset path.
  ///
  /// Uses [path] to determine the source.
  /// The [key] identifies the multipart file.
  /// Optionally resizes the image with [maxSize].
  /// [headers] can be provided for HTTP requests.
  ///
  /// Returns a [DataDTO] if successful, or `null` otherwise.
  Future<DataDTO?> getOnloadingImage({
    required final String   path,
    required final String   key,
    required final int    ? maxSize,
    required final Map<String, String>? headers,
  }) async =>
  _isValidUrl(path)
  ? await createDataFromURL(headers: headers, url: path, key: key, maxSize: maxSize)
  : await createDataFromAsset(path: path, key: key, maxSize: maxSize);


  /// Creates a [DataDTO] from a [PlatformFile] object.
  ///
  /// Optionally resizes the image to [maxSize].
  /// The [key] identifies the multipart file.
  ///
  /// Returns a [DataDTO] if successful, or `null` on failure.
  /// //TODO get size
  Future<DataDTO?> createDataFromPlatformFile({
    required final PlatformFile file,
    required final int      ? maxSize,
    required final String     key,
  }) async {
    try{
      final Uint8List platformBytes = _platformPort.requirePath()
        ? _platformPort.getBytesFromPath(file.path ?? "")
        : file.bytes!;


      final Uint8List bytes = maxSize == null
      ? platformBytes
      : resizeImage(
        data      : platformBytes,
        extension : file.extension ?? "",
        maxSize   : maxSize
      ) ?? platformBytes;

      final img.Image? image = getImageData(bytes);
      if(image == null) return null;

      return DataDTO(
        name          : file.name,
        extension     : file.extension??"",
        bytes         : bytes,
        size          : Size(image.width.toDouble(), image.height.toDouble()),
        multipartFile : _platformPort.requirePath()
        ? await MultipartFile.fromPath(
          key,
          file.path ?? "",
          filename    : file.name,
        )
        : MultipartFile.fromBytes(
          key,
          file.bytes!,
          filename    : file.name,
        )
      );
    } catch(e) {
      return null;
    }
  }


  /// Creates a [DataDTO] by fetching image data from a network [url].
  ///
  /// Optionally accepts HTTP [headers].
  /// The [key] identifies the multipart file.
  /// Optionally resizes the image to [maxSize].
  ///
  /// Returns a [DataDTO] if the URL is valid and data is fetched successfully, otherwise `null`.
    Future<DataDTO?> createDataFromURL({
    required final Map<String, String>? headers,
    required final String url,
    required final String key,
    final int? maxSize
  }) async {
    if (!_isValidUrl(url)) return null;

    try {
      // 1. Try cache first
      return await _platformPort.getCacheData(url: url).then((cachedBytes) async {

        if (cachedBytes != null) {
          return await createDTO(
            data    : cachedBytes,
            path    : url,
            maxSize : maxSize,
            key     : key,
          );
        }

        // 2. Fetch from network if not cached
        return await get(Uri.parse(url), headers: headers).then((response) async {

          if (response.statusCode != 200) return null;

          final Uint8List bytes = response.bodyBytes;

          // 3. Save to cache (no await blocking)
          _platformPort.putCacheData(
            url   : url,
            bytes : bytes,
          );

          // 4. Return DTO
          return await createDTO(
            data    : bytes,
            path    : url,
            maxSize : maxSize,
            key     : key,
          );
        });

      });
    } catch (e, stackTrace) {
      print("$e\n$stackTrace");
      return null;
    }
  }


  /// Creates a [DataDTO] from an asset file located at [path].
  ///
  /// The [key] identifies the multipart file.
  /// Optionally resizes the image to [maxSize].
  ///
  /// Returns a [DataDTO] if the asset is loaded successfully, otherwise `null`.
  Future<DataDTO?> createDataFromAsset({
    required final String path,
    required final String key,
    final int? maxSize
  }) async {
    if(path.isEmpty) return null;

    return await rootBundle.load(path).then((data) async =>
      await createDTO(
        data    : data.buffer.asUint8List(),
        path    : path,
        maxSize : maxSize,
        key     : key
      )
    );
  }

  /// Decodes the raw image [data] bytes into an [img.Image] object.
  ///
  /// Returns the decoded image, or `null` if decoding fails.
  img.Image? getImageData(final Uint8List data) => img.decodeImage(data);

  /// Resizes the image represented by raw [data] bytes to a maximum dimension of [maxSize].
  ///
  /// The [extension] indicates the image format for proper encoding.
  /// Returns the resized image bytes, or the original data if resizing is not applicable or fails.
  Uint8List? resizeImage({
    required final Uint8List  data,
    required final String     extension,
    required final int        maxSize,
  }) {
    String _format = extension.toLowerCase();

    try{
      int? width;
      int? height;

      if(data.isEmpty || !ResizeFormats.values.map((e) => e.name).toList().contains(_format)) return null;

      final img.Image? _image  = getImageData(data);

      if(_image != null){
        if (_image.width <= maxSize && _image.height <= maxSize) return null;

        _image.width > _image.height
        ? width   = maxSize
        : height  = maxSize;

        final img.Image _resize = img.copyResize( _image, width: width, height: height);

        Uint8List? _bytes;

        if(_format == ResizeFormats.bmp.name  ) _bytes = Uint8List.fromList(img.encodeBmp(_resize));
        if(_format == ResizeFormats.cur.name  ) _bytes = Uint8List.fromList(img.encodeCur(_resize));
        if(_format == ResizeFormats.jpg.name  ) _bytes = Uint8List.fromList(img.encodeJpg(_resize, quality: 90));
        if(_format == ResizeFormats.png.name  ) _bytes = Uint8List.fromList(img.encodePng(_resize));
        if(_format == ResizeFormats.pvr.name  ) _bytes = Uint8List.fromList(img.encodePvr(_resize));
        if(_format == ResizeFormats.tga.name  ) _bytes = Uint8List.fromList(img.encodeTga(_resize));
        if(_format == ResizeFormats.tiff.name ) _bytes = Uint8List.fromList(img.encodeTiff(_resize));

        if(_bytes == null) return null;

        return _bytes.isNotEmpty ? _bytes : null;
      }

      return null;
    } catch (e) {
      return null;
    }
  }


  /// Attaches a drop body to the UI element referenced by [globalKey] for the given [controller].
  ///
  /// Uses the [globalKey] to obtain the render box and context hash code.
  /// Calls platform-specific method to attach the drop body.
  void attachDropBody({
    required final ImageController controller,
    required final GlobalKey globalKey,
  }) {

    final int       ? hashCode  = globalKey.currentContext?.hashCode;
    final RenderBox ? renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;

    if(hashCode != null || renderBox != null) {
      _platformPort.attachDropBody(
        controller: controller,
        renderBox : renderBox!,
        hashCode  : hashCode!
      );
    }
  }


  /// Attaches a drop zone to the UI element referenced by [globalKey] for the given [controller].
  ///
  /// Uses the [globalKey] to obtain the render box and context hash code.
  /// Calls platform-specific method to attach the drop zone.
  void attachDropZone({
    required final ImageController controller,
    required final GlobalKey globalKey,
  }) {
    final int       ? hashCode  = globalKey.currentContext?.hashCode;
    final RenderBox ? renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;

    if(hashCode != null || renderBox != null) {
      _platformPort.attachDropZone(
        controller: controller,
        hashCode  : hashCode!,
        renderBox : renderBox!,
      );
    }
  }


  /// Hides the drop zone identified by [hashCode].
  ///
  /// Calls platform-specific method to hide the drop zone.
  void hideDropZone({
    required final int hashCode
  }) =>
  _platformPort.hideDropZone(
    hashCode  : hashCode
  );


  /// Removes the drop zone associated with the UI element referenced by [globalKey].
  ///
  /// Calls platform-specific method to remove the drop zone if [hashCode] is available.
  void removeDropZone(final GlobalKey globalKey) {
    final int? hashCode  = globalKey.currentContext?.hashCode;
    if(hashCode != null) _platformPort.removeDropZone(hashCode: hashCode);
  }

}