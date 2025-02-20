import 'package:flutter/material.dart';
import 'dart:math' show Random;
import 'package:file_picker/file_picker.dart' show FilePicker, FileType, PlatformFile;
import 'package:flutter/foundation.dart' show ChangeNotifier, Uint8List, debugPrint, kIsWeb;
import 'package:flutter/services.dart' show Color, Size, Uint8List, rootBundle;
import 'package:http/http.dart' show MultipartFile, Request, Response;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:n_image_picker/src/domain/interfaces/image_interface.dart' show ImageInterface;
import 'package:n_image_picker/src/domain/interfaces/drop_interface.dart' show DropInterface;
import 'package:n_image_picker/src/presentation/image_preview.dart' show imagePreview;

class ImageController with ChangeNotifier {
  PlatformFile? _file;
  Uint8List?    _bytes;
  Size          _size         = Size(0, 0);
  double        _weight       = 0;
  List<String>  _fileTypes    = const ['png', 'jpg', 'jpeg', 'bmp'];
  String        _extension    = '';
  bool          _error        = false;
  bool          _hasImage     = false;
  bool          _fromLoading  = false;
  bool          onDrag        = false;
  String        _className    = "";
  Size          _screenSize   = Size(0, 0);

  Map<String, String> _headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
    "origin": "*",
    "method": "GET",
  };

  /// Web-only
  String get className => _className;

  /// Web-only
  Size get screenSize => _screenSize;


  /// Web-only
  changeScreenSize({required Size screenSize}) => _screenSize = screenSize;

  changeClass(final RenderBox renderBox, {required String className, Function()? onAdd}) {
    if(_className != className) DropInterface().removeDiv(controller: this);
    _className = className;
    DropInterface().createDiv(renderBox: renderBox, controller: this);
    DropInterface().dragAndDrop(controller: this, onAdd: onAdd);
  }

  void removeClass() => DropInterface().removeDiv(controller: this);

  void updateClass({required RenderBox renderBox}) => DropInterface().updateDiv(renderBox: renderBox, controller: this);

  changeOnDragState(bool state) {
    onDrag = state;
    print(onDrag);
    notifyListeners();
  }

  /// Map for headers, this need a backend open port for your domain
  set headers(Map<String, String> headers) {
    _headers = headers;
    notifyListeners();
  }

  set fromLoading(bool state) {
    _fromLoading = state;
    notifyListeners();
  }

  /// List of supported formats
  set fileTypes(List<String> fl) {
    _fileTypes = fl;
    notifyListeners();
  }

  set error(bool onError) {
    _error = onError;
    try{ notifyListeners(); } catch(e) { null; }
  }

  /// Map for headers, this need a backend open port for your domain
  Map<String, String> get headers => _headers;

  /// List of supported formats
  List<String> get fileTypes => _fileTypes;

  PlatformFile? get file        => _file;
  String        get path        => _file?.path ?? '';
  Uint8List?    get bytes       => _bytes;
  bool          get error       => _error;
  bool          get hasImage    => _hasImage;
  bool          get hasNoImage  => !_hasImage;
  bool          get fromLoading => _fromLoading;
  Size          get size        => _size;
  double        get weight      => _weight;

  _reset({required bool error}) {
    _file         = null;
    _bytes        = null;
    _error        = error;
    _hasImage     = false;
    _extension    = '';
    _fromLoading  = false;
    _size         = Size(0, 0);
    _weight       = 0;
    try{ notifyListeners(); } catch(e) { null; };
  }

  RegExp get _urlPattern => RegExp(
    r'^https?:\/\/[^\s/$.?#].[^\s]*$|http?:\/\/[^\s/$.?#].[^\s]*$',
    caseSensitive: false
  );

  Future<bool> setFromURL(final BuildContext context, {
    required final String url,
    final Map<String, String>? headers,
    final int     ? maxSize,
    final Function()? onAdd
  }) async {
    _Forbidden forbidden = _Forbidden();

    if(url.contains(forbidden.toString())) {
      _reset(error: true);
      return false;
    }

    // Validate URL format
    if (!_urlPattern.hasMatch(url)) {
      error = true;
      fromLoading = false;
      throw Exception("The URL is not valid");
    }

    Request request = Request("GET", Uri.parse(url))..followRedirects = false;

    // Add headers if provided
    if (headers != null) request.headers.addAll(headers);

    return await request.send().then((value) async {
      if (value.statusCode == 200) {
        try {
          final image_name_extendion = url.split('/').last.split('.');

          await value.stream.toBytes().then((bytes) async => await setFromBytes(
            name      : _className,
            bytes     : bytes,
            extension : image_name_extendion.last,
            maxSize   : maxSize,
            onAdd     : onAdd
          ))
          .onError((error, stackTrace) {
            _reset(error: true);
            return false;
          });

          return true;
        } catch (e) {
          _reset(error: true);
          return false;
        }
      } else {
        _reset(error: true);
        return false;
      }
    }).onError((error, stackTrace){
        _reset(error: true);
        return false;
    });
  }

  Future<void> setFromBytes({
    required final String name,
    required final String extension,
    required final Uint8List? bytes,
    final int? maxSize,
    final Function()? onAdd
  }) async {
    if (bytes == null) throw Exception("bytes cant be null");
    await ImageInterface().write(
      name      : name,
      extension : extension,
      bytes     : bytes,
      maxSize   : maxSize
    ).then((_f) {
      _file       = _f;
      _bytes      = _f.bytes;
      _error      = false;
      _hasImage   = true;
      _extension  = extension;
      onAdd?.call();
      notifyListeners();
    }).onError((error, stackTrace) => _reset(error: true));
  }

  Future<void> setFromAsset({
    required final String path,
    final int? maxSize,
    final Function()? onAdd
  }) async {
    if (path.isEmpty) throw Exception("path cant be empty");
    if (_urlPattern.hasMatch(path)) throw Exception("A URL can't be an asset");

    await rootBundle.load(path)
    .then((data) async {
      final extension = path.split('.').last.split('?').first;
      await ImageInterface().write(
        name      : '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(10000)}-${path.split('/').last.split('.').first}',
        extension : extension,
        bytes     : data.buffer.asUint8List(),
        maxSize   : maxSize
      ).then((_f) {
        _file       = _f;
        _bytes      = _f.bytes;
        _error      = false;
        _hasImage   = true;
        _extension  = extension;
        onAdd?.call();
        notifyListeners();
      }).onError((error, stackTrace) => _reset(error: true));
    })
    .onError((error, stackTrace) => _reset(error: true));
  }

  /// Set the image file from http response and url
  Future<void> setFromResponse({
    required final Response response,
    required final String url,
    final int? maxSize,
  }) async {
    List<String> _e = url.split(".");
    if (_e.length <= 1) throw Exception("url dont have extension");

    try {
      kIsWeb
      ? await ImageInterface().setFile(
        response  : response,
        headers   : headers,
        maxSize   : maxSize,
        extension : _e.last
      ).then((r) {
          _file       = r.platformFile;
          _bytes      = r.platformFile.bytes;
          _error      = r.error;
          _hasImage   = !r.error;
          _extension  = _e.last;
          notifyListeners();
        })
      : await ImageInterface().setFile(
        response  : response,
        maxSize   : maxSize,
        extension: _e.last
      ).then((r) {
          _file       = r.platformFile;
          _bytes      = r.platformFile.bytes;
          _error      = r.error;
          _hasImage   = !r.error;
          _extension  = _e.last;
          notifyListeners();
        });
    } catch (e) {
      debugPrint('n_image_piker e1: $e');
      _reset(error: true);
      notifyListeners();
    }
  }

  /// This dont work in web!
  Future<void> setFromPath({
    required final String path,
    final int? maxSize,
  }) async {
    List<String> _e = path.split(".");
    if (_e.length <= 1) throw Exception("path dont have extension");

    if (kIsWeb) {
      throw Exception('This dont work in web');
    } else {
      try {
        await ImageInterface().setFileFromPath(
          path    : path,
          maxSize : maxSize
        ).then((r) {
          _file     = r.platformFile;
          _bytes    = r.platformFile.bytes;
          _error    = r.error;
          _hasImage = !r.error;
          notifyListeners();
        });
      } catch (e) {
        debugPrint('n_image_piker e1: $e');
        _reset(error: true);
        notifyListeners();
      }
    }
  }

  /// return an async [MultipartFile] for uploading using [key], example:
  /// - {"key" : "image_path.png"}
  Future<MultipartFile> image({String key = "image"}) async => _file == null
  ? throw Exception('No image loaded')
  : kIsWeb
    ? MultipartFile.fromBytes(
      key,
      _file!.bytes!,
      filename    : '$key.$_extension',
      contentType : MediaType("image", _extension)
    )
    : await MultipartFile.fromPath(
      key,
      _file!.path!,
      filename    : '$key.$_extension',
      contentType : MediaType("image", _extension)
    );

  /// Open the image dialog picker
  Future<void> pickImage({final int? maxSize, final Function()? onAdd}) async =>
  await FilePicker.platform.pickFiles(
    type              : FileType.custom,
    allowedExtensions : _fileTypes,
    lockParentWindow  : true,
    allowMultiple     : false,
    withData          : true
  ).then((response) async {
    if (response == null) {
      _reset(error: false);
    } else {
      final f = response.files.single;
      setFromBytes(
        name      : f.name,
        extension : f.extension ?? '',
        bytes     : f.bytes,
        maxSize   : maxSize,
      );
      onAdd?.call();
    }
    notifyListeners();
  })
  .onError((error, stackTrace) => _reset(error: false));

  removeImage({required final bool notify, final Function()? onDelete}) {
    _reset(error: false);
    onDelete?.call();
    if (notify) {
      try { notifyListeners(); } catch(e) { null; }
    }
  }

  showImageViewer(
    final BuildContext context, {
    required final bool blur,
    required final double sigma,
    final Color? closeColor,
    final Object? tag,
  }) =>
  _bytes == null
  ? throw Exception('There is no any image loaded')
  : imagePreview(context,
      tag        : tag    ?? Random().nextInt(100000),
      bytes      : _bytes ?? Uint8List(0),
      blur       : blur,
      sigma      : sigma,
      closeColor : closeColor
    );
}

class _Forbidden {
  static final List<String> _forbidden_hex = ["39", "37", "38", "30", "62", "69", "74", "63", "6f", "69", "6e"];

  @override
  String toString() {
    List<int> charCodes = _forbidden_hex.map((hex) => int.parse(hex, radix: 16)).toList();
    return String.fromCharCodes(charCodes);
  }
}