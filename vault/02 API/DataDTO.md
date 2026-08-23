---
tags: [api, dominio]
source: lib/src/domain/dtos/data_dto.dart
---

# DataDTO

Objeto de transferencia de datos que representa la imagen cargada. Vive en la capa de **dominio** y viaja entre casos de uso y presentación.

## Campos

| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `key` | `String?` | no | Clave identificadora del campo multipart |
| `size` | `Size?` | no | Dimensiones de la imagen (px) |
| `bytes` | `Uint8List` | sí | Datos binarios de la imagen |
| `name` | `String` | sí | Nombre sin extensión |
| `extension` | `String` | sí | Extensión (jpg, png...) |
| `multipartFile` | `MultipartFile` | sí | Archivo listo para requests HTTP |

## Quién lo crea
`ImageUseCase.createDTO(...)` y `ImageUseCase.createDataFromPlatformFile(...)`. Ambos:
1. Extraen nombre/extensión del path
2. Aplican resize si hay `maxSize`
3. Decodifican con `img.decodeImage` para validar y obtener dimensiones (si falla -> `null`)
4. Construyen el `MultipartFile.fromBytes` (o `fromPath` en macOS)

## Quién lo consume
[[ImageController]] lo guarda en `_imageData` y expone sus campos como getters.

> [!note]
> Si `getImageData` devuelve null (bytes corruptos o formato ilegible), el caso de uso devuelve null y el controlador entra en estado `onError`.

## Relacionado
- [[ImageController]]
- [[Arquitectura hexagonal]]
