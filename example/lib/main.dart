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
  NImagePickerController nImagePickerController = NImagePickerController();

  @override
  void initState() {
    super.initState();

    nImagePickerController
    ..fileTypes = const [ 'png', 'jpg', 'jpeg' ]
    ..imageKey  = 'upload_image_name';

    nImagePickerController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    nImagePickerController.removeListener((){});
    nImagePickerController.dispose();
  }

  @override
  Widget build(BuildContext context) =>

    MaterialApp(
      debugShowCheckedModeBanner: true,
      title : 'Pin Board Example',
      home  : Scaffold(
        body:
        Column(
          children: [
            NImagePicker(
              controller        : nImagePickerController,
              // this is a protected server image, you must to provide a different header in web
              onLoadingImage    : "https://api.9780bitcoin.com/media/202403/images/company/PHOTO_93080414-8207-490c-ab40-1b4eac7a1076.png",
              bankgroundColor   : const Color(0xFFededed).withOpacity(0.8),
              height            : 250,
              width             : 250,
              // readOnly          : true,
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
            Container(
              width   : 200,
              height  : 30,
              margin  : const EdgeInsets.all(20),
              alignment: Alignment.center,
              child   :
              InkWell(
                onTap: () async => await nImagePickerController.multipartFile.then((value) {
                  debugPrint(value.length.toString());
                  debugPrint(nImagePickerController.hasNoImage.toString());
                }),
                child: const Text("TEST", style: TextStyle(color: Colors.black)),
              )
            )
          ],
        ),
      ),
    );
}