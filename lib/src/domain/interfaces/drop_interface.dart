import 'package:flutter/material.dart';
import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/infraestructure/instances/drop_instance.dart' if (dart.library.html) 'package:n_image_picker/src/infraestructure/repositories/drop_web_repository.dart' if (dart.library.io) 'package:n_image_picker/src/infraestructure/repositories/drop_io_repository.dart';

abstract class DropInterface {
  factory DropInterface() => getInstance();

  Future<void> dragAndDrop({
    Function()? onAdd,
    required final ImageController controller
  });

  void createDrop({
    required final RenderBox renderBox,
    required final ImageController controller
  });

  void updateDrop({
    required final RenderBox renderBox,
    required final ImageController controller
  });

  void removeDrop({
    required final ImageController controller
  });

  void hideDrop();

  void showDrop();
}