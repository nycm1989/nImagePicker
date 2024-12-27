library n_image_picker_view;
import 'package:flutter/material.dart';
import 'package:n_image_picker/src/image_body.dart' show ImageBody;

class ImageViewer extends ImageBody {
  ImageViewer({
    required super.width,
    required super.height,
    super.urlImage,
    super.assetImage,
    super.onErrorWidget,
    super.onLoadingWidget,
    super.backgroundColor,
    super.border,
    super.shadow,
    super.borderRadius,
    final EdgeInsetsGeometry ? margin,
    final BoxFit             ? fit,
    final BoxShape           ? shape,
    super.tag,
    super.duration,
    super.maxSize,
    super.headers,
    super.key,
    super.errorIcon,
  }) :
  assert(urlImage == null || assetImage == null, "Only one image must be provided"),
  assert(shape != BoxShape.circle || borderRadius == null, "If shape == BoxShape.circle, borderRadius must be null"),
  super(
    margin          : margin ?? EdgeInsets.zero,
    fit             : fit    ?? BoxFit.cover,
    shape           : shape  ?? BoxShape.rectangle,
    readOnly        : true,
    viewerBlur      : false,
    viewerBlurSigma : 0,
  );

  ImageViewer.square({
    required double dimension,
    super.urlImage,
    super.assetImage,
    super.onErrorWidget,
    super.onLoadingWidget,
    super.backgroundColor,
    super.borderRadius,
    super.border,
    super.shadow,
    final EdgeInsetsGeometry ? margin,
    final BoxFit             ? fit,
    super.tag,
    super.duration,
    super.maxSize,
    super.headers,
    super.key,
    super.errorIcon,
  }) :
  assert( urlImage == null || assetImage == null, "Only one image must be provided" ),
  super(
    width           : dimension,
    height          : dimension,
    margin          : margin           ?? EdgeInsets.zero,
    readOnly        : true,
    fit             : fit              ?? BoxFit.cover,
    viewerBlur      : false,
    viewerBlurSigma : 0,
    shape           : BoxShape.rectangle,
  );

  ImageViewer.circle({
    required double dimension,
    super.urlImage,
    super.assetImage,
    super.onErrorWidget,
    super.onLoadingWidget,
    super.backgroundColor,
    super.border,
    super.shadow,
    final EdgeInsetsGeometry ? margin,
    final BoxFit             ? fit,
    super.tag,
    super.duration,
    super.maxSize,
    super.headers,
    super.key,
    super.errorIcon,
  }) :
  assert( urlImage == null || assetImage == null, "Only one image must be provided" ),
  super(
    width           : dimension,
    height          : dimension,
    margin          : margin           ?? EdgeInsets.zero,
    readOnly        : true,
    fit             : fit              ?? BoxFit.cover,
    viewerBlur      : false,
    viewerBlurSigma : 0,
    shape           : BoxShape.circle,
  );

  ImageViewer.expand({
    super.urlImage,
    super.assetImage,
    super.onErrorWidget,
    super.onLoadingWidget,
    super.backgroundColor,
    super.borderRadius,
    super.border,
    super.shadow,
    final EdgeInsetsGeometry ? margin,
    final BoxFit             ? fit,
    super.tag,
    super.duration,
    super.maxSize,
    super.headers,
    super.key,
    super.errorIcon,
  }) :
  assert( urlImage == null || assetImage == null, "Only one image must be provided" ),
  super(
    width           : double.infinity,
    height          : double.infinity,
    margin          : margin           ?? EdgeInsets.zero,
    readOnly        : true,
    fit             : fit              ?? BoxFit.cover,
    viewerBlur      : false,
    viewerBlurSigma : 0,
    shape           : BoxShape.circle,
  );
}
