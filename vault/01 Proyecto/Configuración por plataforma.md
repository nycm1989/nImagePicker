---
tags: [proyecto, plataformas, configuracion]
---

# Configuración por plataforma

Al ser un plugin, las apps consumidoras requieren configuración previa.

## macOS

Añadir a `/macos/Runner/DebugProfile.entitlements` y `/macos/Runner/Release.entitlements`:

```xml
<key>com.apple.security.app-sandbox</key>
<true/>
<key>com.apple.security.network.server</key>
<true/>
<key>com.apple.security.network.client</key>
<true/>
<key>com.apple.security.files.user-selected.read-only</key>
<true/>
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

## iOS / macOS - Info.plist

Necesario para cargar imágenes desde URLs http/https arbitrarias:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

> [!warning]
> `NSAllowsArbitraryLoads = true` desactiva ATS. Considerar restringir excepciones por dominio en producción.

## Android

Añadir permiso en `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Web

- Requiere servidor con **CORS** configurado si las imágenes vienen de otro origen
- CORS incluye registro de IPs aceptadas en backend: aunque el frontend envíe headers correctos, si el origen no está autorizado la imagen no se mostrará
- El Drag & Drop usa elementos del DOM vía adaptador HTML

## Nota interna
En macOS el adaptador IO reporta `requirePath() == true`: los archivos seleccionados se leen desde su ruta en disco (`getBytesFromPath`) y el multipart se construye con `MultipartFile.fromPath`.

## Relacionado
- [[PlatformPort y adaptadores]]
- [[Visión general]]
