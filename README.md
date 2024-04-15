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
imageController.bytes -> Uint8List

/// When onLoadingImage has a url
imageController.error -> bool

/// Show blur background or black transparency
imageController.viewerBlur -> bool

/// List of supported formats
imageController.fileTypes -> List<String>

imageController.hasImage -> bool
imageController.hasNoImage -> bool
imageController.image -> Image
imageController.file -> File
imageController.path -> Path

/// return an async [MultipartFile] for uploading using [key], example:
/// - {"key" : "image_path.png"}
await imageController.image(key: "key") -> Furute<MultipartFile>

/// Map for headers, this need a backend open port for your domain
imageController.headers -> Map<String, String>
```

## Controller metodhs
```dart
/// Set the image file from http response and url
imageController.setFromResponse(response: Response, url: String)

/// This don't work in web!
imageController.setFromPath(path: String)

/// Get image from url, this works in all enviroment
imageController.setFromURL(context, url: String, headers: Map<String, String>)

/// Open the image dialog picker
imageController.pickImage()

imageController.removeImage(notify: bool)
imageController.showImageViewer(notify: bool)
```

## Widget properties
```dart
ImagePicker(
    controller          : ImageController : required,
    width               : double? null,
    height              : double? null,
    onTap               : Future<void> Function() ? null,
    onLoadingImage      : String? null,
    filterOpacity       : double? null,
    emptyWidget         : Widget? null,
    filledWidget        : Widget? null,
    onErrorWidget       : Widget? null,
    onLoadingWidget     : Widget? null,
    margin              : EdgeInsetsGeometry? null,
    bankgroundColor     : Color? null,
    border              : Border? null,
    shadow              : BoxShadow? null,
    readOnly            : bool? null,
    fit                 : BoxFit? null,
    viewerBlur          : bool? null,
    viewerBlurSigma     : double? null,
    previewBlur         : bool? null,
    previewBlurSigma    : double? null,
    shape               : BoxShape? null,
    borderRadius        : BorderRadius? null,
    headers             : Map<String, String>? null,
    dimension           : Double?? null
)
```

## HOW TO USE
### 1. Create a controller and add a listener

```dart
ImageController imageController = ImageController();

@override
void initState() {
    super.initState();
    imageController.addListener(() => setState(() {}));
}

@override
void dispose() {
    super.dispose();
    imageController.removeListener((){});
    imageController.dispose();
}
```

### 2. Use multiple options to view and select images

```dart
ImagePicker(
    controller  : imageController
)

ImagePicker.circle(
    controller  : imageController,
    dimension   : 200
)

ImagePicker.square(
    controller  : imageController,
    dimension   : 200
)

ImagePicker.expand(
    controller  : imageController,
)

ImageViewer(
    image     : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg'
)

ImageViewer.square(
    image     : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg',
    dimension : 200
)

ImageViewer.circle(
    image     : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg',
    dimension : 200
)
ImageViewer.expand(
    image     : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg'
)
```