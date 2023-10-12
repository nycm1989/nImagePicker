# Neil's Image Picker


<p align="center">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/1.png" alt="" style="width:300px;">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/2.png" alt="" style="width:300px;">
</p>

<p align="center">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/3.png" alt="" style="width:300px;">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/4.png" alt="" style="width:300px;">
</p>



## With this widget, you can:
- Select images
- Load images on startup
- Name the JSON key of the image
- Obtain the multipart file
- Have error control when loading the image
- Change the widgets displayed when loading the initial image, when selecting an image, when undoing the selection of an image, and when an error occurs.

## Controller properties
```dart
nImagePickerController.bytes -> Uint8List // Image in bytes list
nImagePickerController.error -> bool // When onLoadingImage has a url
nImagePickerController.file -> File
nImagePickerController.fileTypes -> List<String> // List of upported formats
nImagePickerController.image -> Image // Image filetype
nImagePickerController.imageKey -> String // key for json upload image
nImagePickerController.multipartFile -> MultipartFile // File ready for upload
nImagePickerController.path -> Path
nImagePickerController.headers -> Map<String, String> // Map for headers, this need a backend open port for your domain
```

1. Create a controller and add a listener

```dart
NImagePickerController nImagePickerController = NImagePickerController();

@override
void initState() {
    super.initState();
    nImagePickerController.addListener(() => setState(() {}));
}
```

2. Use the widget ;D

```dart
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

```




