library n_image_picker_view;
import 'dart:async';
import 'package:flutter/material.dart';
import 'image_body.dart';

class ImageViewer extends ImageBody {
  ImageViewer({
    super.onTap,
    super.htmlImage,
    super.assetImage,
    super.alive,
    super.width,
    super.height,
    super.onErrorWidget,
    super.onLoadingWidget,
    super.margin,
    super.backgroundColor,
    super.borderRadius,
    super.border,
    super.shadow,
    super.fit,
    super.shape,
    super.headers,
    super.key,
    super.tag,
    super.duration,
    super.maxSize,
  }) :
  assert( htmlImage == null || assetImage == null, "Only one image must be provided" ),
  super(
    readOnly      : true,
    filterOpacity : 0,
    viewerBlur    : false,
  );

  factory ImageViewer.square({
    final Future<void> Function() ? onTap,
    final String                  ? htmlImage,
    final String                  ? assetImage,
    final bool                    ? alive,
    final double                  ? dimension,
    final Widget                  ? emptyWidget,
    final Widget                  ? filledWidget,
    final Widget                  ? onErrorWidget,
    final Widget                  ? onLoadingWidget,
    final EdgeInsetsGeometry      ? margin,
    final Color                   ? backgroundColor,
    final BorderRadius            ? borderRadius,
    final Border                  ? border,
    final BoxShadow               ? shadow,
    final BoxFit                  ? fit,
    final Map<String, String>     ? headers,
    final Object                  ? tag,
    final Duration                ? duration,
    final int                     ? maxSize,
  }) =>
  ImageViewer(
    onTap           : onTap,
    htmlImage       : htmlImage,
    assetImage      : assetImage,
    alive           : alive,
    width           : dimension,
    height          : dimension,
    onErrorWidget   : onErrorWidget,
    onLoadingWidget : onLoadingWidget,
    margin          : margin,
    backgroundColor : backgroundColor,
    borderRadius    : borderRadius,
    border          : border,
    shadow          : shadow,
    fit             : fit ?? BoxFit.cover,
    shape           : BoxShape.rectangle,
    headers         : headers,
    tag             : tag,
    duration        : duration ?? Duration(milliseconds: 250),
    maxSize         : maxSize,
  );

  factory ImageViewer.circle({
    final Future<void> Function() ? onTap,
    final String                  ? htmlImage,
    final String                  ? assetImage,
    final bool                    ? alive,
    final double                  ? dimension,
    final Widget                  ? emptyWidget,
    final Widget                  ? filledWidget,
    final Widget                  ? onErrorWidget,
    final Widget                  ? onLoadingWidget,
    final EdgeInsetsGeometry      ? margin,
    final Color                   ? backgroundColor,
    final Border                  ? border,
    final BoxShadow               ? shadow,
    final BoxFit                  ? fit,
    final Map<String, String>     ? headers,
    final Object                  ? tag,
    final Duration                ? duration,
    final int                     ? maxSize,
  }) =>
  ImageViewer(
    onTap           : onTap,
    htmlImage       : htmlImage,
    assetImage      : assetImage,
    alive       : alive,
    width           : dimension,
    height          : dimension,
    onErrorWidget   : onErrorWidget,
    onLoadingWidget : onLoadingWidget,
    margin          : margin,
    backgroundColor : backgroundColor,
    border          : border,
    shadow          : shadow,
    fit             : fit ?? BoxFit.cover,
    shape           : BoxShape.circle,
    headers         : headers,
    tag             : tag,
    duration        : duration ?? Duration(milliseconds: 250),
    maxSize         : maxSize,
  );

  factory ImageViewer.expand({
    final Future<void> Function() ? onTap,
    final String                  ? htmlImage,
    final String                  ? assetImage,
    final bool                    ? alive,
    final Widget                  ? emptyWidget,
    final Widget                  ? filledWidget,
    final Widget                  ? onErrorWidget,
    final Widget                  ? onLoadingWidget,
    final EdgeInsetsGeometry      ? margin,
    final Color                   ? backgroundColor,
    final BorderRadius            ? borderRadius,
    final Border                  ? border,
    final BoxShadow               ? shadow,
    final BoxFit                  ? fit,
    final Map<String, String>     ? headers,
    final Object                  ? tag,
    final Duration                ? duration,
    final int                     ? maxSize,
  }) =>
  ImageViewer(
    onTap           : onTap,
    htmlImage       : htmlImage,
    assetImage      : assetImage,
    alive           : alive,
    width           : double.infinity,
    height          : double.infinity,
    onErrorWidget   : onErrorWidget,
    onLoadingWidget : onLoadingWidget,
    margin          : margin,
    backgroundColor : backgroundColor,
    borderRadius    : borderRadius,
    border          : border,
    shadow          : shadow,
    fit             : fit ?? BoxFit.cover,
    shape           : BoxShape.rectangle,
    headers         : headers,
    tag             : tag,
    duration        : duration ?? Duration(milliseconds: 250),
    maxSize         : maxSize,
  );
}
