import 'package:flutter/material.dart';
import 'package:n_image_picker/n_image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ImageController imageController = ImageController();

  @override
  void initState() {
    super.initState();

    imageController
    ..fileTypes = const [ 'png', 'jpg', 'jpeg' ]
    ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    imageController
    ..removeListener((){})
    ..dispose();
  }

  @override
  Widget build(BuildContext context) =>

    MaterialApp(
      debugShowCheckedModeBanner: true,
      title : 'Pin Board Example',
      home  : Scaffold(
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImagePicker(
                  controller        : imageController,
                  onLoadingImage    : 'https://w.wallhaven.cc/full/49/wallhsaven-49d5y8.jpg',
                  bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                  height            : 250,
                  width             : 250,
                  filterOpacity     : 0.2,
                  borderRadius      : BorderRadius.circular(50),
                  fit               : BoxFit.cover,
                  border            : Border.all(color: Colors.grey, width: 1),
                  shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                  margin            : const EdgeInsets.all(40),
                  viewerBlur        : true,
                  viewerBlurSigma   : 10,
                  previewBlur       : true,
                  previewBlurSigma  : 1,
                ),
                ImagePicker.circle(
                  controller        : imageController,
                  bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                  dimension         : 250,
                  filterOpacity     : 0.2,
                  fit               : BoxFit.cover,
                  border            : Border.all(color: Colors.grey, width: 1),
                  shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                  margin            : const EdgeInsets.all(40),
                  viewerBlur        : true,
                  viewerBlurSigma   : 10,
                  previewBlur       : true,
                  previewBlurSigma  : 1,
                ),
                ImagePicker.square(
                  controller        : imageController,
                  bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                  dimension         : 250,
                  filterOpacity     : 0.2,
                  borderRadius      : BorderRadius.circular(50),
                  fit               : BoxFit.cover,
                  border            : Border.all(color: Colors.grey, width: 1),
                  shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                  margin            : const EdgeInsets.all(40),
                  viewerBlur        : true,
                  viewerBlurSigma   : 10,
                  previewBlur       : true,
                  previewBlurSigma  : 1,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageViewer(
                  onLoadingImage    : 'https://w.wallhaven.cc/full/49/wallhsaven-49d5y8.jpg',
                  width             : 250,
                  height            : 100,
                ),
                ImageViewer.square(
                  onLoadingImage    : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg',
                  dimension         : 250,
                ),
                ImageViewer.circle(
                  onLoadingImage    : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg',
                  dimension         : 250,
                ),
              ],
            ),
          ],
        ),
      ),
    );
}