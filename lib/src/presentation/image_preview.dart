import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' show Clip, Color, FilterQuality, ImageFilter, Shadow, Size;
import 'dart:async' show Future;

/// Displays a full-screen image preview dialog with a blurred background.
///
/// This function pushes a transparent route on top of the current context,
/// showing the image provided in [bytes] with a blur effect of [sigma].
/// Optional parameters allow customization of the hero animation [tag],
/// the modal barrier color [barrierColor], whether tapping outside dismisses the dialog
/// [barrierDismissible], a custom [closeButton] widget, and the image container's [decoration].
///
/// The dialog will only be shown if [bytes] is not null.
///
/// Example usage:
/// ```dart
/// await showImagePreview(context,
///   bytes: imageData,
///   sigma: 5.0,
///   barrierDismissible: true,
/// );
/// ```
Future<void> showImagePreview( BuildContext context, {
  required final Uint8List? bytes,
  required final double sigma,
  final Object ? tag,
  final Color  ? barrierColor,
  final bool     barrierDismissible = false,
  final Widget ? closeButton,
  final BoxDecoration ? decoration
}) async {
  if(bytes != null){
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque              : false,
        barrierColor        : barrierColor,
        barrierDismissible  : barrierDismissible,
        pageBuilder         : (context, _, __) =>
        _BodyimageWebViewerDialog(
          bytes       : bytes,
          sigma       : sigma,
          tag         : tag,
          decoration  : decoration,
          closeButton : closeButton
        )
      )
    );
  }
}

/// A stateless widget that builds the image preview dialog UI.
///
/// This widget is responsible for displaying the image with a hero animation,
/// applying a blur filter to the background, and showing a close button.
/// It uses a [BackdropFilter] to blur the content behind the dialog,
/// and an [OverflowBox] to allow the image to expand within constraints.
///
/// The image is displayed inside a container with rounded corners and an optional decoration.
///
/// This widget is used internally by [showImagePreview()].
class _BodyimageWebViewerDialog extends StatelessWidget {
  final Uint8List bytes;
  final Widget?   closeButton;
  final double    sigma;
  final Object?   tag;
  final BoxDecoration ? decoration;
  const _BodyimageWebViewerDialog({
    required this.bytes,
    required this.closeButton,
    required this.sigma,
    required this.decoration,
    this.tag,
  });

  @override
  Widget build(BuildContext context) =>
  /// Ensures the UI avoids system intrusions like notches and status bars.
  SafeArea(
    child:
    LayoutBuilder(
      builder: (context, size) =>
      Material(
        color: Colors.transparent,
        child:
        /// Applies a blur effect to the background behind the dialog.
        BackdropFilter(
          filter  :
          ImageFilter.blur(
            sigmaX: sigma,
            sigmaY: sigma
          ),
          child   :
          Center(
            child:
            /// Allows the image to overflow its constraints to fill available space.
            OverflowBox(
              minWidth  : 0.0,
              minHeight : 0.0,
              maxWidth  : double.infinity,
              maxHeight : double.infinity,
              child:
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  /// Hero widget for smooth transition animations between routes.
                  Hero(
                    tag   : tag??DateTime.now().microsecondsSinceEpoch,
                    child :
                    Container(
                      clipBehavior  : Clip.hardEdge,
                      constraints   : BoxConstraints.loose(Size(size.maxWidth - 40, size.maxHeight - 40)),
                      decoration    : decoration ??
                      BoxDecoration(
                        borderRadius  : BorderRadius.circular(20),
                        border        : Border.all(width: 1, color: Theme.of(context).dividerColor, strokeAlign: BorderSide.strokeAlignOutside),
                      ),
                      child:
                      /// Displays the image from memory with high filter quality.
                      Image.memory(
                        bytes,
                        filterQuality : FilterQuality.high,
                        fit           : BoxFit.cover,
                      ),
                    )
                  ),
                  /// Close button positioned at the top-end corner.
                  MouseRegion(
                    cursor  : SystemMouseCursors.click,
                    child   : closeButton ?? _CloseCutton(),
                  ),
                ],
              ),
            ),
          )
        )
      )
    ),
  );
}

/// A simple circular red close button with an 'X' icon.
///
/// This widget is used as the default close button in the image preview dialog.
/// Tapping it dismisses the dialog by popping the current route.
class _CloseCutton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
  GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child:
    Container(
      width       : 30,
      height      : 30,
      padding     : const EdgeInsets.all(5) ,
      margin      : const EdgeInsets.all(10) ,
      decoration  :
      BoxDecoration(
        borderRadius  : BorderRadius.circular(30),
        color         : Colors.red,
      ),
      child       :
      const Icon(
        Icons.close,
        color : Colors.white,
        size  : 20,
        shadows: [Shadow(
          color: Colors.black,
          blurRadius: 2
        )],
      )
    )
  );
}
