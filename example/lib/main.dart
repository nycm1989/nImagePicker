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
  final List<ImageController> imageControllers = List.generate(4, (_) => ImageController());

  @override
  void initState() {
    super.initState();
    for (var controller in imageControllers) {
      controller.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var controller in imageControllers) {
      controller.removeListener(() => setState(() {}));
      controller.dispose();
    }
    super.dispose();
  }

  static const String urlImage = 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg';
  static const String assetImage = 'assets/flutter_logo.png';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title : 'Pin Board Example',
      home  :
      Scaffold(
        body:
        SafeArea(
          child:
          Center(
            child:
            SingleChildScrollView(
              padding : const EdgeInsets.all(16),
              child   :
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children          : [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        // ImagePicker Rectangle
                        ImagePicker(
                          assetImage        : assetImage,
                          // urlImage         : urlImage,
                          controller        : imageControllers[0],
                          margin            : const EdgeInsets.only(bottom: 16),
                          width             : 200,
                          height            : 150,
                          backgroundColor   : const Color(0xFFededed).withValues(alpha: 0.8),
                          borderRadius      : BorderRadius.circular(20),
                          fit               : BoxFit.cover,
                          border            : Border.all(color: Colors.grey, width: 1),
                          shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                          viewerBlur        : true,
                          viewerBlurSigma   : 10,
                        ),

                        // ImagePicker Circle
                        ImagePicker.circle(
                          urlImage          : urlImage,
                          tag               : "TAGFORTESTING01",
                          controller        : imageControllers[1],
                          margin            : const EdgeInsets.only(bottom: 16),
                          backgroundColor   : const Color(0xFFededed).withValues(alpha: 0.8),
                          dimension         : 200,
                          filterOpacity     : 0.2,
                          fit               : BoxFit.cover,
                          border            : Border.all(color: Colors.grey, width: 1),
                          shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                          viewerBlur        : true,
                          viewerBlurSigma   : 10,
                          closeColor        : Colors.grey,
                          maxSize           : 500,
                        ),

                        // ImagePicker Square
                        ImagePicker.square(
                          assetImage        : assetImage,
                          controller        : imageControllers[2],
                          margin            : const EdgeInsets.only(bottom: 16),
                          backgroundColor   : const Color(0xFFededed).withValues(alpha: 0.8),
                          dimension         : 200,
                          borderRadius      : BorderRadius.circular(20),
                          fit               : BoxFit.cover,
                          border            : Border.all(color: Colors.grey, width: 1),
                          shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                          viewerBlur        : true,
                          viewerBlurSigma   : 10,
                        ),

                        // ImagePicker Expand
                        SizedBox(
                          width: 100,
                          height: 200,
                          child:
                          ImagePicker.expand(
                            urlImage         : urlImage,
                            // assetImage        : assetImage,
                            tag               : "TAGFORTESTING02",
                            controller        : imageControllers[3],
                            margin            : const EdgeInsets.only(bottom: 16),
                            backgroundColor   : const Color(0xFFededed).withValues(alpha: 0.8),
                            borderRadius      : BorderRadius.circular(20),
                            fit               : BoxFit.cover,
                            border            : Border.all(color: Colors.grey, width: 1),
                            shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                            viewerBlur        : true,
                            viewerBlurSigma   : 10,
                            previewBlur       : true,
                            previewBlurSigma  : 1,
                          ),
                        ),

                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      // ImageViewer Rectangle
                      ImageViewer(
                        assetImage  : assetImage,
                        fit         : BoxFit.fitHeight,
                        width       : 200,
                        height      : 100,
                        margin      : const EdgeInsets.only(bottom: 16),
                      ),

                      // ImageViewer Square
                      ImageViewer.square(
                        urlImage  : urlImage,
                        dimension : 200,
                        margin    : const EdgeInsets.only(bottom: 16),
                      ),

                      // ImageViewer Circle
                      ImageViewer.circle(
                        assetImage  : assetImage,
                        // urlImage   : urlImage,
                        fit         : BoxFit.fill,
                        dimension   : 200,
                        margin      : const EdgeInsets.only(bottom: 16),
                      ),

                      // ImageViewer Expand
                      SizedBox(
                        width   : 100,
                        height  : 200,
                        child   :
                        ImageViewer.expand(
                          urlImage : urlImage,
                          margin    : const EdgeInsets.only(bottom: 16),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
