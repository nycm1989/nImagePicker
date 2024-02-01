import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'controller.dart';

class NImagePicker extends StatefulWidget {
  final NImagePickerController    controller;
  final Future<void> Function()?  onTap;
  final String                    onLoadingImage;
  final BoxFit                    imageFit;
  final double                    width, height;
  final double                    filterOpacity;
  final Widget?                   emptyWidget, filledWidget, onErrorWidget, onLoadingWidget;
  final EdgeInsetsGeometry        margin;
  final Color?                    bankgroundColor;
  final BorderRadius?             borderRadius;
  final Border?                   border;
  final BoxShadow?                shadow;
  final bool                      readOnly;
  final BoxFit                    fit;
  final bool                      viewerBlur;
  final double                    viewerBlurSigma;
  final bool                      previewBlur;
  final double                    previewBlurSigma;

  const NImagePicker({
    required this.controller,
    ///Only load image from https or http
    this.onLoadingImage = '',
    this.imageFit       = BoxFit.cover,
    this.margin         = EdgeInsets.zero,
    this.readOnly       = false,
    this.fit            = BoxFit.cover,
    this.filterOpacity  = 0.2,
    this.bankgroundColor,
    this.shadow,
    this.onTap,
    this.borderRadius,
    this.border,
    this.width  = 100,
    this.height = 100,
    this.emptyWidget,
    this.filledWidget,
    this.onErrorWidget,
    this.onLoadingWidget,
    this.viewerBlur        = true,
    this.viewerBlurSigma   = 5.0,
    this.previewBlur       = false,
    this.previewBlurSigma  = 5.0,
    super.key
  });

  @override
  State<NImagePicker> createState() => _NImagePickerState();
}

class _NImagePickerState extends State<NImagePicker> {
  StreamController<bool>? streamController;

  startLoading() async {
    if(widget.onLoadingImage != ''){
      try {
        List<String> list = widget.onLoadingImage.split("://");
        if (list.length <= 0) {
          FormatException("there is not a valid URL");
          widget.controller.error = false;
          widget.controller.fromLoading = false;
        }
        String type = list.first;
        list = list.last.split("/");
        String domain = list.first;
        list.remove(domain);
        String path = list.join("/");

        streamController = StreamController<bool>();
        setState(()=> streamController?.add(true));

        await get(
          type == 'https'? Uri.https(domain, path) : Uri.http(domain, path),
          headers: widget.controller.headers
        ).then((r) async {
          if(r.statusCode == 200){
            widget.controller.setFromResponse(response: r, url: widget.onLoadingImage);
            widget.controller.fromLoading = true;
            widget.controller.error = false;
          } else{
            widget.controller.fromLoading = false;
            widget.controller.error = true;
          }
          streamController?.close();
          streamController = null;
          setState(()=> widget.controller.error = false);
        });
      } catch (e) {
        debugPrint('n_image_piker e2: $e');
        streamController?.close();
        streamController = null;
        setState(()=> widget.controller.error = true);
      }
    } else {
      streamController = null;
      streamController?.close();
    }
  }

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  @override
  void reassemble() {
    super.reassemble();
    streamController?.close();
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream  : streamController?.stream,
      builder : (context, snapshot) =>
      Container(
        decoration    : BoxDecoration(
          color: widget.bankgroundColor,
          image: widget.controller.file == null ? null : DecorationImage(
            image : Image.memory(widget.controller.file!.bytes!).image,
            fit   : widget.fit,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(widget.filterOpacity),
              BlendMode.darken
            ),
          ),
          borderRadius: widget.borderRadius,
          border      : widget.border?.add(Border.all(strokeAlign: BorderSide.strokeAlignOutside)),
          boxShadow   : widget.shadow == null ? null : [widget.shadow!]
        ),
        margin        : widget.margin,
        width         : widget.width,
        height        : widget.height,
        clipBehavior  : Clip.hardEdge,
        child         :
        BackdropFilter(
          filter  :
          ImageFilter.blur(
            sigmaX: widget.previewBlur ? widget.previewBlurSigma : 0,
            sigmaY: widget.previewBlur ? widget.previewBlurSigma : 0
          ),
          child   :
          snapshot.connectionState == ConnectionState.none
          ? widget.controller.error
            ? InkWell(
              onTap        : widget.readOnly ? null : ()=> widget.controller.removeImage(notify: true),
              borderRadius : widget.borderRadius,
              child        : widget.onErrorWidget??
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding : EdgeInsets.only(bottom: 10),
                    child   :
                    Icon(
                      Icons.error_outline,
                      size    : 40,
                      color   : Colors.white,
                      shadows : [Shadow(color: Colors.black, blurRadius: 10)]
                    ),
                  ),
                  Text(
                    "SOMETHING GET WORNG",
                    style:
                    TextStyle(
                      color   : Colors.white,
                      shadows : [Shadow(color: Colors.black, blurRadius: 10)]
                    )
                  )
                ],
              ),
            )
            : widget.controller.file == null
              ? InkWell(
                borderRadius : widget.borderRadius,
                onTap        : widget.readOnly ? null : () => widget.controller.pickImage(),
                child        : widget.emptyWidget ??
                  const Icon(
                    Icons.image_outlined,
                    size    : 40,
                    color   : Colors.white,
                    shadows : [Shadow(color: Colors.black, blurRadius: 10)]
                  )
                )
              : widget.filledWidget ?? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: ()=> widget.controller.removeImage(notify: true),
                    child:
                    Container(
                      width   : 40,
                      height  : 40,
                      color   : Colors.transparent,
                      child   :
                      const Icon(
                        Icons.delete_outline,
                        size    : 40,
                        color   : Colors.white,
                        shadows : [
                          Shadow(color: Colors.black, blurRadius: 10),
                          Shadow(color: Colors.black, blurRadius: 5 ),
                          Shadow(color: Colors.grey,  blurRadius: 2 ),
                        ]
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                    widget.controller.showImageViewer(
                      context,
                      blur  : widget.viewerBlur,
                      sigma : widget.previewBlurSigma
                    ),
                    child: Container(
                      width   : 40,
                      height  : 40,
                      color   : Colors.transparent,
                      child   :
                      Icon(
                        Icons.zoom_out_map_rounded,
                        size    : 40,
                        color   : widget.controller.file == null ? Colors.grey : Colors.white,
                        shadows : [
                          Shadow(color: Colors.black, blurRadius: 10),
                          Shadow(color: Colors.black, blurRadius: 5 ),
                          Shadow(color: Colors.grey,  blurRadius: 2 ),
                        ]
                      ),
                    ),
                  )
                ],
              )
            : widget.onLoadingWidget ?? const Center( child: CircularProgressIndicator(strokeWidth: 2) ),
        )
      )
    );
  }
}