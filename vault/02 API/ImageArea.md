---
tags: [api, presentacion]
source: lib/src/presentation/image_zone.dart
---

# ImageArea

`StatefulWidget` principal del plugin. Es la zona visible donde se muestra/selecciona la imagen. Fusiona a partir de v4.0.0 los antiguos `ImagePicker` e `ImageViewer`.

## Constructores

| Constructor | Tamaño |
|---|---|
| `ImageArea({controller, required width, required height, ...})` | ancho/alto fijos |
| `ImageArea.square({required dimension, ...})` | cuadrado |
| `ImageArea.expand({...})` | llena el espacio disponible (`double.infinity`) |

## Parámetros

| Parámetro | Descripción |
|---|---|
| `controller` | `ImageController?`; si es null se crea uno interno (los métodos del controller no estarán disponibles externamente) |
| `decoration` | Decoración del contenedor (borde circular, color...) |
| `width`, `height`, `margin`, `padding` | Layout |
| `onLoadingImage` | URL o ruta de asset a cargar al iniciar |
| `fit` | `BoxFit` de la imagen |
| `headers` | Headers HTTP inyectados al controlador |

### Widgets por estado

| Parámetro | Se muestra cuando |
|---|---|
| `onFullChild` | hay imagen cargada |
| `onEmptyChild` | no hay imagen |
| `onLoadingChild` | cargando |
| `onErrorChild` | error de carga |
| `onDragChild` | arrastre activo (solo web) |

> [!note] Desde 4.0.0 ya no hay botones por defecto; cada estado vacío lo resuelve el consumidor con estos widgets.

## Ciclo de vida (_ImageZoneState)
1. `initState`: crea/adopta el controlador, registra listener y adjunta la drop zone (web)
2. Si hay `onLoadingImage`, llama a `controller.getOnloadingImage`
3. Aplica `headers` y `maxSize` recibidos por parámetro
4. `didUpdateWidget`: recarga si cambian `onLoadingImage` u otros inputs
5. `dispose`: elimina listener y drop zone del DOM

## Ejemplo mínimo

```dart
ImageArea(
  controller    : imageController,
  width         : 200,
  height        : 200,
  onLoadingImage: 'https://server.com/photo.png',
  decoration    : BoxDecoration(borderRadius: BorderRadius.circular(16)),
  onEmptyChild  : Icon(Icons.add_a_photo),
  onErrorChild  : Icon(Icons.error),
)
```

Ejemplo completo en `example/lib/main.dart`.

## Relacionado
- [[ImageController]]
- [[Drag and Drop (Web)]]
