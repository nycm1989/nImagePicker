# Neil's Image Picker

This project is a **Flutter plugin** that provides a customizable image picker and viewer.
It supports web, Android, iOS, and macOS with specific integrations for each platform.

<p align="center">
    <span style="color: green; font-size: 14px;">
    📦 This is a Flutter plugin project for picking and handling images, supporting web, Android, iOS, and macOS platforms.
    </span>
</p>

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

<p align="center">ImageArea becomes a Drag-and-Drop area on the web if readOnly = false.</p>
<p align="center">
    <img src="https://raw.githubusercontent.com/nycm1989/nImagePicker/main/screens/6.png" alt="" style="width:300px;">
</p>

-## With this widget, you can:
This plugin provides a cross‑platform way to handle image selection and display in Flutter.
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


Since this is a Flutter plugin, some platform‑specific configuration is required before using it.

## IOS/MACOS Configuration

For MacOS, add this into /macos/Runner/DebugProfile.entitlements and /macos/Runner/Release.entitlements

```
<key>com.apple.security.app-sandbox</key>
<true/>
<key>com.apple.security.network.server</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
<key>com.apple.security.files.user-selected.read-only</key>
<true/>
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

For iOS/macOS, add this into Info.plist

```

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## ANDROID Configuration

For Android, add this into AndroidManifest.xml

```
<uses-permission android:name="android.permission.INTERNET"/>
```



## Controller properties
```dart
controller.bytes         // Returns the bytes of the current image, if any.
controller.multipartFile // Returns the multipart file representation of the image, if any.
controller.name          // Returns the name of the image file, if any.
controller.extension     // Returns the file extension of the image, if any.
controller.size          // Returns the size of the image, if any.
controller.hasImage      // Returns true if there is an image loaded.
controller.hasNoImage    // Returns true if there is no image loaded.
controller.onDrag        // [WEB] Indicates if a drag operation is currently active.
controller.onError       // Indicates if there was an error loading or processing the image.
```

## Controller metodhs
```dart
/// Loads image data from an asset URL with optional HTTP [headers].
controller.fromAsset(headers: Map<String, String> | null, url: String);

/// Creates image data from a [Uint8List] of bytes and a file [name].
controller.fromUint8List(bytes: Uint8List, name: String);

/// Loads image data from a URL with optional HTTP [headers].
controller.fromUrl(headers: Map<String, String>?, url: String)

/// Loads an image from a given [path] asynchronously.
  /// Uses [_useCase.getOnloadingImage] and updates internal state.
controller.getOnloadingImage(path: String);

/// Opens a file picker to select an image, then processes and stores it.
controller.pickImage();

/// Shows a preview of the current image using [showImagePreview].
  /// Allows customization of the preview dialog appearance.
controller.preview(
    context,
    sigma               : double        | null
    barrierDismissible  : bool          | null
    tag                 : Object        | null
    barrierColor        : Color         | null
    closeButton         : Widget        | null
    decoration          : BoxDecoration | null
);

/// Removes the currently loaded image and resets error state.
controller.removeImage();

/// Stops the loading process and notifies listeners.
controller.startLoading();

/// Stops the loading process and notifies listeners.
controller.stopLoading();

/// Updates the HTTP headers used for image requests.
controller.updateHeaders(Map<String, String> | null);

/// Updates the key used for image data.
controller.updateKey(String);

/// Updates the maximum allowed size for the image.
controller.updateMaxSize(int);
```



### 1. Create a controller and add a listener

```dart
ImageController imageController = ImageController();

_listener() { try{ setState(() {}); } catch(e) { null; } }

@override
void initState() {
    super.initState();
    imageController.addListener(_listener);
}

@override
void dispose() {
    super.dispose();
    imageController ..removeListener(_listener) ..dispose();
}
```


### 2. Widget
```dart
ImageArea(
    /// The controller managing image state and data.
    required controller: ImageController

    /// Decoration for the container.
    required decoration: BoxDecoration?

    /// Width of the container.
    required width: double

    /// Height of the container.
    required height: double

    /// Margin around the container.
    margin: EdgeInsetsGeometry | null

    /// Padding inside the container.
    padding: EdgeInsetsGeometry | null

    /// Optional URL or path to an image to load on initialization.
    onLoadingImage: String | null

    /// Widget to display when no image is loaded.
    emptyChild: Widget | null

    /// Widget to display when an error occurs.
    onErrorChild: Widget | null

    /// Widget to display when a drag operation is active.
    onDragChild: Widget | null

    /// Widget to display while loading.
    onLoadingChild: Widget | null

    /// How to fit the image within the container.
    fit: BoxFit | null

    /// If true, disables drag-and-drop and image picking.
    readOnly: bool = false by default
);

/// Creates a square [ImageArea] with equal width and height [dimension].
ImageArea.square(
    /// The controller managing image state and data.
    required controller: ImageController

    /// Width of the container.
    required dimension: double
);

/// Creates an [ImageArea] that expands to fill available space.
ImageArea.expand(
    /// The controller managing image state and data.
    required controller: ImageController
);
```


If the image server has CORS security on the web and your code doesn't include
the headers accepted by the server, it will return an error. It's important to
note that CORS security includes a registry of accepted IPs in the backend,
if your project is not on the list, even if it has the correct headers, the
image will not be displayed.


## Acknowledgements
### A special thanks to [Moinkhan780](https://github.com/moinkhan780) for his contributions to version 2.3.2:
```
- Fix setFromURL method.
- Fixed typo mistakes in the code.
- Optimized and updated the example code for better clarity and functionality.
```