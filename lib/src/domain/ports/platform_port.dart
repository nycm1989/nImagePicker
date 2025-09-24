import 'package:flutter/material.dart' show RenderBox;
import 'package:flutter/services.dart' show Uint8List;
import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/infraestructure/instances/platform_instance.dart' if (dart.library.html) 'package:n_image_picker/src/infraestructure/adapters/platform_html_adapter.dart' if (dart.library.io) 'package:n_image_picker/src/infraestructure/adapters/platform_io_adapter.dart' show getInstance;


abstract class PlatformPort {
  factory PlatformPort() => getInstance();

  bool requirePath();

  Uint8List getBytesFromPath(String path);

  void attachDropBody({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode
  });

  void attachDropZone({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode
  });

  void showDropZone({
    required final RenderBox renderBox,
    required int hashCode
  });

  void hideDropZone({
    required final int hashCode,
  });

  void removeDropZone({
    required final int hashCode,
  });

}