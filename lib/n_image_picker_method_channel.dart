import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'n_image_picker_platform_interface.dart';

/// An implementation of [NImagePickerPlatform] that uses method channels.
class MethodChannelNImagePicker extends NImagePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('n_image_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
