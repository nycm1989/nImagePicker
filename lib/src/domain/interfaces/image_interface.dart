import 'package:http/http.dart' show Response;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/foundation.dart' show Uint8List;

import 'package:n_image_picker/src/domain/models/response_model.dart' show ResponseModel;
import 'package:n_image_picker/src/application/routers/image_router.dart' if (dart.library.html) 'package:n_image_picker/src/application/services/image_web_service.dart' if (dart.library.io) 'package:n_image_picker/src/application/services/image_io_service.dart';

abstract class ImageInterface{
  factory ImageInterface() => getInstance();

  Future<ResponseModel> setFile({
    required final Response response,
    final Map<String, dynamic>? headers,
    final int? maxSize,
    final String? extension
  });

  Future<ResponseModel> setFileFromPath({
    required final String path,
    required final int? maxSize
  });


  Future<PlatformFile> write({
    required final String     name,
    required final String     extension,
    required final Uint8List? bytes,
    required final int?       maxSize,
  });

  void remove(final PlatformFile file);
}