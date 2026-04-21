# Chrome - Sunset Pool Splash theme

Incluye background en el new tab page usando el mismo gradiente 175° del wallpaper, a 2560x1440.

## Instalacion (carga sin empaquetar, queda instalado permanente)

1. Abre `chrome://extensions`.
2. Activa "Developer mode" (toggle arriba a la derecha).
3. Click en "Load unpacked".
4. Selecciona la carpeta `~/.config/chrome-theme/` entera (la que contiene `manifest.json` + `images/`).
5. Chrome aplica el theme inmediatamente. Aparece en `chrome://settings/appearance` como "Sunset Pool Splash".

Mismo flow funciona para Arc, Brave, Vivaldi y Edge (son Chromium). Para Safari no sirve, Safari no soporta temas declarativos.

## Imagenes

- `images/ntp-bg.png` - 2560x1440, gradiente completo. Se muestra en la new tab page, alineado al bottom, sin repeat. El sunset queda abajo (donde los ojos lo esperan) y el dusk arriba conecta visualmente con el frame.
- `images/toolbar-bg.png` - tile 4x2 pixeles plum solido. Fuerza a Chrome a usar ese tono exacto en la toolbar sin interpolar con tints.

Si cambias tu monitor a 5K o mayor y el `ntp-bg.png` se ve pixelado, regeneralo mas grande ajustando la ultima llamada `build(W, H)` en el script de wallpapers a `build(3840, 2160)` y lanzandolo de nuevo. Peso esperado: ~200KB en PNG.

## Colores mapeados (para tweakear si algo no te cuadra)

- `frame` Dusk `[26,10,40]` - barra superior de ventana.
- `toolbar` blend Dusk+Plum `[42,17,62]` - fila de URL bar + iconos.
- `toolbar_text` Rosegold `[255,198,160]` - texto de iconos.
- `tab_text` Rosegold - texto de la tab activa.
- `tab_background_text` Muted `[165,134,112]` - texto de tabs inactivas.
- `bookmark_text` Rosegold - bookmarks bar.
- `ntp_background` Dusk - new tab page background.
- `ntp_text` Rosegold - texto del new tab.
- `ntp_link` Turquoise Hi `[127,224,235]` - links del most-visited.
- `ntp_header` Magenta `[255,61,138]` - headers del new tab.
- `button_background` Magenta - fondo de botones.
- `omnibox_background` Branch bg `[31,62,72]` - URL bar fondo.
- `omnibox_text` Gold `[255,214,122]` - texto de la URL.

## Quitarlo

`chrome://settings/appearance` → "Reset to default". El theme "unpacked" queda listado en `chrome://extensions` y se puede desactivar ahi sin volver al default.

## Limitacion que vas a notar

Chrome no deja colorear:
- El menu `three-dot` interno (siempre gris neutro).
- Los modales de download, print, screenshots.
- Los hover de los iconos de extensiones instaladas.

Son limitaciones del theming API, no de este manifest. Si el contraste del omnibox text (gold sobre branch_bg) te parece bajo en tu monitor, cambia `omnibox_text` a `[255, 198, 160]` (rosegold, mas legible y mas aburrido).

## Empaquetar como .crx (opcional, para sincronizar entre Macs)

```fish
cd ~/.config
# Desde chrome://extensions con developer mode on
# Click "Pack extension" → selecciona ~/.config/chrome-theme → Pack
# Genera un .crx + un .pem (guarda el .pem para re-firmar en futuras versiones)
```

O subelo a Chrome Web Store como "Unlisted" y lo instalas por link. No vale la pena para un solo usuario.
