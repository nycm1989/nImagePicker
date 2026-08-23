---
tags: [api, infraestructura, plataforma]
source: lib/src/domain/ports/platform_port.dart
---

# PlatformPort y adaptadores

Puerto abstracto del dominio que abstrae todo lo dependiente de la plataforma.

## Puerto

```dart
abstract class PlatformPort {
  factory PlatformPort() => getInstance();   // resuelto por conditional import

  bool requirePath();                        // true en macOS
  Uint8List getBytesFromPath(String path);

  // Drag & Drop (web)
  void attachDropBody({controller, renderBox, hashCode});
  void attachDropZone({controller, renderBox, hashCode});
  void showDropZone({renderBox, hashCode});
  void hideDropZone({hashCode});
  void removeDropZone({hashCode});

  // Caché de imágenes descargadas
  Future<Uint8List?> getCacheData({required String url});
  Future<bool> putCacheData({required String url, required Uint8List bytes});
}
```

## Adaptadores

| Adaptador | Condición | Plataformas |
|---|---|---|
| `platform_html_adapter.dart` | `dart.library.html` | Web |
| `platform_io_adapter.dart` | `dart.library.io` | Android, iOS, Windows, macOS |

La selección ocurre en `infraestructure/instances/platform_instance.dart` mediante *conditional imports* en tiempo de compilación (ver [[Arquitectura hexagonal]]).

## Diferencias clave

| Comportamiento | Web (HTML) | IO |
|---|---|---|
| Fuente de bytes del picker | `file.bytes!` | `getBytesFromPath(file.path)` (macOS) o `file.bytes` |
| Multipart | `MultipartFile.fromBytes` | `fromPath` solo en macOS |
| Drag & Drop | Zonas reales en el DOM, mostradas/ocultas por hashcode | No soportado |
| Caché | En memoria (añadida en v4.2.0 junto a iOS) | En memoria/disco según implementación |

## Flujo del drag & drop web
1. `ImageArea` registra su `GlobalKey` -> `attachDropBody` / `attachDropZone`
2. El adaptador HTML crea elementos en el `<body>` indexados por hashcode
3. Al arrastrar sobre la ventana se muestran todas las zonas; al soltar se entrega el archivo al controlador
4. `hideDropZone` / `removeDropZone` limpian el DOM en dispose

## Relacionado
- [[Drag and Drop (Web)]]
- [[Flujo de carga de imagen]]
