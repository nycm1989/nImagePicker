---
tags: [flujo, arquitectura]
---

# Flujo de carga de imagen

Pipeline común para cualquier origen (picker, URL, asset, bytes, drag & drop).

## Diagrama general

```mermaid
flowchart TD
    A["Origen"] --> B{"Tipo de origen"}
    B -->|pickImage| C["file_picker -> PlatformFile"]
    B -->|fromUrl| D["http.get + caché"]
    B -->|fromAsset| E["rootBundle.load"]
    B -->|fromUint8List / drop| F["bytes directos"]
    C --> G["ImageUseCase"]
    D --> G
    E --> G
    F --> G
    G --> H{"maxSize?"}
    H -->|sí y formato redimensionable| I["resizeImage + re-encode"]
    H -->|no| J["bytes originales"]
    I --> K["decodeImage valida + obtiene size"]
    J --> K
    K -->|null| L["onError = true<br/>notifyListeners"]
    K -->|ok| M["DataDTO(key, name, ext, size, bytes, multipartFile)"]
    M --> N["controller._setData -> notifyListeners"]
    N --> O["UI refresca: onFullChild, bytes, multipartFile..."]
```

## Detalles por paso

### 1. Obtención de bytes
- **Picker**: en web se usan `file.bytes`; en plataformas IO con `requirePath()` (macOS) se leen del disco con `getBytesFromPath`
- **URL**: primero `getCacheData(url)`; si no hay caché, `http.get` con headers y luego `putCacheData` (sin bloquear). La URL debe pasar la regex de [[Formatos de imagen]]
- **Asset**: `rootBundle.load` si el path no es una URL válida

### 2. Resize opcional
Ver reglas exactas en [[Formatos de imagen]]. Solo formatos `bmp, cur, jpg, png, pvr, tga, tiff`, solo si excede `maxSize`.

### 3. Validación y DTO
`img.decodeImage` actúa de validador real: si los bytes no decodifican, el caso de uso devuelve null y el controlador marca error.

### 4. Notificación
El controlador guarda el `DataDTO` y notifica; el listener del consumidor llama `setState`. Los getters (`bytes`, `multipartFile`, ...) ya devuelven los datos nuevos.

## Puntos de fallo comunes
- CORS en web ([[Configuración por plataforma]])
- Extensión no reconocida en URL -> intenta cargarla como asset y falla
- Cancelar el picker nativo (manejado desde v2.0.0)

## Relacionado
- [[ImageController]]
- [[DataDTO]]
- [[PlatformPort y adaptadores]]
