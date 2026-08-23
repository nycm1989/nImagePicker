---
tags: [api, presentacion]
source: lib/src/presentation/image_preview.dart
---

# Vista previa (preview)

Diálogo a pantalla completa lanzado desde `controller.preview(context, ...)`. Implementado en `lib/src/presentation/image_preview.dart`.

## Parámetros

| Parámetro | Tipo | Descripción |
|---|---|---|
| `sigma` | `double?` | Intensidad del desenfoque de fondo |
| `barrierDismissible` | `bool?` | Cerrar tocando fuera |
| `tag` | `Object?` | Tag de Hero para animación |
| `barrierColor` | `Color?` | Color del velo |
| `closeButton` | `Widget?` | Botón de cierre personalizado |
| `decoration` | `BoxDecoration?` | Decoración del contenedor |

## Notas

- Internamente usa `_BodyimageWebViewerDialog` (web) y `_CloseCutton`
- El blur sobre el fondo existe desde v1.1.0

## Relacionado
- [[ImageController]]
