library n_image_picker_view;

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'image_controller.dart';

class ImageBody extends StatefulWidget {
  final ImageController?          controller;
  final Future<void> Function() ? onTap;
  final String                  ? onLoadingImage;
  final double                  ? width;
  final double                  ? height;
  final double                  ? filterOpacity;
  final Widget                  ? emptyWidget;
  final Widget                  ? filledWidget;
  final Widget                  ? onErrorWidget;
  final Widget                  ? onLoadingWidget;
  final EdgeInsetsGeometry      ? margin;
  final Color                   ? bankgroundColor;
  final BorderRadius            ? borderRadius;
  final Border                  ? border;
  final BoxShadow               ? shadow;
  final bool                    ? readOnly;
  final BoxFit                  ? fit;
  final bool                    ? viewerBlur;
  final double                  ? viewerBlurSigma;
  final bool                    ? previewBlur;
  final double                  ? previewBlurSigma;
  final BoxShape                ? shape;
  final Object                  ? tag;
  final Duration                ? duration;
  final Color                   ? closeColor;

  //only for viewer
  final Map<String, String>     ? headers;

  const ImageBody({
    this.controller,
    ///Only load image from https or http
    this.onLoadingImage,
    this.margin             = EdgeInsets.zero,
    this.readOnly           = false,
    this.fit                = BoxFit.cover,
    this.filterOpacity      = 0.2,
    this.bankgroundColor,
    this.shadow,
    this.onTap,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
    this.emptyWidget,
    this.filledWidget,
    this.onErrorWidget,
    this.onLoadingWidget,
    this.viewerBlur         = true,
    this.viewerBlurSigma    = 5.0,
    this.previewBlur        = false,
    this.previewBlurSigma   = 5.0,
    this.shape              = BoxShape.rectangle,
    this.headers,
    this.tag,
    this.duration,
    this.closeColor,
    super.key
  });

  @override
  State<ImageBody> createState() => __ImageState();
}

class __ImageState extends State<ImageBody> {
  StreamController<bool>? streamController;
  Uint8List? image;
  bool error = false;

  startLoading() async {
    if(streamController != null) streamController == null;
    if(widget.onLoadingImage != null){
      try {
        streamController = StreamController<bool>();
        setState(()=> streamController?.add(true));
        if(widget.controller != null){
          await  widget.controller!.setFromURL(
            context,
            url     : widget.onLoadingImage!,
            headers : widget.controller!.headers
          ).then((state) async {
            streamController?.close();
            streamController = null;
            setState((){
              if(state){
                widget.controller!.fromLoading = true;
                widget.controller!.error       = false;
              } else{
                widget.controller!.fromLoading = false;
                widget.controller!.error       = true;
              }
            });
          }).onError((error, stackTrace) {
            streamController?.close();
            streamController = null;
            widget.controller!.fromLoading = false;
            widget.controller!.error       = true;
          });
        } else {
          ImageController memoryController = ImageController();
          if (widget.headers != null) memoryController.headers = widget.headers!;
          await memoryController.setFromURL(
            context,
            url     : widget.onLoadingImage!,
            headers : memoryController.headers
          ).then((state) async {
            streamController?.close();
            streamController = null;
            setState((){
              if(state){
                try{
                  image = memoryController.file!.bytes!;
                  error = false;
                } catch (e) {
                  image = null;
                  error = true;
                }
              } else{
                image = null;
                error = true;
              }
            });
          }).onError((error, stackTrace) {
            streamController?.close();
            streamController = null;
            try{
              setState(()=> widget.controller?.error = true);
            } catch(e){}
          });
        }
      } catch (e) {
        streamController?.close();
        streamController = null;
        try{
          setState(()=> widget.controller?.error = true);
        } catch(e){}
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
  void didUpdateWidget(covariant ImageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null) {
      if(widget.onLoadingImage != oldWidget.onLoadingImage) startLoading();
    } else {
      if(widget.controller != oldWidget.controller) startLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag   : widget.tag??Random().nextInt(100000),
      child :
      AnimatedContainer(
        duration      : widget.duration??Duration(milliseconds: 250),
        margin        : widget.margin,
        width         : widget.width,
        height        : widget.height,
        clipBehavior  : Clip.hardEdge,
        decoration    :
        BoxDecoration(
          shape        : widget.shape??BoxShape.rectangle,
          color        : widget.bankgroundColor??Colors.transparent,
          borderRadius : widget.borderRadius,
          border       : widget.border?.add(Border.all(strokeAlign: BorderSide.strokeAlignOutside)),
          boxShadow    : widget.shadow == null ? null : [widget.shadow!],
          image        : widget.controller == null
          ? image == null
            ? null
            : DecorationImage(
              image       : Image.memory(image!).image,
              fit         : widget.fit,
              colorFilter : widget.controller == null
              ? null
              : ColorFilter.mode(
                Colors.black.withOpacity(widget.filterOpacity??0),
                BlendMode.darken
              ),
            )
          : widget.controller!.file == null
            ? null
            : DecorationImage(
              image       : Image.memory(widget.controller!.file!.bytes!).image,
              fit         : widget.fit,
              colorFilter :
              ColorFilter.mode(
                Colors.black.withOpacity(widget.filterOpacity??0),
                BlendMode.darken
              ),
            ),
        ),
        child         :
        StreamBuilder<bool>(
          stream  : streamController?.stream,
          builder : (context, snapshot) =>
          BackdropFilter(
            filter  :
            ImageFilter.blur(
              sigmaX: (widget.previewBlur??false) ? widget.previewBlurSigma??0 : 0,
              sigmaY: (widget.previewBlur??false) ? widget.previewBlurSigma??0 : 0
            ),
            child   :
            snapshot.connectionState == ConnectionState.none
            ? widget.controller == null
              ? error
                ? Container(
                    decoration: BoxDecoration(borderRadius : widget.borderRadius),
                    child        : widget.onErrorWidget??
                    Icon(
                      Icons.error_outline,
                      size    : 80,
                      color   : Colors.red,
                    ),
                )
              : SizedBox.shrink()
            : widget.controller!.error
              ? GestureDetector(
                onTap        : (widget.readOnly??false) ? null : ()=> widget.controller!.removeImage(notify: true),
                child:
                MouseRegion(
                  cursor  : SystemMouseCursors.click,
                  child        : widget.onErrorWidget??
                  Icon(
                    Icons.error_outline,
                    size    : 80,
                    color   : Colors.red,
                  ),
                ),
              )
              : widget.controller!.file == null
                ? GestureDetector(
                  onTap : (widget.readOnly??false) ? null : () => widget.controller!.pickImage(),
                  child :
                  MouseRegion(
                    cursor  : SystemMouseCursors.click,
                    child        : widget.emptyWidget ??
                      const Icon(
                        Icons.file_upload_outlined,
                        size    : 80,
                        color   : Colors.grey,
                        // shadows : [Shadow(color: Colors.grey, blurRadius: 2)]
                      )
                    ),
                )
                : widget.filledWidget ?? Row(
                  mainAxisAlignment: (widget.readOnly??false)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly,
                  children: [
                    if(!(widget.readOnly??false))
                    GestureDetector(
                      onTap: ()=> widget.controller!.removeImage(notify: true),
                      child:
                      MouseRegion(
                        cursor  : SystemMouseCursors.click,
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
                    ),
                    GestureDetector(
                      onTap: () =>
                      widget.controller?.showImageViewer(
                        context,
                        tag   : widget.tag,
                        blur  : widget.viewerBlur??false,
                        sigma : widget.previewBlurSigma??0,
                        closeColor: widget.closeColor
                      ),
                      child:
                      MouseRegion(
                        cursor  : SystemMouseCursors.click,
                        child   :
                        Container(
                          width   : 40,
                          height  : 40,
                          color   : Colors.transparent,
                          child   :
                          Icon(
                            Icons.zoom_out_map_rounded,
                            size    : 40,
                            color   : widget.controller?.file == null ? Colors.grey : Colors.white,
                            shadows : [
                              Shadow(color: Colors.black, blurRadius: 10),
                              Shadow(color: Colors.black, blurRadius: 5 ),
                              Shadow(color: Colors.grey,  blurRadius: 2 ),
                            ]
                          ),
                        ),
                      ),
                    )
                  ],
                )
            : widget.onLoadingWidget ?? const Center(
              child:
              SizedBox.square(
                dimension : 60,
                child     :
                CircularProgressIndicator(
                  strokeWidth : 2,
                  color       : Colors.grey,
                  strokeCap   : StrokeCap.round,
                )
              )
            ),
          )
        )
      ),
    );
  }
}