import 'package:flutter/material.dart' show RenderBox;
import 'package:flutter/services.dart' show Uint8List;
import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/infraestructure/instances/platform_instance.dart' if (dart.library.html) 'package:n_image_picker/src/infraestructure/adapters/platform_html_adapter.dart' if (dart.library.io) 'package:n_image_picker/src/infraestructure/adapters/platform_io_adapter.dart' show getInstance;


abstract class PlatformPort {
  factory PlatformPort() => getInstance();

  /// Returns whether the platform requires a file path for image operations.
  ///
  /// This implementation returns `true` if the current platform is macOS,
  /// indicating that a file path is required on macOS.
  bool requirePath();

  /// Reads and returns the bytes from the file located at the given [path].
  ///
  /// This method uses synchronous file reading via [File.readAsBytesSync].
  Uint8List getBytesFromPath(String path);

  /// Attaches a drop body area for drag-and-drop operations.
  ///
  /// This method is intended to register a drop target area using the given
  /// [controller], [renderBox], and unique [hashCode].
  void attachDropBody({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode
  });

  /// Attaches a drop zone for drag-and-drop operations.
  ///
  /// This method is intended to register a drop zone using the given
  /// [controller], [renderBox], and unique [hashCode].
  void attachDropZone({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode
  });

  /// Hides the drop zone identified by the given [hashCode].
  void showDropZone({
    required final RenderBox renderBox,
    required int hashCode
  });

  /// Shows the drop zone associated with the given [renderBox] and [hashCode].
  void hideDropZone({
    required final int hashCode,
  });

  /// Removes the drop zone identified by the given [hashCode].
  void removeDropZone({
    required final int hashCode,
  });

  Future<Uint8List?> getCacheData({
    required String url
  });

  Future<bool> putCacheData({
    required String url,
    required Uint8List bytes,
  });
}