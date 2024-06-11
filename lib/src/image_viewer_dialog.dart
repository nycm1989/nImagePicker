import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    Material(
      color: widget.blur? Colors.transparent : Colors.black.withOpacity(0.3),
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
          IntrinsicWidth(
            child:
            IntrinsicHeight(
              child:
              Stack(
                children: [
                  Hero(
                    tag   : widget.tag??DateTime.now().microsecondsSinceEpoch,
                    child :
                    Container(
                      margin        : const EdgeInsets.all(20),
                      alignment     : Alignment.center,
                      child:
                      Container(
                        clipBehavior  : Clip.hardEdge,
                        decoration    :
                        BoxDecoration(
                          borderRadius  : BorderRadius.circular(20),
                          border        : Border.all(width: 1, color: Theme.of(context).dividerColor),
                        ),
                        child:
                        Image.memory(
                          widget.bytes,
                          isAntiAlias: true,
                          filterQuality : FilterQuality.high,
                          fit           : BoxFit.contain,
                        ),
                      ),
                    )
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child:
                      Container(
                        width: 30,
                        height: 30,
                        padding     : const EdgeInsets.all(5) ,
                        margin      : const EdgeInsets.all(30) ,
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
                  ),
                ],
              ),
            ),
          ),
        )
      )
    ),
  );
}

