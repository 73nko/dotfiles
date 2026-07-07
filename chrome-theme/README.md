# Chrome - Violet Hour · Glass theme

Includes a background on the new tab page using the same 175° gradient as
the wallpaper, at 2560x1440.

## Installation (loaded unpacked, stays installed permanently)

1. Open `chrome://extensions`.
2. Enable "Developer mode" (toggle top-right).
3. Click "Load unpacked".
4. Select the entire `~/.config/chrome-theme/` folder (the one containing
   `manifest.json` + `images/`).
5. Chrome applies the theme immediately. It shows up in
   `chrome://settings/appearance` as "Violet Hour · Glass".

Same flow works for Arc, Brave, Vivaldi and Edge (all Chromium). Doesn't
work for Safari; Safari doesn't support declarative themes.

## Images

- `images/ntp-bg.png` - 2560x1440, crop of the Violet Hour · Aurora
  wallpaper. Shown on the new tab page aligned to the bottom, no repeat.
  The aurora sits at the top and the night below connects with the frame.
- `images/toolbar-bg.png` - 4x2 pixel tile of solid plum. Forces Chrome
  to use that exact tone on the toolbar without interpolating with tints.

If you move to a 5K or larger monitor and `ntp-bg.png` looks pixelated,
regenerate it larger by changing the last `build(W, H)` call in the
wallpapers script to `build(3840, 2160)` and running it again. Expected
size: ~200KB PNG.

## Mapped colors (tweak if something doesn't fit)

- `frame` Dusk `[26,10,40]` - top window bar.
- `toolbar` Dusk+Plum blend `[42,17,62]` - URL bar row + icons.
- `toolbar_text` Rosegold `[255,198,160]` - icon text.
- `tab_text` Rosegold - active tab text.
- `tab_background_text` Muted `[165,134,112]` - inactive tab text.
- `bookmark_text` Rosegold - bookmarks bar.
- `ntp_background` Dusk - new tab page background.
- `ntp_text` Rosegold - new tab text.
- `ntp_link` Turquoise Hi `[127,224,235]` - most-visited links.
- `ntp_header` Magenta `[255,61,138]` - new tab headers.
- `button_background` Magenta - button background.
- `omnibox_background` Branch bg `[31,62,72]` - URL bar background.
- `omnibox_text` Gold `[255,214,122]` - URL text.

## Removal

`chrome://settings/appearance` → "Reset to default". The unpacked theme
stays listed in `chrome://extensions` and can be disabled there without
reverting to default.

## Limitation you'll notice

Chrome doesn't let you color:
- The internal `three-dot` menu (always neutral gray).
- Download, print, screenshot modals.
- Extension icon hovers.

These are Chrome theming API limits, not this manifest's. If the omnibox
text contrast (gold over branch_bg) feels low on your monitor, change
`omnibox_text` to `[255, 198, 160]` (rosegold, more readable and more
boring).

## Package as .crx (optional, for syncing across Macs)

```fish
cd ~/.config
# From chrome://extensions with developer mode on
# Click "Pack extension" → select ~/.config/chrome-theme → Pack
# Generates a .crx + a .pem (keep the .pem to re-sign future versions)
```

Or upload to the Chrome Web Store as "Unlisted" and install by link. Not
worth it for a single user.
