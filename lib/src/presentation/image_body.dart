library n_image_picker_view;
import 'package:flutter/material.dart';
import 'dart:ui' show Clip, Color, ImageFilter, Shadow, StrokeCap;
import 'dart:async' show FutureExtensions, StreamController;
import 'package:uuid/uuid.dart' show Uuid;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:dotted_decoration/dotted_decoration.dart' show DottedDecoration;
import 'package:n_image_picker/src/presentation/image_controller.dart' show ImageController;

class ImageBody extends StatefulWidget {
  final ImageController? controller;

  ///Only load image from https or http
  final String? urlImage;

  ///Only load image from assets
  final String? assetImage;

  final EdgeInsetsGeometry    margin;
  final bool                  readOnly;
  final BoxFit                fit;
  final bool                  viewerBlur;
  final double                viewerBlurSigma;
  final BoxShape              shape;
  final double              ? width;
  final double              ? height;
  final Widget              ? emptyWidget;
  final Widget              ? onErrorWidget;
  final Widget              ? onLoadingWidget;
  final Color               ? backgroundColor;
  final BorderRadius        ? borderRadius;
  final Border              ? border;
  final BoxShadow           ? shadow;
  final Object              ? tag;
  final Duration            ? duration;
  final Color               ? closeColor;
  final int                 ? maxSize;

  ///only for viewer
  final Map<String, String>? headers;

  // New for version 3.2.0
  final IconData ? uploadIcon;

  // New for version 3.0.0
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
    required this.margin,
    required this.readOnly,
    required this.fit,
    required this.viewerBlur,
    required this.viewerBlurSigma,
    required this.shape,
    this.backgroundColor,
    this.shadow,
    this.borderRadius,
    this.border,
    required this.width,
    required this.height,
    this.emptyWidget,
    this.onErrorWidget,
    this.onLoadingWidget,
    this.headers,
    this.tag,
    this.duration,
    this.closeColor,
    this.maxSize,
    this.uploadIcon,
    this.deleteIcon,
    this.expandIcon,
    this.errorIcon,
    this.dragIcon,
    super.key
  });

  @override
  State<ImageBody> createState() => __ImageState();
}

class __ImageState extends State<ImageBody> {
  final GlobalKey _globalKey = GlobalKey();
  RenderBox? _renderBox;
  Offset? previousPosition;
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
          // Future.delayed(const Duration(minutes: 1), () async =>
          await widget.controller!
          .setFromURL(
            context,
            url       : widget.urlImage!,
            headers   : widget.controller!.headers,
            maxSize   : widget.maxSize,
            onAdd     : widget.onAdd
          )
          .then((state) => setState(() {
            streamController?.close();
            streamController = null;
            if (state) {
              widget.controller!.fromLoading = true;
              widget.controller!.error = false;
            } else {
              widget.controller!.fromLoading = false;
              widget.controller!.error = true;
            }
          }))
          .onError((error, stackTrace) => setState(() {
            streamController?.close();
            streamController = null;
            widget.controller!.fromLoading = false;
            widget.controller!.error = true;
          }));
          // );
        } else {
          // This works if controller is null
          ImageController memoryController = ImageController();
          if (widget.headers != null) memoryController.headers = widget.headers!;
          streamController = StreamController<bool>();
          setState(() => streamController?.add(true));
          await memoryController
          .setFromURL(
            context,
            url       : widget.urlImage!,
            headers   : memoryController.headers,
            maxSize   : widget.maxSize,
            onAdd     : widget.onAdd
          )
          .then((state) async => setState(() {
            streamController?.close();
            streamController = null;
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
          }))
          .onError((error, stackTrace) {
            try {
              setState(() {
                widget.controller?.error = true;
                streamController?.close();
                streamController = null;
              });
            } catch (e) {
                widget.controller?.error = true;
                streamController?.close();
                streamController = null;
            }
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

  _createClass() => _renderBox == null ? null :
  widget.controller?.changeClass(
    _renderBox!,
    className : "nImageDiv_" + Uuid().v4().replaceAll("-", ""),
    onAdd     : widget.onAdd
  );


  _reasembleClass() {
    widget.controller?.removeDrop();
    _createClass();
  }

  void _checkPosition() {
    _renderBox = _globalKey.currentContext?.findRenderObject() as RenderBox?;
    if(_renderBox != null){
      final Offset currentPosition = _renderBox!.localToGlobal(Offset.zero);
      if (previousPosition != null && previousPosition != currentPosition) widget.controller?.updateDrop(renderBox: _renderBox!);
      previousPosition = currentPosition;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPosition());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(()=> _renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox?);
      _startLoading();
      _createClass();
      _checkPosition();
    });
  }

  @override
  void reassemble() {
    super.reassemble();

    streamController?.close();
    _reasembleClass();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeDrop();
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

    _reasembleClass();
  }

  @override
  Widget build(BuildContext context) =>
  Padding(
    padding : widget.margin,
    child   :
    AnimatedContainer(
      key           : _globalKey,
      duration      : widget.duration ?? Duration(milliseconds: 250),
      width         : widget.width,
      height        : widget.height,
      clipBehavior  : Clip.hardEdge,
      decoration    :
      BoxDecoration(
        shape         : widget.shape,
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
      _renderBox == null
      ? const SizedBox.shrink()
      : Hero(
        tag   : widget.tag ?? Uuid().v4(),
        child :
        StreamBuilder<bool>(
          stream  : streamController?.stream,
          builder : (context, snapshot) =>
          snapshot.connectionState == ConnectionState.none
          ? widget.controller == null
            ? (widget.controller?.error??false) || error
              ? Center(
                child:
                widget.onErrorWidget??
                _IconContainer(
                  renderBox : _renderBox!,
                  onTap     : null,
                  icon      : widget.errorIcon ?? Icons.error_outline,
                  hasImage  : false,
                  error     : true,
                )
              )
              : const SizedBox.shrink()
            : SizedBox.expand(
              child:
              Stack(
                children: [
                  if(widget.controller?.hasNoImage??true)
                  SizedBox.expand(
                    child: widget.emptyWidget??SizedBox.shrink()
                  ),
                  SizedBox.expand(
                    child:
                    Column(
                      children: [
                        if(kIsWeb)
                        Expanded(
                          child:
                          Center(
                            child:
                            _IconContainer(
                              onTap     : null,
                              renderBox : _renderBox!,
                              icon      : widget.dragIcon ?? Icons.drag_handle_outlined,
                              hasImage  : widget.controller!.file != null,
                              error     : false,
                            ),
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
                          Center(
                            child:
                            _IconContainer(
                              onTap     : widget.readOnly ? null : () => widget.controller!.removeImage(notify: true, onDelete: widget.onDelete),
                              renderBox : _renderBox!,
                              icon      : widget.errorIcon ?? Icons.error_outline,
                              hasImage  : false,
                              error     : true,
                            ),
                          ),
                        ),
                        if (!widget.controller!.error && !error)
                        if(widget.controller!.file == null)
                        Expanded(
                          child:
                          Center(
                            child:
                            _IconContainer(
                              renderBox : _renderBox!,
                              onTap     : widget.readOnly ? null : () => widget.controller!.pickImage(maxSize: widget.maxSize, onAdd: widget.onAdd),
                              icon      : widget.uploadIcon ?? Icons.file_upload_outlined,
                              hasImage  : false,
                              error     : false,
                            ),
                          ),
                        ),
                        if (!widget.controller!.error && !error)
                        if(widget.controller!.file != null)
                        Expanded(
                          child:
                          Row(
                            mainAxisAlignment : widget.readOnly ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                            children          : [
                              if (!widget.readOnly)
                              _IconContainer(
                                onTap     : () => widget.controller!.removeImage(notify: true, onDelete: widget.onDelete),
                                renderBox : _renderBox!,
                                icon      : widget.deleteIcon ?? Icons.delete_outline,
                                hasImage  : true,
                                error     : false,
                              ),
                              _IconContainer(
                                onTap: () => widget.controller?.showImageViewer(
                                  context,
                                  tag         : widget.tag,
                                  blur        : widget.viewerBlur,
                                  sigma       : widget.viewerBlurSigma,
                                  closeColor  : widget.closeColor
                                ),
                                renderBox : _renderBox!,
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


class _IconContainer extends StatelessWidget {
  final RenderBox renderBox;
  final GestureTapCallback? onTap;
  final IconData  icon;
  final bool      hasImage;
  final bool      error;
  final double    _maxSize;

  _IconContainer({
    required this.renderBox,
    required this.onTap,
    required this.icon,
    required this.hasImage,
    required this.error,
  }) : _maxSize = ((renderBox.size.width >= renderBox.size.height) ? renderBox.size.width : renderBox.size.height) * (error ? 0.30 : 0.15);

  @override
  Widget build(BuildContext context) =>
  MouseRegion(
    cursor  : SystemMouseCursors.click,
    child   :
    onTap == null
    ? _body
    : IconButton(
      onPressed : onTap,
      icon      : _body
    )
  );

  Container get _body => Container(
    width   : _maxSize,
    height  : _maxSize,
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
        shadows : hasImage
        ? [
          Shadow(color: Colors.black, blurRadius: 10),
          Shadow(color: Colors.black, blurRadius: 5 ),
          Shadow(color: Colors.grey,  blurRadius: 2 ),
        ]
        : null
      ),
    )
  );
}