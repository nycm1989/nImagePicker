library n_image_picker_view;

import 'dart:async';
import 'package:flutter/material.dart';
import 'image_body.dart';

class ImageViewer extends ImageBody{
  ImageViewer({
    super.onTap,
    super.onLoadingImage,
    super.width,
    super.height,
    super.onErrorWidget,
    super.onLoadingWidget,
    super.margin,
    super.bankgroundColor,
    super.borderRadius,
    super.border,
    super.shadow,
    super.fit,
    super.shape,
    super.headers,
    super.key
  }) : super (
    readOnly      : true,
    filterOpacity : 0,
    viewerBlur    : false
  );

  factory ImageViewer.square({
    Future<void> Function() ? onTap,
    String                  ? onLoadingImage,
    double                  ? dimension,
    Widget                  ? emptyWidget,
    Widget                  ? filledWidget,
    Widget                  ? onErrorWidget,
    Widget                  ? onLoadingWidget,
    EdgeInsetsGeometry      ? margin,
    Color                   ? bankgroundColor,
    BorderRadius            ? borderRadius,
    Border                  ? border,
    BoxShadow               ? shadow,
    BoxFit                  ? fit,
    Map<String, String>     ? headers,
  }) => ImageViewer(
    onTap             : onTap,
    onLoadingImage    : onLoadingImage,
    width             : dimension,
    height            : dimension,
    onErrorWidget     : onErrorWidget,
    onLoadingWidget   : onLoadingWidget,
    margin            : margin,
    bankgroundColor   : bankgroundColor,
    borderRadius      : borderRadius,
    border            : border,
    shadow            : shadow,
    fit               : fit??BoxFit.cover,
    shape             : BoxShape.rectangle,
    headers           : headers,
  );

  factory ImageViewer.circle({
    Future<void> Function() ? onTap,
    String                  ? onLoadingImage,
    double                  ? dimension,
    Widget                  ? emptyWidget,
    Widget                  ? filledWidget,
    Widget                  ? onErrorWidget,
    Widget                  ? onLoadingWidget,
    EdgeInsetsGeometry      ? margin,
    Color                   ? bankgroundColor,
    Border                  ? border,
    BoxShadow               ? shadow,
    BoxFit                  ? fit,
    Map<String, String>     ? headers,
  }) => ImageViewer(
    onTap             : onTap,
    onLoadingImage    : onLoadingImage,
    width             : dimension,
    height            : dimension,
    onErrorWidget     : onErrorWidget,
    onLoadingWidget   : onLoadingWidget,
    margin            : margin,
    bankgroundColor   : bankgroundColor,
    border            : border,
    shadow            : shadow,
    fit               : fit??BoxFit.cover,
    shape             : BoxShape.circle,
    headers           : headers,
  );
}