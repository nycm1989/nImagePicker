library n_image_picker_view;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:n_image_picker/n_image_picker.dart';

export '/src/controller.dart';

class NImagePicker extends StatefulWidget {
  final NImagePickerController?   controller;
  final Future<void> Function()?  onTap;
  final String?                   onLoadingImage;
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
    this.controller,
    ///Only load image from https or http
    this.onLoadingImage,
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
  Uint8List? image;
  bool error = false;

  startLoading() async {
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
          });
        } else {
          NImagePickerController memoryController = NImagePickerController();
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
          });
        }
      } catch (e) {
        streamController?.close();
        streamController = null;
        setState(()=> widget.controller?.error = true);
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
  void didUpdateWidget(covariant NImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null) {
      if(widget.onLoadingImage != oldWidget.onLoadingImage) startLoading();
    } else {
      if(widget.controller != oldWidget.controller) startLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream  : streamController?.stream,
      builder : (context, snapshot) =>
      Container(
        decoration    :
        BoxDecoration(
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
                Colors.black.withOpacity(widget.filterOpacity),
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
                Colors.black.withOpacity(widget.filterOpacity),
                BlendMode.darken
              ),
            ),
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
            ? InkWell(
              onTap        : widget.readOnly ? null : ()=> widget.controller!.removeImage(notify: true),
              borderRadius : widget.borderRadius,
              child        : widget.onErrorWidget??
              Icon(
                Icons.error_outline,
                size    : 80,
                color   : Colors.red,
              ),
            )
            : widget.controller!.file == null
              ? InkWell(
                borderRadius : widget.borderRadius,
                onTap        : widget.readOnly ? null : () => widget.controller!.pickImage(),
                child        : widget.emptyWidget ??
                  const Icon(
                    Icons.file_upload_outlined,
                    size    : 80,
                    color   : Colors.grey,
                    // shadows : [Shadow(color: Colors.grey, blurRadius: 2)]
                  )
                )
              : widget.filledWidget ?? Row(
                mainAxisAlignment: widget.readOnly
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
                children: [
                  if(!widget.readOnly)
                  InkWell(
                    onTap: ()=> widget.controller!.removeImage(notify: true),
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
                    widget.controller!.showImageViewer(
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
                        color   : widget.controller!.file == null ? Colors.grey : Colors.white,
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
    );
  }
}