import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'controller.dart';


class NImagePicker extends StatefulWidget {
  final NImagePickerController    controller;
  final Future<void> Function()?  onTap;
  final String                    onLoadingImage;
  final BoxFit                    imageFit;
  final double?                   width, height;
  final double                    filterOpacity;
  final Widget?                   onClearWidget, onErrorWidget, onSelectionWidget, onLoadingWidget;
  final EdgeInsetsGeometry        margin;
  final Color?                    bankgroundColor;
  final BorderRadius?             borderRadius;
  final Border?                   border;
  final BoxShadow?                shadow;
  final bool                      enable;
  final BoxFit                    fit;

  const NImagePicker({
    required this.controller,
    ///Only load image from https or http
    this.onLoadingImage = '',
    this.imageFit       = BoxFit.cover,
    this.margin         = EdgeInsets.zero,
    this.enable         = true,
    this.fit            = BoxFit.cover,
    this.filterOpacity  = 0.2,
    this.bankgroundColor,
    this.shadow,
    this.onTap,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
    this.onClearWidget,
    this.onErrorWidget,
    this.onSelectionWidget,
    this.onLoadingWidget,
    super.key
  });

  @override
  State<NImagePicker> createState() => _NImagePickerState();
}

class _NImagePickerState extends State<NImagePicker> {
  StreamController<bool>? streamController;

  startLoading() async {
    if(widget.onLoadingImage != ''){
      try{
        List<String> list = widget.onLoadingImage.split("://");
        if (list.length <= 0) {
          FormatException("there is not a valid URL");
          widget.controller.error = false;
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
          // Uri.parse(widget.onLoadingImage),
          headers: widget.controller.headers
        ).then((response) async {
          if(response.statusCode == 200){
            widget.controller.setFromResponse(response, widget.onLoadingImage);
            widget.controller.error = false;
          } else{
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
    widget.controller.addListener(()=> setState(() {}));
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
          image: widget.controller.file == null ? null : DecorationImage(image: kIsWeb
            ? Image.memory(widget.controller.file!.bytes!).image
            : widget.controller.image.image,
            fit: widget.fit,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(widget.filterOpacity),
              BlendMode.darken
            ),
          ),
          borderRadius: widget.borderRadius,
          border      : widget.border,
          boxShadow   : widget.shadow == null ? null : [widget.shadow!]
        ),
        margin        : widget.margin,
        width         : widget.width,
        height        : widget.height,
        clipBehavior  : Clip.hardEdge,
        child         :
        snapshot.connectionState == ConnectionState.none
        ? widget.controller.error
          ? widget.onErrorWidget??
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
            )
          : InkWell(
            borderRadius: widget.borderRadius,
            onTap: !widget.enable ? null : () => widget.controller.file == null ? widget.controller.pickImage() : widget.controller.removeImage(),
            child: !widget.enable
            ? const SizedBox.shrink()
            : widget.controller.file == null
              ? widget.onSelectionWidget ?? const Icon(Icons.image_outlined, size: 40, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 10)],)
              : widget.onClearWidget ?? const Icon(Icons.close, size: 40, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 10)],)
          )
          : widget.onLoadingWidget??
          const Center( child: CircularProgressIndicator(strokeWidth: 2) )
      )
    );
  }
}