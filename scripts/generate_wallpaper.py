#!/usr/bin/env python3
"""Violet Hour · Aurora — wallpaper variant generator.

The master render (5120x3200, 16:10) ships committed in the repo at
  ~/.config/wallpapers/violet-hour-aurora-5120x3200.png

This script derives the per-display crops from that master with Pillow:
  - 5120x1440  ultrawide (32:9) — biased up so the aurora band shows
  - 3456x2234  laptop retina (16:10)

Re-run safely; it overwrites the derived files. Pillow is the only dependency.
"""
import os
import sys

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow no instalado:  pip3 install --break-system-packages Pillow")

WALLDIR = os.path.expanduser("~/.config/wallpapers")
MASTER = os.path.join(WALLDIR, "violet-hour-aurora-5120x3200.png")

# (filename, width, height, top_bias)  top_bias: 0=crop from top, 1=from bottom
VARIANTS = [
    # Pantallas Mac
    ("violet-hour-aurora-5120x1440.png", 5120, 1440, 0.30),
    ("violet-hour-aurora-3456x2234.png", 3456, 2234, 0.50),
    # iPhone (todos los modelos modernos comparten ~2.17:1; escala perfecto)
    ("violet-hour-aurora-iphone-1320x2868.png", 1320, 2868, 0.50),
    # iPad Pro 13" / familia 4:3
    ("violet-hour-aurora-ipad-2064x2752.png", 2064, 2752, 0.50),
    # iPad Pro 11" / Air
    ("violet-hour-aurora-ipad11-1668x2388.png", 1668, 2388, 0.50),
]


def derive(img, w, h, top_bias):
    """Resize to *cover* w x h, then crop, biased vertically by top_bias."""
    src_w, src_h = img.size
    scale = max(w / src_w, h / src_h)
    nw, nh = round(src_w * scale), round(src_h * scale)
    im = img.resize((nw, nh), Image.LANCZOS)
    x = (nw - w) // 2
    y = round((nh - h) * top_bias)
    return im.crop((x, y, x + w, y + h))


def main():
    if not os.path.isfile(MASTER):
        sys.exit(f"master no encontrado: {MASTER}\n"
                 "Renderiza el SVG de Styles/ a 5120x3200 y guardalo ahi.")
    master = Image.open(MASTER).convert("RGB")
    for name, w, h, bias in VARIANTS:
        out = os.path.join(WALLDIR, name)
        derive(master, w, h, bias).save(out)
        print(f"  generado  {name}  ({w}x{h})")
    print(f"variantes Violet Hour · Aurora en {WALLDIR}")


if __name__ == "__main__":
    main()
