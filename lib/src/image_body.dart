library n_image_picker_view;
import 'package:flutter/material.dart';

import 'dart:ui' show Clip, Color, ImageFilter, Shadow, Size, StrokeCap;
import 'dart:math' show Random;
import 'dart:async' show FutureExtensions, StreamController;
import 'package:uuid/uuid.dart' show Uuid;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:n_image_picker/src/platform/tools.dart' show PlatformTools;
import 'package:dotted_decoration/dotted_decoration.dart' show DottedDecoration;

import 'image_controller.dart';

class ImageBody extends StatefulWidget {
  final ImageController? controller;


  ///Only load image from https or http
  final String? urlImage;

  ///Only load image from assets
  final String? assetImage;

  final double             ? width;
  final double             ? height;
  final Widget             ? emptyWidget;
  final Widget             ? onErrorWidget;
  final Widget             ? onLoadingWidget;
  final EdgeInsetsGeometry ? margin;
  final Color              ? backgroundColor;
  final BorderRadius       ? borderRadius;
  final Border             ? border;
  final BoxShadow          ? shadow;
  final bool               ? readOnly;
  final BoxFit             ? fit;
  final bool               ? viewerBlur;
  final double             ? viewerBlurSigma;
  final BoxShape           ? shape;
  final Object             ? tag;
  final Duration           ? duration;
  final Color              ? closeColor;
  final int                ? maxSize;

  ///only for viewer
  final Map<String, String>? headers;

  // New for version 3.0.0
  final String className;
  final IconData ? deleteIcon;
  final IconData ? expandIcon;
  final IconData ? errorIcon;
  final IconData ? dragIcon;

  // New for version 3.1.0
  final GestureTapCallback? onDelete;
  final GestureTapCallback? onAdd;

  ImageBody({
    this.controller,
    this.onDelete,
    this.onAdd,
    this.urlImage,
    this.assetImage,
    this.margin         = EdgeInsets.zero,
    this.readOnly       = false,
    this.fit            = BoxFit.cover,
    this.backgroundColor,
    this.shadow,
    this.borderRadius,
    this.border,
    required this.width,
    required this.height,
    this.emptyWidget,
    this.onErrorWidget,
    this.onLoadingWidget,
    this.viewerBlur       = true,
    this.viewerBlurSigma  = 5.0,
    this.shape            = BoxShape.rectangle,
    this.headers,
    this.tag,
    this.duration,
    this.closeColor,
    this.maxSize,
    this.deleteIcon,
    this.expandIcon,
    this.errorIcon,
    this.dragIcon,
    super.key
  }) : className = Uuid().v4();

  @override
  State<ImageBody> createState() => __ImageState();
}

class __ImageState extends State<ImageBody> {
  final GlobalKey widgetKey = GlobalKey();
  StreamController<bool>? streamController;
  Uint8List? image;
  bool error = false;
  double iconSize = 30;

  _startLoading() async {
    if (streamController != null) streamController == null;
    if (widget.urlImage != null) {
      try {
        streamController = StreamController<bool>();
        setState(() => streamController?.add(true));
        if (widget.controller != null) {
          await widget.controller!
          .setFromURL(
            context,
            url       : widget.urlImage!,
            headers   : widget.controller!.headers,
            maxSize   : widget.maxSize,
            onAdd     : widget.onAdd
          )
          .then((state) async {
            streamController?.close();
            streamController = null;
            setState(() {
              if (state) {
                widget.controller!.fromLoading = true;
                widget.controller!.error = false;
              } else {
                widget.controller!.fromLoading = false;
                widget.controller!.error = true;
              }
            });
          })
          .onError((error, stackTrace) {
            streamController?.close();
            streamController = null;
            widget.controller!.fromLoading = false;
            widget.controller!.error = true;
          });
        } else {
          // This works if controller is null
          ImageController memoryController = ImageController();
          if (widget.headers != null) memoryController.headers = widget.headers!;
          await memoryController
          .setFromURL(
            context,
            url       : widget.urlImage!,
            headers   : memoryController.headers,
            maxSize   : widget.maxSize,
            onAdd     : widget.onAdd
          )
          .then((state) async {
            streamController?.close();
            streamController = null;
            setState(() {
              if (state) {
                try {
                  image = memoryController.file!.bytes!;
                  error = false;
                } catch (e) {
                  image = null;
                  error = true;
                }
              } else {
                image = null;
                error = true;
              }
            });
          })
          .onError((error, stackTrace) {
            streamController?.close();
            streamController = null;
            try {
              setState(() => widget.controller?.error = true);
            } catch (e) {}
          });
        }
      } catch (e) {
        streamController?.close();
        streamController = null;
        try {
          setState(() => widget.controller?.error = true);
        } catch (e) {}
      }
    } else if (widget.assetImage != null) {
      streamController = null;
      streamController?.close();
      if (widget.controller != null) {
        await widget.controller!
        .setFromAsset(
          path    : widget.assetImage!,
          maxSize : widget.maxSize,
          onAdd   : widget.onAdd
        )
        .then((state) async {
          streamController?.close();
          streamController = null;
        })
        .onError((error, stackTrace) {
          streamController?.close();
          streamController = null;
          widget.controller!.fromLoading = false;
          widget.controller!.error = true;
        });
      } else {
        ImageController memoryController = ImageController();
        await memoryController
        .setFromAsset(
          path    : widget.assetImage!,
          maxSize : widget.maxSize,
          onAdd   : widget.onAdd
        )
        .then((state) async {
          streamController?.close();
          streamController = null;
          setState(() => image = memoryController.file!.bytes! );
        })
        .onError((error, stackTrace) {
          streamController?.close();
          streamController = null;
          try {
            setState(() => widget.controller?.error = true);
          } catch (e) {}
        });
      }
    } else {
      streamController = null;
      streamController?.close();
    }
  }

  _startDragAndDrop(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller?.changueClassName(className : widget.className);
      if((widget.readOnly??true) == false) {
        if(widget.controller != null){
          widget.controller?.dragAndDrop(widgetKey, className : widget.className, onAdd: widget.onAdd);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startLoading();
    _startDragAndDrop();
  }

  @override
  void reassemble() {
    super.reassemble();
    streamController?.close();
    widget.controller?.removeDragAndDrop(className: widget.className);
    _startDragAndDrop();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeImage(notify: false);
    streamController?.close();
  }

  @override
  void didUpdateWidget(covariant ImageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null) {
      if(widget.urlImage  != null) if (widget.urlImage  != oldWidget.urlImage  ) _startLoading();
      if(widget.assetImage != null) if (widget.assetImage != oldWidget.assetImage ) _startLoading();
    } else {
      if (widget.controller != oldWidget.controller) _startLoading();
    }

    if(kIsWeb){
      if(oldWidget.className.isNotEmpty && widget.className.isNotEmpty){
        if(oldWidget.className != widget.className) {
          PlatformTools().removeDiv(className: oldWidget.className);
          widget.controller?.dragAndDrop(widgetKey, className : widget.className, onAdd: widget.onAdd);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag   : widget.tag ?? Random().nextInt(100000),
      child :
      Padding(
        padding : widget.margin??EdgeInsets.zero,
        child   :
        AnimatedContainer(
          key           : widgetKey,
          duration      : widget.duration ?? Duration(milliseconds: 250),
          width         : widget.width,
          height        : widget.height,
          clipBehavior  : Clip.hardEdge,
          decoration    :
          BoxDecoration(
            shape         : widget.shape ?? BoxShape.rectangle,
            color         : widget.backgroundColor ?? Colors.transparent,
            borderRadius  : widget.borderRadius,
            border        : widget.border?.add(Border.all(strokeAlign: BorderSide.strokeAlignOutside)),
            boxShadow     : widget.shadow == null ? null : [widget.shadow!],
            image         : widget.controller == null
            ? image == null
              ? null
              : DecorationImage(
                  image : Image.memory(image!).image,
                  fit   : widget.fit,
                )
            : widget.controller!.file == null
              ? null
              : DecorationImage(
                image : Image.memory(widget.controller!.file!.bytes!).image,
                fit   : widget.fit,
              ),
          ),
          child:
          StreamBuilder<bool>(
            stream  : streamController?.stream,
            builder : (context, snapshot) =>
            snapshot.connectionState == ConnectionState.none
            ? widget.controller == null
              ? (widget.controller?.error??false) || error
                ? Center(
                  child:
                  _IconContainer(
                    widgetKey : widgetKey,
                    onTap     : null,
                    icon      : Icons.error_outline,
                    hasImage  : false,
                    error     : true,
                  )
                )
                : const SizedBox.shrink()
              : SizedBox.expand(
                child:
                Column(
                  children: [
                    if(kIsWeb)
                    Expanded(
                      child:
                      _IconContainer(
                        onTap     : null,
                        widgetKey : widgetKey,
                        icon      : widget.dragIcon ?? Icons.drag_handle_outlined,
                        hasImage  : widget.controller!.file != null,
                        error     : false,
                      )
                    ),
                    if(kIsWeb)
                    Container(
                      height    : 1,
                      width     : double.infinity,
                      decoration: DottedDecoration(),
                    ),
                    if (widget.controller!.error || error)
                    Expanded(
                      child:
                      _IconContainer(
                        onTap     : (widget.readOnly ?? false) ? null : () => widget.controller!.removeImage(notify: true, onDelete: widget.onDelete),
                        widgetKey : widgetKey,
                        icon      : Icons.error_outline,
                        hasImage  : false,
                        error     : true,
                      ),
                    ),
                    if (!widget.controller!.error && !error)
                    if(widget.controller!.file == null)
                    Expanded(
                      child:
                      _IconContainer(
                        widgetKey : widgetKey,
                        onTap     : (widget.readOnly ?? false) ? null : () => widget.controller!.pickImage(maxSize: widget.maxSize, onAdd: widget.onAdd),
                        icon      : Icons.file_upload_outlined,
                        hasImage  : false,
                        error     : false,
                      ),
                    ),
                    if (!widget.controller!.error && !error)
                    if(widget.controller!.file != null)
                    Expanded(
                      child:
                      Row(
                        mainAxisAlignment : (widget.readOnly ?? false) ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                        children          : [
                          if (!(widget.readOnly ?? false))
                          _IconContainer(
                            onTap     : () => widget.controller!.removeImage(notify: true, onDelete: widget.onDelete),
                            widgetKey : widgetKey,
                            icon      : widget.deleteIcon ?? Icons.delete_outline,
                            hasImage  : true,
                            error     : false,
                          ),
                          _IconContainer(
                            onTap: () => widget.controller?.showImageViewer(
                              context,
                              tag         : widget.tag,
                              blur        : widget.viewerBlur ?? false,
                              sigma       : widget.viewerBlurSigma ?? 0,
                              closeColor  : widget.closeColor
                            ),
                            widgetKey : widgetKey,
                            icon      : widget.expandIcon ?? Icons.zoom_out_map_rounded,
                            hasImage  : true,
                            error     : false,
                            // ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : widget.onLoadingWidget ??
            const Center(
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
            )
          )
        ),
      )
    );
  }
}


class _IconContainer extends StatelessWidget {
  final GlobalKey widgetKey;
  final GestureTapCallback? onTap;
  final IconData  icon;
  final bool      hasImage;
  final bool      error;

  _IconContainer({
    required this.widgetKey,
    required this.onTap,
    required this.icon,
    required this.hasImage,
    required this.error,
  });

  @override
  Widget build(BuildContext context) =>
  MouseRegion(
    cursor  : SystemMouseCursors.click,
    child   :
    GestureDetector(
      onTap: onTap,
      child:
      Builder(
        builder: (context) {
          final Size _size = (widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size??Size(100, 100);
          final double _maxSize = ((_size.width >= _size.height) ? _size.width : _size.height) * (error ? 0.30 : 0.15);
          return Container(
            width         : _maxSize+ 15,
            height        : _maxSize+ 15,
            clipBehavior  : Clip.hardEdge,
            decoration    :
            BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle
            ),
            child   :
            BackdropFilter(
              filter  :
              ImageFilter.blur(
                sigmaX  : hasImage ? 0 : 0.4,
                sigmaY  : hasImage ? 0 : 0.4,
              ),
              child:
              Icon(
                icon,
                size    : _maxSize,
                color   : error ? Colors.red : hasImage ? Colors.white : Colors.grey,
                shadows : hasImage ? _shadow() : null
              ),
            )
          );
        }
      )
    )
  );
}

List<Shadow> _shadow () => [
  Shadow(color: Colors.black, blurRadius: 10),
  Shadow(color: Colors.black, blurRadius: 5 ),
  Shadow(color: Colors.grey,  blurRadius: 2 ),
];