import 'dart:io';

import 'dart:io' show File;
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class NImagePickerController with ChangeNotifier{
  PlatformFile? _file;
  String        _imageKey  = "image";
  List<String>  _fileTypes  = const [ 'png', 'jpg', 'jpeg' ];
  String        _extension  = '';
  bool          _error      = false;
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

  set headers(Map<String, String> headers) {
    _headers = headers;
    notifyListeners();
  }

  ///Image name for [MultipartFile], is the same key
  ///for posting like {"imageKey": image}
  set imageKey(String name) {
    _imageKey = name;
    notifyListeners();
  }

  set fileTypes(List<String> fl) {
    _fileTypes = fl;
    notifyListeners();
  }

  set error(bool onError) {
    _error = onError;
    notifyListeners();
  }

  Map<String, String> get headers   =>  _headers;
  String              get imageKey  =>  _imageKey;
  PlatformFile?       get file      =>  _file;
  List<String>        get fileTypes =>  _fileTypes;
  String              get path      =>  _file?.path   ??  '';
  Uint8List           get bytes     =>  _file?.bytes  ??  Uint8List(0);
  bool                get error     =>  _error;
  Image               get image     =>  _file == null
  ? throw Exception()
  : Image.file(
    kIsWeb
    ? File.fromRawPath(_file!.bytes!)
    : File(_file!.path!)
  );


  Future<void> setFromResponse(Response r, String n) async {
    try{
      // html.Client
      final dynamic i = kIsWeb
      ? html.File( r.bodyBytes, _imageKey, headers)
      : await File('${_imageKey}.${n.split('.').last}').writeAsBytes(r.bodyBytes);

      _file = PlatformFile(
        name  : _imageKey,
        size  : kIsWeb? i.size : await i.length(),
        bytes : kIsWeb ? r.bodyBytes : null,
        path  : kIsWeb ? null : i.path
      );
      _error = false;
      notifyListeners();
    } catch (e){
      debugPrint('n_image_piker e1: $e');
      _error = true;
      notifyListeners();
    }
  }

  ///- this will be used for get a posting image
  ///- needs a key name for posting or key must be empty
  Future<MultipartFile> get multipartFile async {
    return _file == null
    ? throw Exception()
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

  Future<void> pickImage() async => await FilePicker.platform.pickFiles(
    type              : FileType.custom,
    allowedExtensions : _fileTypes,
    lockParentWindow  : true
  ).then((response) async {
    if (response != null) {
      _file = response.files.single;
      _extension = _file!.extension??'';
    }
    notifyListeners();
  });

  removeImage() {
    _file = null;
    notifyListeners();
  }
}