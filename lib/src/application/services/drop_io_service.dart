import 'package:flutter/material.dart';

import 'dart:async' show Future;
import 'package:n_image_picker/src/presentation/image_controller.dart' show ImageController;
import 'package:n_image_picker/src/domain/interfaces/drop_interface.dart' show DropInterface;


DropInterface getInstance() => DropIoService();

class DropIoService implements DropInterface{
  @override
  Future<void> dragAndDrop({required final ImageController controller, Function()? onAdd}) async {}

  @override
  void createDiv({required final RenderBox renderBox, required final ImageController controller}) {}

  @override
  void updateDiv({required final RenderBox renderBox, required final ImageController controller}) {}

  @override
  void removeDiv({required final ImageController controller}) {}
}