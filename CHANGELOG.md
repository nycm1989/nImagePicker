## 4.1.2
* [new] onFullImage widget
* [change] emptyChild to onEmptyChild

## 4.1.1
* [Fix] hasImage has been fixed
* [New] headers and maxsize can be setted inside ImageArea

## 4.1.0
* [Fix] hasImage has been fixed
* [Fix] controller is nulleable now
* [New] image key cant be setted in every image change

## 4.0.0
* [New] All the code was refactored
* [New] ImagePicker and ImageViewer were merged into ImageArea
* [New] Now every ImageArea requires a controller with a listener
* [Deleted] ImagePicker.circle was removed to give more control to the optional boxDecoration value
* [Deleted] There are no default buttons anymore, leaving emptyWidget in charge
* [New] On the web, the Drag-and-Drop zone only appears when an image is dragged onto the screen, and all ImageAreas display the onDragWidget
* [New] Indicators were added for drag-in-progress and error states to make it easier to program widgets for those conditions

## 3.3.3
* [Fix] on error widget don`t displaying

## 3.3.2
* [Fix] empty widget don`t displaying

## 3.3.1
* [New] list -> List<int> variable

## 3.3.0
* [Upgraded] dart version
* [Upgraded] architecture
* [New] Drag and Drop area now hide and show element state in DOM

## 3.2.3
* [New] forbidden hex

## 3.2.2
* [Fix] State fix

## 3.2.1
* [Restored] Shape for ImageViewer and ImagePicker

## 3.2.0
* [Upgraded] DragArea logic
* [Upgraded] DragArea now detect any position change
* [Upgraded] Remove unused dragArea
* [Upgraded] Dont create multiples dragAreas for one item un html body
* [Upgraded] Classes declaration upgraded
* [Fix] Icon size logic
* [Fix] Tag for hero
* [New] UploadIcon for picker

## 3.1.0
* [New] onAdd Funtion
* [New] onDelete Function

## 3.0.1
* [Upgraded] setFromUrl dont need className anymore

## 3.0.0
* [New] New drag and drop area, web-only
* [Upgraded] Remove filled widget
* [New] Filled state icons
* [New] Icons size is computed now

## 2.4.0
* [New] Alive bool option for keeping image names on memory
* [Upgraded] Image|onloadingImage for urlImage
* [New] AssetImage

## 2.3.3+2
* AliveName routing for imageViewer

## 2.3.3+1
* AliveName routing for imagePicker

## 2.3.3
* new aliveName in setFromUrl, in case of rewrhite

## 2.3.2
* All variables are final now (performance)
* Fix setFromURL method. [Moinkhan780](https://github.com/moinkhan780)
* Fixed typo mistakes in the code. [Moinkhan780](https://github.com/moinkhan780)
* Optimized and updated the example code for better clarity and functionality. [Moinkhan780](https://github.com/moinkhan780)

## 2.3.1
* Change dart:html to web package.
* Now required width & height.

## 2.3.0
* Platform separated.
* [New] image resizing by maxSize.

## 2.2.1
* ImageViewer improvements for small images.

## 2.2.0
* ImageViewer improvements

## 2.1.3
* Error control for non controller loading
* Controller nulleable problem fixed

## 2.1.2
* Nulleable fixes

## 2.1.1
* Change onLoadingImage for image in ImageViewer

## 2.1.0
* [New] Expanded constructor
* Suport for hero animations
* Change main Container for Animated Container

## 2.0.2
* Handle error on loading image

## 2.0.1
* Small empty crash fixes

## 2.0.0
* NImagePickerController renamed to ImageController
* NImagePicker renamed to ImagePicker
* [New] ImageViewer class for non controller management
* [New] Custom sontructors .squeare and .circle for ImagePicker and ImageViewer
* Fix error when filepicker has cancelled

## 1.4.2
* reload widget on didupdate - logic updated

## 1.4.1
* reload widget on didupdate

## 1.4.0
* controller is nulleable only needs onloading image and error widget now
* if controller is null all controller metodhs dont works

## 1.3.0
* [CRITICAL] fix extension bug when load images
* change .multipartFile to .image(key: 'key')
* remove imageKey variable
* path provider added

## 1.2.1
* verssion update

## 1.2.0
* update default widgets
* [New] ios-web classes
* setFromURL added

## 1.1.1
* Now use all memory images, dont save any files

## 1.1.0
* Added Image view
* Remove image icon changed in default fulled widget
* [New] Preview icon for default fulled widget
* Added Blur for preview and image view
* Fix get from bytes in platform
* changed boolean enable to readOnly
* Trown exception in only web methods

## 1.0.0
* beta phase finished
* remove dispose error

## 0.0.5
* Set image from path added

## 0.0.4+2
* Temp loading image deleting

## 0.0.4+1
* Deleting fix

## 0.0.4
* [CRITICAL] Remove temp file image on dispose for no web

## 0.0.3
* Multiple image differentiation added when have the same key or name

## 0.0.2+3
* HasImage indicator added

## 0.0.2+2
* Another fix between html and io

## 0.0.2+1
* Fix html import in another platforms

## 0.0.2
* Fix https and http request
* Added headers for controller

## 0.0.1
* First upload