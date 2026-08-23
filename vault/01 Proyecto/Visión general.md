---
tags: [proyecto]
---

# Visión general

**n_image_picker** es un plugin Flutter para seleccionar y manipular imágenes de forma multiplataforma.

| Campo | Valor |
|---|---|
| Nombre | `n_image_picker` |
| Versión | 4.2.0 |
| SDK | Dart `^3.11.1` |
| Repo | https://github.com/nycm1989/nImagePicker |
| Licencia | Ver `LICENSE` |

## Plataformas soportadas
- Web (con Drag & Drop exclusivo de web)
- Android
- iOS
- Windows
- macOS

## Qué permite hacer
- Cargar imágenes desde URL o assets
- Drag and Drop (solo web)
- Definir la clave JSON del archivo (`key`)
- Obtener el archivo multipart listo para subir a una API
- Control de errores al cargar la imagen
- Widgets personalizables por estado: vacío, cargando, error, arrastre, completo
- Vista previa a pantalla completa con desenfoque
- Redimensionar imágenes (`maxSize`)
- Acceso directo a los bytes de la imagen

## Dependencias

| Paquete | Uso |
|---|---|
| `file_picker ^10.3.3` | Diálogo nativo de selección de archivos |
| `image ^4.8.0` | Decodificar, redimensionar y codificar imágenes |
| `http ^1.6.0` | Descarga desde URL y `MultipartFile` |
| `web ^1.1.0` | Interoperabilidad con el DOM en web |
| `crypto ^3.0.7` | Utilidades de hashing |
| `path_provider ^2.1.5` | Rutas temporales del sistema |

## Puntos de entrada del código
- API pública: `lib/n_image_picker.dart` exporta únicamente `ImageController` e `ImageArea`
- Ejemplo: `example/lib/main.dart`
- Capturas: `screens/`

## Relacionado
- [[Arquitectura hexagonal]]
- [[Configuración por plataforma]]
- [[Formatos de imagen]]
