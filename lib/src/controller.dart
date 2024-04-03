import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:n_image_picker/src/image_viewer_dialog.dart';
import 'package:n_image_picker/src/platform_tools.dart';

class NImagePickerController with ChangeNotifier{
  PlatformFile ? _file;
  Uint8List    ? _bytes;
  List<String>   _fileTypes     = const [ 'png', 'jpg', 'jpeg' ];
  String         _extension     = '';
  bool           _error         = false;
  bool           _hasImage      = false;
  bool           _fromLoading   = false;
  Map<String, String> _headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
    "origin": "*",
    "method": "GET",
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

  /// List of supported formats
  List<String>        get fileTypes   =>  _fileTypes;

  PlatformFile?       get file        =>  _file;
  String              get path        =>  _file?.path ??  '';
  Uint8List?          get bytes       =>  _bytes;
  bool                get error       =>  _error;
  bool                get hasImage    =>  _hasImage;
  bool                get hasNoImage  =>  !_hasImage;
  bool                get fromLoading =>  _fromLoading;
  // Image               get image       =>  _file == null
  // ? throw Exception()
  // : Image.file( File.fromRawPath(_file!.bytes!) );

  _reset({required bool error}){
    _file         = null;
    _bytes        = null;
    _error        = error;
    _hasImage     = false;
    _extension    = '';
    _fromLoading  = false;
    notifyListeners();
  }

  Future<bool>setFromURL(BuildContext context, {required String url, Map<String, String>? headers}) async {
    List<String> list = url.split("://");
    if (list.length <= 1) throw Exception("The URL is not valid");

    String type = list.first.toLowerCase();
    list = list.last.split("/");
    String domain = list.first;
    list.remove(domain);
    String path = list.join("/");

    List<String> _n = list.last.split(".");
    if (_n.length <= 1) throw Exception("URL dont have extension");
    if (_n.length != 2) throw Exception("URL dont have a valid image");

    Request request = Request(
      "GET",
      type.toLowerCase() == 'https'
      ? Uri.https(domain, path, headers)
      : Uri.http(domain, path, headers)
    );

    request.followRedirects = false;
    return await request.send().then((value) async{
      if(value.statusCode == 200){
        try{
          await value.stream.toBytes().then((bytes) async => await setFromBytes(
            name      : DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(10000).toString() + '-' + _n.first,
            bytes     : bytes,
            extension : _n.last
          ));

          return true;
        } catch (e) {
          _reset(error: true);
          return false;
        }
      } else {
        _reset(error: true);
        return false;
      }
    });
  }


  Future<void> setFromBytes({required final String name, required final String extension, required final Uint8List? bytes}) async {
    if(bytes == null) throw Exception("bytes cant be null");
    await PlatformTools().w(name: name, extension: extension, bytes: bytes).then((_f) {
      _file      = _f;
      _bytes     = bytes;
      _error     = false;
      _hasImage  = true;
      _extension = extension;
      notifyListeners();
    }).onError((error, stackTrace) => _reset(error: true));
  }


  /// Set the image file from http response and url
  Future<void> setFromResponse({required Response response, required String url}) async {
    List<String> _e = url.split(".");
    if (_e.length <= 1) throw Exception("url dont have extension");

    try{
      kIsWeb
      ? await PlatformTools().setFile(response: response, headers: headers).then((r) {
        _file       = r.platformFile;
        _bytes      = r.platformFile.bytes;
        _error      = r.error;
        _hasImage   = !r.error;
        _extension  = _e.last;
        notifyListeners();
      })
      : await PlatformTools().setFile(response: response).then((r) {
        _file     = r.platformFile;
        _bytes    = r.platformFile.bytes;
        _error    = r.error;
        _hasImage = !r.error;
        _extension  = _e.last;
        notifyListeners();
      });
    } catch (e){
      debugPrint('n_image_piker e1: $e');
      _reset(error: true);
      notifyListeners();
    }
  }


  /// This dont work in web!
  Future<void> setFromPath({required String path}) async {
    List<String> _e = path.split(".");
    if (_e.length <= 1) throw Exception("path dont have extension");

    if(kIsWeb){
      throw Exception('This dont work in web');
    } else {
      try{
        await PlatformTools().setFileFromPath(path).then((r) {
          _file     = r.platformFile;
          _bytes    = _file?.bytes;
          _error    = r.error;
          _hasImage = !r.error;
          notifyListeners();
        });
      } catch (e){
        debugPrint('n_image_piker e1: $e');
        _reset(error: true);
        notifyListeners();
      }
    }
  }

  /// return an async [MultipartFile] for uploading using [key], example:
  /// - {"key" : "image_path.png"}
  Future<MultipartFile> image({String key = "image"}) async =>
  _file == null
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
  Future<void> pickImage() async => await FilePicker.platform.pickFiles(
    type              : FileType.custom,
    allowedExtensions : _fileTypes,
    lockParentWindow  : true,
    allowMultiple     : false,
    withData          : true
  ).then((response) async {
    if (response == null) {
      _reset(error: true);
    } else {
      _file       = response.files.single;
      _bytes      = _file?.bytes;
      _extension  = _file?.extension??'';
      _hasImage   = true;
    }
    notifyListeners();
  });

  removeImage({required bool notify}) {
    _reset(error: false);
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