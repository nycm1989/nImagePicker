---
tags: [dev, release]
---

# Publicación en pub.dev

## Checklist de release

1. Actualizar `version:` en `pubspec.yaml`
2. Añadir entrada en `CHANGELOG.md` con etiquetas `[New]`, `[Fix]`, `[Upgrade]`, `[Deleted]` (convención ya establecida)
3. Verificar el paquete:
   ```bash
   dart pub publish --dry-run
   ```
4. Publicar:
   ```bash
   dart pub publish
   ```
5. Commit + tag de versión (histórico usa mensajes tipo "version 4.2.0")

## Convenciones del changelog

| Etiqueta | Significado |
|---|---|
| `[New]` | Funcionalidad nueva |
| `[Fix]` | Corrección de bug |
| `[Upgrade]` | Mejora interna o de dependencias |
| `[Deleted]` | API eliminada |

> [!warning]
> Versiones mayores (4.0.0) han implicado breaking changes documentados en detalle (merge de ImagePicker+ImageViewer, controlador obligatorio, fin de botones por defecto). Mantener esa disciplina.

## Capturas

`pubspec.yaml` declara `screenshots:` apuntando a `screens/2.png`. Mantener rutas válidas o fallará la validación.

## Relacionado
- [[Roadmap y TODOs]]
