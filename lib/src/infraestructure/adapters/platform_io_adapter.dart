import 'dart:io' show File, Platform;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/src/rendering/box.dart' show RenderBox;
import 'package:n_image_picker/n_image_picker.dart' show ImageController;
import 'package:n_image_picker/src/domain/ports/platform_port.dart' show PlatformPort;

/// Returns an instance of [PlatformIOAdapter], which implements [PlatformPort].
PlatformPort getInstance() => PlatformIOAdapter();

/// Adapter class that provides platform-specific implementations for
/// file and drag-and-drop operations on IO platforms (e.g., macOS, Windows, Linux).
///
/// This class implements the [PlatformPort] interface to provide
/// methods for checking platform requirements, reading bytes from file paths,
/// and managing drag-and-drop zones.
///
/// Note: The drag-and-drop related methods throw [UnimplementedError]
/// because they are not yet implemented for IO platforms in this adapter.
class PlatformIOAdapter implements PlatformPort{

  /// Returns whether the platform requires a file path for image operations.
  ///
  /// This implementation returns `true` if the current platform is macOS,
  /// indicating that a file path is required on macOS.
  @override
  bool requirePath() => Platform.isMacOS;


  /// Reads and returns the bytes from the file located at the given [path].
  ///
  /// This method uses synchronous file reading via [File.readAsBytesSync].
  @override
  Uint8List getBytesFromPath(String path) => File(path).readAsBytesSync();


  /// Attaches a drop body area for drag-and-drop operations.
  ///
  /// This method is intended to register a drop target area using the given
  /// [controller], [renderBox], and unique [hashCode].
  ///
  /// Currently, this method throws [UnimplementedError] as drag-and-drop
  /// functionality is not implemented for IO platforms in this adapter.
  @override
  void attachDropBody({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode
  }) {
    throw UnimplementedError();
  }


  /// Attaches a drop zone for drag-and-drop operations.
  ///
  /// This method is intended to register a drop zone using the given
  /// [controller], [renderBox], and unique [hashCode].
  ///
  /// Currently, this method throws [UnimplementedError] as drag-and-drop
  /// functionality is not implemented for IO platforms in this adapter.
  @override
  void attachDropZone({
    required final ImageController controller,
    required final RenderBox renderBox,
    required final int hashCode
  }) {
    throw UnimplementedError();
  }


  /// Hides the drop zone identified by the given [hashCode].
  ///
  /// Currently, this method throws [UnimplementedError] as drag-and-drop
  /// functionality is not implemented for IO platforms in this adapter.
  @override
  void hideDropZone({required int hashCode}) {
    throw UnimplementedError();
  }


  /// Shows the drop zone associated with the given [renderBox] and [hashCode].
  ///
  /// Currently, this method throws [UnimplementedError] as drag-and-drop
  /// functionality is not implemented for IO platforms in this adapter.
  @override
  void showDropZone({
    required final RenderBox renderBox,
    required int hashCode
  }) {
    throw UnimplementedError();
  }


  /// Removes the drop zone identified by the given [hashCode].
  ///
  /// Currently, this method throws [UnimplementedError] as drag-and-drop
  /// functionality is not implemented for IO platforms in this adapter.
  @override
  void removeDropZone({required final int hashCode}) {
    throw UnimplementedError();
  }
}