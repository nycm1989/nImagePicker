# Neil's Image Picker


<p align="center">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/1.png" alt="" style="width:300px;">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/2.png" alt="" style="width:300px;">
</p>

<p align="center">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/3.png" alt="" style="width:300px;">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/4.png" alt="" style="width:300px;">
</p>

<p align="center">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/5.png" alt="" style="height:300px;">
</p>


## With this widget, you can:
- Select images
- Load images on startup
- Name the JSON key of the image
- Obtain the multipart file
- Have error control when loading the image
- Change the widgets displayed when loading the initial image, when selecting an image, when undoing the selection of an image, and when an error occurs.
- Full preview

## Controller properties
```dart
/// Image in bytes list
nImagePickerController.bytes -> Uint8List

/// When onLoadingImage has a url
nImagePickerController.error -> bool

/// Show blur background or black transparency
nImagePickerController.viewerBlur -> bool

/// List of supported formats
nImagePickerController.fileTypes -> List<String>

nImagePickerController.hasImage -> bool
nImagePickerController.hasNoImage -> bool
nImagePickerController.image -> Image
nImagePickerController.file -> File
nImagePickerController.path -> Path

/// Json key for posting [MultipartFile] image, example:
/// - "key" : "server/path/image.png"
/// it works in web and platforms
nImagePickerController.imageKey -> String

/// return an async image for uploading using [imageKey] example:
/// - await controller.multipartFile.then((image) => image)
await nImagePickerController.multipartFile -> Furute<MultipartFile>

/// Map for headers, this need a backend open port for your domain
nImagePickerController.headers -> Map<String, String>
```

## Controller metodhs
```dart
/// Set the image file from http response and url
nImagePickerController.setFromResponse(response: Response, url: String)

/// This dont work in web!
nImagePickerController.setFromPath(path: String)

/// Get image from url, this works in all enviroment
nImagePickerController.setFromURL(context, url: String, headers: Map<String, String>)

/// Open the image dialog picker
nImagePickerController.pickImage()

nImagePickerController.removeImage(notify: bool)
nImagePickerController.showImageViewer(notify: bool)
```

1. Create a controller and add a listener

```dart
NImagePickerController nImagePickerController = NImagePickerController();

@override
void initState() {
    super.initState();
    nImagePickerController.addListener(() => setState(() {}));
}

@override
void dispose() {
    super.dispose();
    nImagePickerController.removeListener((){});
    nImagePickerController.dispose();
}
```

2. Use the widget ;D

```dart
NImagePicker(
    controller        : nImagePickerController,
    // this is a protected server image, you must to provide a different header in web
    onLoadingImage    : "https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg",
    bankgroundColor   : Colors.blueGrey.withOpacity(0.5),
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

```

3. If you want to post the image
```dart
MultipartFile? multipartFile;
nImagePickerController.imageKey = "json_image_key",

await nImagePickerController multipartFile.then((file) async => multipartFile = file);
```