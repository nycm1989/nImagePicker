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

<p align="center">New drag and drop area, web-only for now in version 3.0.0</p>
<p align="center">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/6.png" alt="" style="width:300px;">
</p>

## With this widget, you can:
- Provide URL images
- Provide assets images
- Drag and Drop (web-only)
- Load images on startup
- Name the JSON key of the image
- Obtain the multipart file
- Have error control when loading the image
- Change the widgets displayed when loading the initial image, when selecting an image, when undoing the selection of an image, and when an error occurs.
- Full preview
- Resize image
- Get image bytes

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
await imageController.image(key: "key").then((image) {}) -> Furute<MultipartFile>

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
imageController.pickImage(maxSize: int)

imageController.removeImage(notify: bool)
imageController.showImageViewer(notify: bool)
```

## Widget properties
```dart
ImagePicker(
    controller          : required ImageController,
    urlImage            : null | String, // only one of this must be filled
    assetImage          : null | String, // only one of this must be filled
    width               : null | double,
    height              : null | double,
    emptyWidget         : null | Widget,
    onErrorWidget       : null | Widget,
    onLoadingWidget     : null | Widget,
    margin              : null | EdgeInsetsGeometry,
    bankgroundColor     : null | Color,
    borderRadius        : null | BorderRadius,
    border              : null | Border,
    shadow              : null | BoxShadow,
    readOnly            : null | bool,
    fit                 : null | BoxFit,
    viewerBlur          : null | bool,
    viewerBlurSigma     : null | double,
    shape               : null | BoxShape,
    tag                 : null | Object, // String relation for hero animation
    duration            : null | Duration, // Animation duration
    dimension           : null | Double,
    deleteIcon          : null | IconData, // icon like Icons.{name}
    expandIcon          : null | IconData, // icon like Icons.{name}
    errorIcon           : null | IconData, // icon like Icons.{name}
    dragIcon            : null | IconData, // icon like Icons.{name}
    maxSize             : null | int, // Only available for bmp, cur, jpg, png, pvr, tga, tiff formats
    headers             : null | Map<String, String>,
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
    width       : 250,
    height      : 250,
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

//! If the image server has CORS security on the web and your code doesn't include
//! the headers accepted by the server, it will return an error. It's important to
//! note that CORS security includes a registry of accepted IPs in the backend,
//! if your project is not on the list, even if it has the correct headers, the
//! image will not be displayed.

ImageViewer(
    urlImage : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg'
    width    : 250,
    height   : 250,
)

ImageViewer.square(
    urlImage  : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg',
    dimension : 200
)

ImageViewer.circle(
    urlImage  : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg',
    dimension : 200
)

ImageViewer.expand(
    urlImage  : 'https://w.wallhaven.cc/full/49/wallhaven-49d5y8.jpg',
)
```

## Acknowledgements
### A special thanks to [Moinkhan780](https://github.com/moinkhan780) for his contributions to version 2.3.2:
```
- Fix setFromURL method.
- Fixed typo mistakes in the code.
- Optimized and updated the example code for better clarity and functionality.
```