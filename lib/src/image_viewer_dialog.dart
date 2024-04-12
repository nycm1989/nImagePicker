import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> imageViewerDialog( BuildContext context, {
  required bool      blur,
  required Uint8List bytes,
  required double    sigma,
  required Object?   tag
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
    )
  )
);

class _BodyimageWebViewerDialog extends StatefulWidget {
  final Uint8List bytes;
  final bool      blur;
  final double    sigma;
  final Object?   tag;
  const _BodyimageWebViewerDialog({
    required this.bytes,
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
        Stack(
          children: [
            SizedBox.expand(
              child:
              Hero(
                tag   : widget.tag??DateTime.now().microsecondsSinceEpoch,
                child :
                Container(
                  margin : const EdgeInsets.all(20),
                  decoration    :
                  BoxDecoration(
                    image : DecorationImage(
                      image : Image.memory(widget.bytes).image,
                    )
                  )
                )
              ),
            ),
            Positioned(
              right : 25,
              top   : 25,
              child :
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child:
                Container(
                  padding     : const EdgeInsets.all(5) ,
                  margin      : const EdgeInsets.all(5) ,
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
              )
            )
          ]
        )
      )
    )
  );
}