import 'dart:ui' show Size;
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:http/http.dart' show MultipartFile;

/// Data transfer object (DTO) for representing image or file data.
///
/// This class encapsulates the essential information about a file,
/// including its [bytes], [name], [extension], and a [MultipartFile] reference.
/// It can also optionally store a unique [key] and the file's [size].
class DataDTO {
  /// Optional unique identifier for this data object.
  String? key;

  /// Optional dimensions of the file (for images).
  Size? size;

  /// Raw file data represented as [Uint8List].
  Uint8List bytes;

  /// Name of the file without the extension.
  String name;

  /// File extension (e.g., "jpg", "png", "pdf").
  String extension;

  /// Associated [MultipartFile] for uploading or API requests.
  MultipartFile multipartFile;

  /// Creates a new [DataDTO] instance.
  ///
  /// - [key] is optional and can be used to uniquely identify the file.
  /// - [size] is optional and typically used for image dimensions.
  /// - [bytes], [name], [extension], and [multipartFile] are required.
  DataDTO({
    this.key,
    this.size,
    required this.bytes,
    required this.name,
    required this.extension,
    required this.multipartFile,
  });
}