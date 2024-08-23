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

  static const String image = 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg';

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
                          controller        : imageControllers[0],
                          margin            : const EdgeInsets.only(bottom: 16),
                          width             : 200,
                          height            : 150,
                          onLoadingImage    : image,
                          backgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                          filterOpacity     : 0.2,
                          borderRadius      : BorderRadius.circular(20),
                          fit               : BoxFit.cover,
                          border            : Border.all(color: Colors.grey, width: 1),
                          shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                          viewerBlur        : true,
                          viewerBlurSigma   : 10,
                          previewBlur       : true,
                          previewBlurSigma  : 1,
                        ),

                        // ImagePicker Circle
                        ImagePicker.circle(
                          tag               : "TAGFORTESTING01",
                          controller        : imageControllers[1],
                          margin            : const EdgeInsets.only(bottom: 16),
                          onLoadingImage    : image,
                          backgroundColor   : const Color(0xFFededed).withOpacity(0.8),
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
                          maxSize           : 500,
                        ),

                        // ImagePicker Square
                        ImagePicker.square(
                          controller        : imageControllers[2],
                          margin            : const EdgeInsets.only(bottom: 16),
                          backgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                          dimension         : 200,
                          filterOpacity     : 0.2,
                          borderRadius      : BorderRadius.circular(20),
                          fit               : BoxFit.cover,
                          border            : Border.all(color: Colors.grey, width: 1),
                          shadow            : const BoxShadow(color: Colors.black, blurRadius: 5, blurStyle: BlurStyle.outer),
                          viewerBlur        : true,
                          viewerBlurSigma   : 10,
                          previewBlur       : true,
                          previewBlurSigma  : 1,
                        ),

                        // ImagePicker Expand
                        SizedBox(
                          width: 100,
                          height: 200,
                          child:
                          ImagePicker.expand(
                            tag               : "TAGFORTESTING02",
                            controller        : imageControllers[3],
                            margin            : const EdgeInsets.only(bottom: 16),
                            backgroundColor   : const Color(0xFFededed).withOpacity(0.8),
                            onLoadingImage    : image,
                            filterOpacity     : 0.2,
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
                        image   : image,
                        width   : 200,
                        height  : 100,
                        margin  : const EdgeInsets.only(bottom: 16),
                      ),

                      // ImageViewer Square
                      ImageViewer.square(
                        image     : image,
                        dimension : 200,
                        margin    : const EdgeInsets.only(bottom: 16),
                      ),

                      // ImageViewer Circle
                      ImageViewer.circle(
                        image     : image,
                        dimension : 200,
                        margin    : const EdgeInsets.only(bottom: 16),
                      ),

                      // ImageViewer Expand
                      SizedBox(
                        width   : 100,
                        height  : 200,
                        child   :
                        ImageViewer.expand(
                          image   : image,
                          margin  : const EdgeInsets.only(bottom: 16),
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
