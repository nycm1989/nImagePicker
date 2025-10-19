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

  static const String _urlImage = 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg';
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
      color: Colors.black45,
      blurRadius: 10
    )]
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color : Color(0xFFe3e3e3),
      title : 'Pin Board Example',
      home  :
      Scaffold(
        backgroundColor: Color(0xFFf5f5f5),
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

                    Column(
                      mainAxisSize  : MainAxisSize.min,
                      spacing       : 10,
                      children      : [
                        ImageArea(
                          controller      : imageControllers[0],
                          onLoadingImage  : _urlImage,
                          width           : 800,
                          height          : 200,
                          decoration      : _decoration,
                          onLoadingChild  : Center(child: Text("loading...", style: TextStyle(color: Colors.green)))
                        ),
                        _Controlls(
                          controller: imageControllers[0]
                        )
                      ],
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 40,
                      children: [
                        ImageArea.square(
                          controller  : imageControllers[1],
                          dimension   : 150,
                          decoration  : _decoration,
                          emptyChild  :
                          Center(
                            child:
                            InkWell(
                              onTap: () => imageControllers[1].pickImage(),
                              child:
                              Icon(
                                Icons.file_upload_outlined,
                                size  : 50,
                                color : Colors.grey,
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
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25)
    ),
    child: Row(
      mainAxisSize  : MainAxisSize.min,
      spacing       : 10,
      children      : [
        IconButton(
          onPressed : controller.hasNoImage ? null : () => controller.removeImage(),
          icon      : Icon(Icons.delete_outline, color: controller.hasImage ? Colors.red : Colors.grey)
        ),
        IconButton(
          onPressed : () => controller.pickImage(),
          icon      : Icon(Icons.folder_outlined, color: controller.hasImage ? Colors.blue : Colors.grey)
        ),
        IconButton(
          onPressed : controller.hasNoImage ? null : () => controller.preview(context),
          icon      : Icon(Icons.zoom_out_map, color: controller.hasImage ? Colors.green : Colors.grey)
        ),
      ],
    ),
  );
}