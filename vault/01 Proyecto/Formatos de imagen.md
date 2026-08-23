---
tags: [proyecto, formatos]
---

# Formatos de imagen

## Formatos aceptados

Definidos en `lib/src/domain/enums/accepted_formats.dart` y validados también por regex en `ImageUseCase._isValidUrl`:

```
jpg, jpeg, png, gif, bmp, tiff, tga, pvr, ico, webp, psd, exr, pnm
```

La regex de URL exige que la ruta termine en una de estas extensiones (case-insensitive):

```regex
^(https?:\/\/...)\.(jpg|jpeg|png|gif|bmp|tiff|tga|pvr|ico|webp|psd|exr|pnm)$
```

> [!warning]
> Una URL sin extensión reconocible **no** se tratará como URL; `getOnloadingImage` intentará cargarla como asset y fallará.

## Formatos redimensionables

Enum `ResizeFormats` en `lib/src/domain/enums/resize_formats.dart`. Solo estos formatos se recodifican al aplicar `maxSize`:

```
bmp, cur, jpg, png, pvr, tga, tiff
```

Comportamiento de `resizeImage`:
1. Si los bytes están vacíos o la extensión no está en `ResizeFormats`, devuelve `null` (se conservan los datos originales)
2. Si la imagen ya cabe dentro de `maxSize` (ancho y alto <= maxSize), devuelve `null` (no se toca)
3. Escala manteniendo proporción: el lado mayor pasa a valer `maxSize`
4. Recodifica con calidad fija 90 en JPG

> [!info] Formatos como gif/webp/psd NO se redimensionan aunque se pase `maxSize`; quedan intactos.

## Relacionado
- [[Flujo de carga de imagen]]
- [[ImageController]] (`updateMaxSize`)
