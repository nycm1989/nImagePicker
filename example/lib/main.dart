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

  static const String _urlImage = 'https://i.imgur.com/f1fRugF.jpeg';
  static const String _assetImage = 'assets/flutter_logo.png';

  BoxDecoration get _decoration =>
  BoxDecoration(
    color         : Colors.white,
    borderRadius  : BorderRadius.circular(20),
    border        :
    Border.all(
      width: 2,
      color: Colors.grey.shade600,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignOutside
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
              Wrap(
                alignment     : WrapAlignment.center,
                runAlignment  : WrapAlignment.center,
                spacing       : 40,
                runSpacing    : 40,
                children      : [

                    Column(
                      mainAxisSize  : MainAxisSize.min,
                      spacing       : 10,
                      children      : [
                        ImageArea(
                          controller      : imageControllers[0],
                          onLoadingImage  : _urlImage,
                          width           : 200,
                          height          : 150,
                          decoration      : _decoration,
                          onLoadingChild  : Center(child: Text("loading...", style: TextStyle(color: Colors.green)))
                        ),
                        _Controlls(
                          controller: imageControllers[0]
                        )
                      ],
                    ),

                    Column(
                      mainAxisSize  : MainAxisSize.min,
                      spacing       : 10,
                      children      : [
                        ImageArea.square(
                          controller  : imageControllers[1],
                          dimension   : 200,
                          decoration  : _decoration,
                          emptyChild  : Center(
                            child:
                            InkWell(
                              onTap: () => imageControllers[1].pickImage(),
                              child:
                              Text(
                                "Click here to open the picker",
                                textAlign : TextAlign.center,
                                style     :
                                TextStyle(
                                  color     : Colors.blue.shade600,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                            ),
                          ),
                        ),
                        _Controlls(
                          controller: imageControllers[1]
                        )
                      ],
                    ),

                    Column(
                      mainAxisSize  : MainAxisSize.min,
                      spacing       : 10,
                      children      : [
                        SizedBox(
                          width   : 100,
                          height  : 200,
                          child   :
                          ImageArea.expand(
                            controller      : imageControllers[2],
                            decoration      : _decoration,
                            onLoadingImage  : _assetImage,
                          ),
                        ),
                        _Controlls(
                          controller: imageControllers[2]
                        )
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
  Row(
    mainAxisSize  : MainAxisSize.min,
    spacing       : 10,
    children      : [
      IconButton(
        onPressed : controller.hasNoImage ? null : () => controller.removeImage(),
        icon      : Icon(Icons.delete_outline, color: controller.hasImage ? Colors.red : Colors.grey)
      ),
      IconButton(
        onPressed : () => controller.pickImage(),
        icon      : Icon(Icons.folder_outlined, color: Colors.blue)
      ),
      IconButton(
        onPressed : () => controller.preview(context),
        icon      : Icon(Icons.image_outlined, color: Colors.green)
      ),
    ],
  );
}