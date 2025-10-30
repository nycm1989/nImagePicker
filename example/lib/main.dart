import 'dart:ui';

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
  final List<ImageController> imageControllers = List.generate(3, (_) => ImageController());

  _listener() { try{ setState(() {}); } catch(e) { null; } }

  @override
  void initState() {
    super.initState();
    for (var controller in imageControllers) {
      controller.addListener(_listener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in imageControllers) {
      controller ..removeListener(_listener) ..dispose();
    }
  }

  // static const String _urlImage = 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg';
  static const String _urlImage = 'https://mir-s3-cdn-cf.behance.net/project_modules/hd/5eeea355389655.59822ff824b72.gif';
  // static const String _urlImage = 'https://i.imgur.com/f1fRugF.jpeg';
  static const String _assetImage = 'assets/flutter_logo.png';

  BoxDecoration get _decoration =>
  BoxDecoration(
    color         : Color(0xFFf1f1f1),
    borderRadius  : BorderRadius.circular(30),
    border        :
    Border.all(
      width: 1,
      color: Colors.grey.shade400,
      style: BorderStyle.solid
    ),
    boxShadow: [BoxShadow(
      color: Colors.black26,
      blurRadius: 10
    )]
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title : 'Pin Board Example',
      home  :
      Scaffold(
        backgroundColor: Colors.white,
        body:
        SafeArea(
          child:
          Center(
            child:
            SingleChildScrollView(
              padding : const EdgeInsets.all(16),
              child   :
              Column(
                spacing       : 40,
                children      : [

                    ImageArea(
                      controller      : imageControllers[0],
                      onLoadingImage  : _urlImage,
                      width           : 800,
                      height          : 200,
                      decoration      : _decoration,
                      onFullChild     : _Controlls(controller: imageControllers[0]),
                      onLoadingChild  : Center(child: Text("loading...", style: TextStyle(color: Colors.green)))
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 40,
                      children: [
                        ImageArea.square(
                          controller  : imageControllers[1],
                          dimension   : 150,
                          decoration  : _decoration,
                          onEmptyChild  :
                          Center(
                            child:
                            InkWell(
                              onTap: () => imageControllers[1].pickImage(),
                              child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.file_upload_outlined,
                                    size  : 50,
                                    color : Colors.grey,
                                  ),
                                  Text("Pick Image",  style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              )
                            ),
                          ),
                        ),
                        ImageArea.square(
                          dimension     : 150,
                          padding       : const EdgeInsets.all(20),
                          decoration    : _decoration,
                          onLoadingImage: _assetImage,
                        ),
                        ImageArea.square(
                          dimension     : 150,
                          padding       : const EdgeInsets.all(20),
                          decoration    : _decoration,
                          onDragChild   :
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children    : [
                              Text("DROP AREA", style: TextStyle(color: Colors.grey.shade500, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("Web Only",  style: TextStyle(color: Colors.red.shade200,  fontSize: 12)),
                            ],
                          ),
                          onEmptyChild  :
                          Icon(
                            Icons.drag_handle,
                            size  : 50,
                            color : Colors.grey,
                          ),
                        ),
                      ],
                    ),

                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}


class _Controlls extends StatelessWidget {
  final ImageController controller;

  const _Controlls({
    required this.controller
  });

  @override
  Widget build(BuildContext context) =>
  Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      // color: Colors.white,
      color: Color.fromRGBO(250, 250, 250, 0.4),
      borderRadius: BorderRadius.circular(25),
      // border        :
      // Border.all(
      //   width: 1,
      //   color: Colors.grey.shade400,
      //   style: BorderStyle.solid
      // ),
    ),
    clipBehavior: Clip.hardEdge,
    child:
    BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust sigmaX and sigmaY for blur intensity
      child :
      Row(
        mainAxisSize  : MainAxisSize.min,
        spacing       : 10,
        children      : [
          IconButton(
            onPressed : controller.hasNoImage ? null : () => controller.removeImage(),
            icon      : Icon(Icons.delete_outline, size: 20, color: controller.hasImage ? Colors.red : Colors.grey)
          ),
          IconButton(
            onPressed : () => controller.pickImage(),
            icon      : Icon(Icons.folder_outlined, size: 20,  color: controller.hasImage ? Colors.blue : Colors.grey)
          ),
          IconButton(
            onPressed : controller.hasNoImage ? null : () => controller.preview(context),
            icon      : Icon(Icons.zoom_out_map, size: 20,  color: controller.hasImage ? Colors.green : Colors.grey)
          ),
        ],
      ),
    ),
  );
}