---
tags: [dev, todo]
---

# Roadmap y TODOs

## TODOs en código

- [ ] `image_use_case.dart:103` - `//TODO get size`: obtener el tamaño real en `createDataFromPlatformFile` (hoy se deduce tras decodificar)

## Ideas / deuda técnica detectadas

- [ ] Inyectar `PlatformPort` en `ImageUseCase` para facilitar tests ([[Testing]])
- [ ] Cobertura de tests real (actualmente placeholder)
- [ ] Revisar `print("$e\n$stackTrace")` en `createDataFromURL`: sustituir por `debugPrint` o logger
- [ ] Soporte de resize para más formatos (gif/webp hoy quedan fuera, ver [[Formatos de imagen]])
- [ ] Corregir typo del topic en `pubspec.yaml`: `darg-and-drop` -> `drag-and-drop`

## Hitos históricos relevantes

| Versión | Hito |
|---|---|
| 4.2.0 | Caché de imágenes (iOS/web), resize corregido |
| 4.1.x | Controller nullable, headers/maxSize desde widget |
| 4.0.0 | Refactor total, merge en ImageArea, drag global |
| 3.3.0 | Arquitectura hexagonal completa |
| 2.3.0 | Plataformas separadas, resize por maxSize |

## Relacionado
- [[Publicación en pub.dev]]
- [[Testing]]
