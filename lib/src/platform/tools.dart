import 'package:flutter/material.dart';
import './router.dart' if (dart.library.html) './web.dart' if (dart.library.io) './io.dart';

import 'package:http/http.dart' show Response;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:flutter/foundation.dart' show Uint8List;

import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/response_model.dart' show ResponseModel;


abstract class PlatformTools{
  factory PlatformTools() => getInstance();

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

  Future<void> dragAndDrop({Function()? onAdd, required final ImageController controller});
  void createDiv({required final RenderBox renderBox, required final ImageController controller});
  void updateDiv({required final RenderBox renderBox, required final ImageController controller});
  void removeDiv({required final ImageController controller});
}