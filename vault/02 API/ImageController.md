---
tags: [api, presentacion, estado]
source: lib/src/presentation/image_zone.dart
---

# ImageController

`ChangeNotifier` que gestiona el estado de una imagen. El widget consumidor debe **registrar un listener** y llamar `setState` para refrescar.

```dart
ImageController imageController = ImageController();

_listener() { try { setState(() {}); } catch (e) {} }

@override
void initState() {
  super.initState();
  imageController.addListener(_listener);
}

@override
void dispose() {
  super.dispose();
  imageController..removeListener(_listener)..dispose();
}
```

## Propiedades (getters)

| Propiedad | Tipo | Descripción |
|---|---|---|
| `bytes` | `Uint8List?` | Bytes de la imagen actual |
| `multipartFile` | `MultipartFile?` | Archivo listo para subir |
| `name` | `String?` | Nombre sin extensión |
| `extension` | `String?` | Extensión del archivo |
| `size` | `Size?` | Dimensiones en px |
| `hasImage` | `bool` | true si hay imagen con bytes |
| `hasNoImage` | `bool` | inverso de `hasImage` |
| `onDrag` | `bool` | arrastre activo (web) |
| `onError` | `bool` | error de carga/procesado |

## Métodos

### Carga de datos

| Método | Descripción |
|---|---|
| `fromUrl({url, headers?})` | Descarga desde URL (con caché) |
| `fromAsset({path})` | Carga un asset del bundle |
| `fromUint8List({bytes, name})` | Inyecta bytes ya en memoria |
| `getOnloadingImage({path, ...})` | Decide URL vs asset según regex |
| `pickImage({key?})` | Abre el file picker nativo y procesa el archivo |

### Ciclo y estado

| Método | Descripción |
|---|---|
| `removeImage()` | Limpia la imagen y el estado de error |
| `startLoading()` / `stopLoading()` | Control manual del spinner interno |
| `preview(context, {sigma?, barrierDismissible?, tag?, barrierColor?, closeButton?, decoration?})` | Diálogo a pantalla completa ([[Vista previa]]) |

### Configuración

| Método | Descripción |
|---|---|
| `updateKey(String)` | Cambia la clave multipart |
| `updateMaxSize(int)` | Máxima dimensión al cargar/redimensionar |
| `updateHeaders(Map<String,String>?)` | Headers para descargas HTTP |

> [!warning]
> Si `ImageArea` no recibió controlador externo, crea uno propio: los métodos llamados sobre otro controlador no afectarán al widget.

## Relacionado
- [[DataDTO]] - estructura interna `_imageData`
- [[Flujo de carga de imagen]]
