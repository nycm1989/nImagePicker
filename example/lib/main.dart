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
  List<ImageController> imageControllers = [
    ImageController(),
    ImageController(),
    ImageController(),
    ImageController(),
  ];

  @override
  void initState() {
    super.initState();
    for(ImageController controller in imageControllers){
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    super.dispose();
    for(ImageController controller in imageControllers){
      controller
      ..removeListener((){})
      ..dispose();
    }
  }

  // static const String image = 'https://w.wallhaven.cc/full/49/wallhsaven-49d5y8.jpg';
  static const String image = 'http://192.168.4.233:8000/media/202408/IMAGES/IMAGE_f0676afb-808f-4cf4-b26a-2a483e531623.jpg';

  @override
  Widget build(BuildContext context) =>

    MaterialApp(
      debugShowCheckedModeBanner: true,
      title : 'Pin Board Example',
      home  :
      Scaffold(
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImagePicker(
                  controller        : imageControllers[0],
                  width             : 200,
                  height            : 150,
                  onLoadingImage    : image,
                  bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                  filterOpacity     : 0.2,
                  borderRadius      : BorderRadius.circular(50),
                  fit               : BoxFit.cover,
                  border            : Border.all(color: Colors.grey, width: 1),
                  shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                  viewerBlur        : true,
                  viewerBlurSigma   : 10,
                  previewBlur       : true,
                  previewBlurSigma  : 1,
                ),
                ImagePicker.circle(
                  tag               : "TAGFORTESTING01",
                  controller        : imageControllers[1],
                  onLoadingImage    : image,
                  bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                  dimension         : 200,
                  filterOpacity     : 0.2,
                  fit               : BoxFit.cover,
                  border            : Border.all(color: Colors.grey, width: 1),
                  shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                  viewerBlur        : true,
                  viewerBlurSigma   : 10,
                  previewBlur       : true,
                  previewBlurSigma  : 1,
                  closeColor        : Colors.grey,
                  maxSize           : 500
                ),
                ImagePicker.square(
                  controller        : imageControllers[2],
                  bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                  dimension         : 200,
                  filterOpacity     : 0.2,
                  borderRadius      : BorderRadius.circular(50),
                  fit               : BoxFit.cover,
                  border            : Border.all(color: Colors.grey, width: 1),
                  shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                  viewerBlur        : true,
                  viewerBlurSigma   : 10,
                  previewBlur       : true,
                  previewBlurSigma  : 1,
                ),
                SizedBox(
                  width  : 100,
                  height : 200,
                  child  :
                  ImagePicker.expand(
                    tag               : "TAGFORTESTING02",
                    controller        : imageControllers[3],
                    bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                    onLoadingImage    : image,
                    filterOpacity     : 0.2,
                    borderRadius      : BorderRadius.circular(50),
                    fit               : BoxFit.cover,
                    border            : Border.all(color: Colors.grey, width: 1),
                    shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                    viewerBlur        : true,
                    viewerBlurSigma   : 10,
                    previewBlur       : true,
                    previewBlurSigma  : 1,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageViewer(
                  image   : image,
                  width   : 200,
                  height  : 100,
                ),
                ImageViewer.square(
                  image     : image,
                  dimension : 200,
                ),
                ImageViewer.circle(
                  image     : image,
                  dimension : 200,
                ),
                SizedBox(
                  width  : 100,
                  height : 200,
                  child  :
                  ImageViewer.expand(
                    image: image,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
}