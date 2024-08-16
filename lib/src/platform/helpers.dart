import 'dart:typed_data';
import 'package:image/image.dart' as img;

enum _AcceptedFormats{ bmp, cur, jpg, png, pvr, tga, tiff }

class Helpers{
  bool canResize({required final String extension}){
    final _format = extension.toLowerCase();
    return _AcceptedFormats.values.map((e) => e.name).toList().contains(_format);
  }

  Uint8List Rezize({required final Uint8List bytes, required final String extension, required final int maxSize}) {
    int? width;
    int? height;

    if(bytes.isNotEmpty){
      if(canResize(extension: extension)){
        final _format = extension.toLowerCase();

        final image = img.decodeImage(bytes)!;
        (image.data?.width??0) > (image.data?.height??0) ? width = maxSize : height  = maxSize;
        final resize = img.copyResize( image, width: width, height: height);

        final _bytes = Uint8List.fromList(
          _format == _AcceptedFormats.bmp.name ? img.encodeBmp(resize) :
          _format == _AcceptedFormats.cur.name ? img.encodeCur(resize) :
          _format == _AcceptedFormats.jpg.name ? img.encodeJpg(resize) :
          _format == _AcceptedFormats.png.name ? img.encodePng(resize) :
          _format == _AcceptedFormats.pvr.name ? img.encodePvr(resize) :
          _format == _AcceptedFormats.tga.name ? img.encodeTga(resize) :
          img.encodeTiff(resize)
        );

        return _bytes.isNotEmpty ? _bytes : throw Exception('Bad resizing');
      } else {
        return bytes;
      }
    } else {
      throw Exception('Empty bytes');
    }
  }
}