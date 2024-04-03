library n_image_picker_view;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:n_image_picker/n_image_picker.dart';

export '/src/controller.dart';

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
          widget.controller.error       = false;
          widget.controller.fromLoading = false;
        }

        streamController = StreamController<bool>();
        setState(()=> streamController?.add(true));

        // Future.delayed(Duration(minutes: 30))
        await  widget.controller.setFromURL(
          context,
          url     : widget.onLoadingImage,
          headers : widget.controller.headers
        ).then((state) async {
          streamController?.close();
          streamController = null;
          setState((){
            if(state){
              widget.controller.fromLoading = true;
              widget.controller.error       = false;
            } else{
              widget.controller.fromLoading = false;
              widget.controller.error       = true;
            }
          });
        });
      } catch (e) {
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
          borderRadius: widget.borderRadius,
          border      : widget.border?.add(Border.all(strokeAlign: BorderSide.strokeAlignOutside)),
          boxShadow   : widget.shadow == null ? null : [widget.shadow!],
          image       : widget.controller.file == null
          ? null
          : DecorationImage(
            image       : Image.memory(widget.controller.file!.bytes!).image,
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
          ? widget.controller.error
            ? InkWell(
              onTap        : widget.readOnly ? null : ()=> widget.controller.removeImage(notify: true),
              borderRadius : widget.borderRadius,
              child        : widget.onErrorWidget??
              Icon(
                Icons.error_outline,
                size    : 80,
                color   : Colors.red,
              ),
            )
            : widget.controller.file == null
              ? InkWell(
                borderRadius : widget.borderRadius,
                onTap        : widget.readOnly ? null : () => widget.controller.pickImage(),
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