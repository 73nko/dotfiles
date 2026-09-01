# Chrome — Glacier Signal

This unpacked Chrome theme uses the Glacier Signal frame, toolbar, and new-tab
background. The repository checker validates the tracked manifest's active
theme reference, but Chrome installation is manual.

## Install

1. Open `chrome://extensions`.
2. Enable **Developer mode**.
3. Click **Load unpacked**.
4. Select `~/.config/chrome-theme/`, the directory containing `manifest.json`.
5. Confirm **Glacier Signal** under
   `chrome://settings/appearance`.

## Active color mapping

- Frame and new-tab background: night `#062230` (`[6, 34, 48]`).
- Toolbar and omnibox background: fjord `#0d3547` (`[13, 53, 71]`).
- Toolbar, tab, bookmark, new-tab, and omnibox text: snow `#f3faf7`
  (`[243, 250, 247]`).
- Inactive tab text: the palette's muted UI value `#839b9e`
  (`[131, 155, 158]`).
- New-tab links: ice `#7fe0ff` (`[127, 224, 255]`).
- New-tab headers and buttons: signal `#22b8f5` (`[34, 184, 245]`).

`images/generated-ntp-bg.jpg` is generated locally from the private Glacier Signal source
by `scripts/generate_wallpaper.py`; it supplies the new-tab artwork.
`images/toolbar-bg.png` keeps the toolbar on the fjord surface.

## Remove

Open `chrome://settings/appearance` and choose **Reset to default**. The
unpacked entry can also be disabled or removed from `chrome://extensions`.

Chrome does not expose theme colors for every internal menu or modal; those
surfaces may keep their system appearance.
