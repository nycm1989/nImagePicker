import 'package:flutter/material.dart';
import 'dart:ui' show Clip, Color, FilterQuality, ImageFilter, Shadow, Size;
import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show Uint8List;

Future<void> imageViewerDialog( BuildContext context, {
  required bool      blur,
  required Uint8List bytes,
  required double    sigma,
  required Object?   tag,
  required Color? closeColor,
}) async =>
Navigator.of(context).push(
  PageRouteBuilder(
    opaque             : false,
    barrierDismissible : true,
    pageBuilder        : (context, _, __) =>
    _BodyimageWebViewerDialog(
      bytes : bytes,
      blur  : blur,
      sigma : sigma,
      tag   : tag,
      closeColor: closeColor
    )
  )
);

class _BodyimageWebViewerDialog extends StatefulWidget {
  final Uint8List bytes;
  final bool      blur;
  final Color?    closeColor;
  final double    sigma;
  final Object?   tag;
  const _BodyimageWebViewerDialog({
    required this.bytes,
    required this.closeColor,
    required this.blur,
    required this.sigma,
    this.tag,
  });

  @override
  State<_BodyimageWebViewerDialog> createState() => __BodyimageWebViewerDialogState();
}

class __BodyimageWebViewerDialogState extends State<_BodyimageWebViewerDialog> {

  @override
  Widget build(BuildContext context) =>
  SafeArea(
    child:
    LayoutBuilder(
      builder: (context, size) {
        return Material(
          color: widget.blur? Colors.transparent : Colors.black.withValues(alpha: 0.3),
          child:
          BackdropFilter(
            filter  :
            ImageFilter.blur(
              sigmaX: widget.blur ? widget.sigma : 0,
              sigmaY: widget.blur ? widget.sigma : 0
            ),
            child   :
            Center(
              child:
              OverflowBox(
                minWidth: 0.0,
                minHeight: 0.0,
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child:
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                     Hero(
                       tag   : widget.tag??DateTime.now().microsecondsSinceEpoch,
                       child :
                       Container(
                         clipBehavior  : Clip.hardEdge,
                         constraints   : BoxConstraints.loose(Size(size.maxWidth - 40, size.maxHeight - 40)),
                         decoration    :
                         BoxDecoration(
                           borderRadius  : BorderRadius.circular(20),
                           border        : Border.all(width: 1, color: Theme.of(context).dividerColor, strokeAlign: BorderSide.strokeAlignOutside),
                         ),
                         child:
                         Image.memory(
                           widget.bytes,
                           filterQuality : FilterQuality.high,
                           fit           : BoxFit.cover,
                         ),
                       )
                     ),
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
                          color         : widget.closeColor??Colors.red,
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
                    ),
                  ],
                ),
              ),
            )
          )
        );
      }
    ),
  );
}

