import 'package:flutter/material.dart';
import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/application/routers/drop_router.dart' if (dart.library.html) 'package:n_image_picker/src/application/services/drop_web_service.dart' if (dart.library.io) 'package:n_image_picker/src/application/services/drop_io_service.dart';

abstract class DropInterface {
  factory DropInterface() => getInstance();

  Future<void> dragAndDrop({
    Function()? onAdd,
    required final ImageController controller
  });

  void createDiv({
    required final RenderBox renderBox,
    required final ImageController controller
  });

  void updateDiv({
    required final RenderBox renderBox,
    required final ImageController controller
  });

  void removeDiv({
    required final ImageController controller
  });
}