import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:n_image_picker/src/domain/models/forbidden_model.dart' show ForbiddenModel;

class HttpService {
  // final ImageInterface _imageInterface;
  // HttpService(this._imageInterface);
  // Future<ResponseModel> downloadImage(final Map<String, String>? headers) async =>

  static Future<Uint8List?> downloadImage({required final Map<String, String>? headers, required final String url}) async {
    ForbiddenModel _forbidden = ForbiddenModel();
    if(url.contains(_forbidden.toString())) return null;

    Request request = Request("GET", Uri.parse(url))..followRedirects = false;
    if (headers != null) request.headers.addAll(headers);

    return await request
    .send()
    .then((value) async {
      if (value.statusCode == 200) {
        try {
          return await value.stream.toBytes().then((bytes) => bytes);
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    })
    .onError((error, stackTrace) async { return null; });
  }
}