import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:n_image_picker/src/custom_file.dart';
import 'package:n_image_picker/src/image_viewer_dialog.dart';

class NImagePickerController with ChangeNotifier{
  PlatformFile ? _file;
  Uint8List    ? _bytes;
  String         _imageKey      = "image";
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
  // Image               get image       =>  _file == null
  // ? throw Exception()
  // : Image.file( File.fromRawPath(_file!.bytes!) );

  _reset({required bool error}){
    _file         = null;
    _bytes        = null;
    _error        = error;
    _hasImage     = false;
    _fromLoading  = false;
    notifyListeners();
  }

  Future<bool>setFromURL(BuildContext context, {required String url, required Map<String, String> headers}) async{
    List<String> list = url.split("://");
    String type = list.first.toLowerCase();
    list = list.last.split("/");
    String domain = list.first;
    list.remove(domain);
    String path = list.join("/");

    Request request = Request("GET",type == 'https' ? Uri.https(domain, path) : Uri.http(domain, path));
    request.followRedirects = false;
    return await request.send().then((value) async{
      if(value.statusCode == 200){
        try{
          value.stream.toBytes().then((bytes)=> setFromBytes(
            name  : url +  Random().nextInt(10000).toString(),
            bytes : bytes
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

  setFromBytes({required final String name, required final Uint8List? bytes}){
    try{
      if(bytes != null){
        _file = PlatformFile(
          name  : name,
          size  : bytes.length,
          bytes : bytes,
        );
        _bytes    = bytes;
        _error    = false;
        _hasImage = false;
        notifyListeners();
      } else {
        _reset(error: true);
      }
    } catch (e){
      print(e);
      _reset(error: true);
    }
  }

  /// Set the image file from http response and url
  Future<void> setFromResponse({required Response response, required String url}) async {
    try{
      kIsWeb
      ? await CustomFile().setFile(response: response, key: _imageKey, headers: headers).then((r) {
        _file     = r.platformFile;
        _bytes    = r.platformFile.bytes;
        _error    = r.error;
        _hasImage = !r.error;
        notifyListeners();
      })
      : await CustomFile().setFile(response: response).then((r) {
        _file     = r.platformFile;
        _bytes    = r.platformFile.bytes;
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

  /// This dont work in web!
  Future<void> setFromPath({required String path}) async {
    if(kIsWeb){
      throw Exception('This dont work in web');
    } else {
      try{
        await CustomFile().setFileFromPath(path).then((r) {
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