
import 'package:n_image_picker/src/image_viewer_dialog.dart';

import 'io_file.dart' if (dart.library.web) 'web_file.dart';
import 'dart:io' if (dart.library.web) 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class NImagePickerController with ChangeNotifier{
  PlatformFile? _file;
  Uint8List   ? _bytes;
  String        _imageKey      = "image";
  List<String>  _fileTypes     = const [ 'png', 'jpg', 'jpeg' ];
  String        _extension     = '';
  bool          _error         = false;
  bool          _hasImage      = false;
  bool          _fromLoading   = false;
  Map<String, String> _headers = {
    "Access-Control-Allow-Origin"       : "*",
    "Access-Control-Allow-Credentials"  : 'true',
    "Access-Control-Allow-Headers"      : "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,X-Requested-With, Content-Type, Accept, Access-Control-Request-Method",
    'Access-Control-Allow-Methods'      : "GET, POST, PUT, DELETE, OPTIONS, HEAD",
    "Allow"                             : "GET, POST, PUT, DELETE, OPTIONS, HEAD",
    'Content-Type': 'application/json',
    'Accept': '*/*',
    "crossOrigin"                       : "Anonymous",
  };

  /// Map for headers, this need a backend open port for your domain
  set headers(Map<String, String> headers) {
    _headers = headers;
    notifyListeners();
  }

  set fromLoading(bool state){
    _fromLoading = state;
    notifyListeners();
  }

  /// json key for posting [MultipartFile] image, example:
  /// - "key" : "server/path/image.png"
  set imageKey(String name) {
    _imageKey = name;
    notifyListeners();
  }

  /// List of supported formats
  set fileTypes(List<String> fl) {
    _fileTypes = fl;
    notifyListeners();
  }

  set error(bool onError) {
    _error = onError;
    notifyListeners();
  }

  /// Map for headers, this need a backend open port for your domain
  Map<String, String> get headers     =>  _headers;

  /// json key for posting [MultipartFile] image, example:
  /// - "key" : "server/path/image.png"
  String              get imageKey    =>  _imageKey;

  /// List of supported formats
  List<String>        get fileTypes   =>  _fileTypes;

  PlatformFile?       get file        =>  _file;
  String              get path        =>  _file?.path ??  '';
  Uint8List?          get bytes       =>  _bytes;
  bool                get error       =>  _error;
  bool                get hasImage    =>  _hasImage;
  bool                get hasnoImage  =>  !_hasImage;
  bool                get fromLoading =>  _fromLoading;
  Image               get image       =>  _file == null
  ? throw Exception()
  : Image.file(
    kIsWeb
    ? File.fromRawPath(_file!.bytes!)
    : File(_file!.path!)
  );

  /// Set the image file from http response and url
  Future<void> setFromResponse({required Response response, required String url}) async {
    try{
      if(kIsWeb){
        await setFile(response, url, _imageKey, headers).then((r) {
          _file   = r.platformFile;
          _bytes  = r.platformFile.bytes;
          _error  = r.error;
          notifyListeners();
        });
      } else {
        await setFile(response, url, _imageKey, headers).then((r) {
          _file     = r.platformFile;
          _bytes    = r.platformFile.bytes;
          _error    = r.error;
          _hasImage = !r.error;
          notifyListeners();
        });
      }
    } catch (e){
      debugPrint('n_image_piker e1: $e');
      _file     = null;
      _bytes    = null;
      _error    = true;
      _hasImage = false;
      notifyListeners();
    }
  }

  /// This dont work in web!
  Future<void> setFromPath({required String path}) async {
    if(kIsWeb){
      throw Exception('This dont work in web');
    } else {
      try{
        await setFileFromPath(path).then((r) {
          _file     = r.platformFile;
          _bytes    = _file?.bytes;
          _error    = r.error;
          _hasImage = !r.error;
          notifyListeners();
        });
      } catch (e){
        debugPrint('n_image_piker e1: $e');
        _file     = null;
        _bytes    = null;
        _error    = true;
        _hasImage = false;
        notifyListeners();
      }
    }
  }

  /// return an async image for uploading using [imageKey] example:
  /// - await controller.multipartFile.then((image) => image)
  /// it works in web and platforms
  Future<MultipartFile> get multipartFile async {
    return _file == null
    ? throw Exception('There is no any image loaded')
    : kIsWeb
      ? MultipartFile.fromBytes(
        _imageKey,
        _file!.bytes!,
        filename    : '$_imageKey.$_extension',
        contentType : MediaType(_imageKey, _extension)
      )
      : await MultipartFile.fromPath(
        _imageKey,
        _file!.path!,
        contentType: MediaType(_imageKey, _extension)
      );
  }

  /// Open the image dialog picker
  Future<void> pickImage() async => await FilePicker.platform.pickFiles(
    type              : FileType.custom,
    allowedExtensions : _fileTypes,
    lockParentWindow  : true
  ).then((response) async {
    if (response != null) {
      _file       = response.files.single;
      _bytes      = response.files.single.bytes;
      _extension  = _file!.extension??'';
      _hasImage   = true;
    }
    notifyListeners();
  });

  removeImage({required bool notify}) {
    if(!kIsWeb) if(_fromLoading) if(_file != null) if(_file!.path != null) File(_file!.path!).delete();
    _file     = null;
    _bytes    = null;
    _hasImage = false;
    _error    = false;
    if(notify) notifyListeners();
  }

  showImageViewer(BuildContext context, {
    required bool blur,
    required double sigma
  }) => _bytes == null
  ? throw Exception('There is no any image loaded')
  : imageViewerDialog(
    context,
    bytes : _bytes ?? Uint8List(0),
    blur  : blur,
    sigma : sigma
  );
}