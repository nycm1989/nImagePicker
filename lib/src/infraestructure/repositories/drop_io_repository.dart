import 'package:flutter/material.dart';

import 'dart:async' show Future;
import 'package:n_image_picker/src/presentation/image_controller.dart' show ImageController;
import 'package:n_image_picker/src/domain/interfaces/drop_interface.dart' show DropInterface;


DropInterface getInstance() => DropIoRepository();

class DropIoRepository implements DropInterface{
  @override
  Future<void> dragAndDrop({required final ImageController controller, Function()? onAdd}) async {}

  @override
  void createDrop({required final RenderBox renderBox, required final ImageController controller}) {}

  @override
  void updateDrop({required final RenderBox renderBox, required final ImageController controller}) {}

  @override
  void removeDrop({required final ImageController controller}) {}

  @override
  void hideDrop() {}

  @override
  void showDrop() {}
}