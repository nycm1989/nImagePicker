---
tags: [dev, testing]
---

# Testing

## Estado actual

- Único archivo: `test/n_image_picker_test.dart` (placeholder)
- `flutter_lints ^6.0.0` activo; reglas en `analysis_options.yaml`

## Cómo ejecutar

```bash
flutter test
```

Para el ejemplo web:

```bash
cd example && flutter run -d chrome
```

## Estrategia sugerida

| Objetivo | Enfoque |
|---|---|
| Validación de URL | Test unitario puro de la regex de [[Formatos de imagen]] (extraer a función testeable) |
| Resize | Bytes sintéticos con paquete `image`; verificar dimensiones tras `resizeImage` |
| DTO | Construcción desde bytes y nombre; campos esperados |
| Plataforma | Inyectar un fake de [[PlatformPort y adaptadores]] (requiere permitir inyección en `ImageUseCase`) |
| Widgets | `WidgetTester` con [[ImageArea]] y estados vacío/error/cargando |

> [!note]
> Hoy `PlatformPort` se instancia dentro de `ImageUseCase`; para testear casos de uso conviene refactorizar hacia inyección de dependencias.

## Relacionado
- [[Roadmap y TODOs]]
