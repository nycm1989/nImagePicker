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
              controller      : nImagePickerController,
              onLoadingImage  : 'https://w.wallhaven.cc/full/jx/wallhaven-jxd1x5.jpg',
              bankgroundColor : Colors.blueGrey.withOpacity(0.5),
              height          : 250,
              width           : 250,
              enable          : true,
              filterOpacity   : 0.2,
              borderRadius    : BorderRadius.circular(50),
              fit             : BoxFit.cover,
              border          : Border.all(color: Colors.black, width: 4),
              shadow          : const BoxShadow(color: Colors.black, blurRadius: 10, blurStyle: BlurStyle.outer),
              margin          : const EdgeInsets.all(40),
            ),
          ],
        ),
      ),
    );
}