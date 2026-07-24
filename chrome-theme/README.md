# Chrome — Violet Hour · Glass

This unpacked Chrome theme uses the Violet Hour frame, toolbar, and new-tab
background. The repository checker validates the tracked manifest's active
theme reference, but Chrome installation is manual.

## Install

1. Open `chrome://extensions`.
2. Enable **Developer mode**.
3. Click **Load unpacked**.
4. Select `~/.config/chrome-theme/`, the directory containing `manifest.json`.
5. Confirm **Violet Hour · Glass** under
   `chrome://settings/appearance`.

## Active color mapping

- Frame and new-tab background: night `#062230` (`[13, 13, 44]`).
- Toolbar and omnibox background: indigo `#0d3547` (`[26, 23, 69]`).
- Toolbar, tab, bookmark, new-tab, and omnibox text: star `#f3faf7`
  (`[236, 230, 255]`).
- Inactive tab text: the palette's muted UI value `#839b9e`
  (`[119, 116, 148]`).
- New-tab links: ice `#7fe0ff` (`[168, 201, 255]`).
- New-tab headers and buttons: orchid `#22b8f5` (`[179, 157, 255]`).

`images/ntp-bg.png` supplies the new-tab artwork and
`images/toolbar-bg.png` keeps the toolbar on the indigo surface.

## Remove

Open `chrome://settings/appearance` and choose **Reset to default**. The
unpacked entry can also be disabled or removed from `chrome://extensions`.

Chrome does not expose theme colors for every internal menu or modal; those
surfaces may keep their system appearance.
