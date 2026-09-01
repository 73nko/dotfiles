#!/usr/bin/env python3
"""Glacier Signal wallpaper variant generator.

The original ultrawide image lives in the private personal layer at
  ~/.config/personal/assets/wallpapers/glacier-signal-source.jpg

This script derives the per-display crops from that master with ImageMagick:
  - 5120x1440 ultrawide
  - 3456x2234 laptop Retina
  - desktop, iPhone, and iPad crops focused on the wolf

Re-run safely; it overwrites the derived files. Pillow is the only dependency.
"""
import os
import shutil
import subprocess
import sys

ROOT = os.path.expanduser("~/.config")
WALLDIR = os.path.join(ROOT, "wallpapers")
MASTER = os.path.join(
    ROOT, "personal", "assets", "wallpapers", "glacier-signal-source.jpg"
)
CHROME_NTP = os.path.join(ROOT, "chrome-theme", "images", "generated-ntp-bg.jpg")

# (filename, width, height, x_bias); 0 crops from the left, 1 from the right.
VARIANTS = [
    ("glacier-signal-ultrawide-5120x1440.jpg", 5120, 1440, 0.50),
    ("glacier-signal-macbook-3456x2234.jpg", 3456, 2234, 0.30),
    ("glacier-signal-desktop-5120x3200.jpg", 5120, 3200, 0.34),
    ("glacier-signal-iphone-1320x2868.jpg", 1320, 2868, 0.42),
    ("glacier-signal-ipad-2064x2752.jpg", 2064, 2752, 0.38),
    ("glacier-signal-ipad11-1668x2388.jpg", 1668, 2388, 0.40),
]


def derive(source, output, source_size, w, h, x_bias):
    """Resize to cover w x h, then crop horizontally around the subject."""
    src_w, src_h = source_size
    scale = max(w / src_w, h / src_h)
    nw = round(src_w * scale)
    nh = round(src_h * scale)
    x = round((nw - w) * x_bias)
    y = (nh - h) // 2
    subprocess.run(
        [
            "magick",
            source,
            "-resize",
            f"{nw}x{nh}!",
            "-crop",
            f"{w}x{h}+{x}+{y}",
            "+repage",
            "-quality",
            "92",
            output,
        ],
        check=True,
    )


def main():
    if not os.path.isfile(MASTER):
        sys.exit(f"master no encontrado: {MASTER}\n"
                 "Copia la imagen original en esa ruta.")
    if shutil.which("magick") is None:
        sys.exit("ImageMagick no instalado: brew install imagemagick")
    dimensions = subprocess.check_output(
        ["magick", "identify", "-format", "%w %h", MASTER], text=True
    )
    source_size = tuple(map(int, dimensions.split()))
    os.makedirs(WALLDIR, exist_ok=True)
    os.makedirs(os.path.dirname(CHROME_NTP), exist_ok=True)
    for name, w, h, x_bias in VARIANTS:
        out = os.path.join(WALLDIR, name)
        derive(MASTER, out, source_size, w, h, x_bias)
        print(f"  generado  {name}  ({w}x{h})")
    derive(MASTER, CHROME_NTP, source_size, 2560, 1440, 0.50)
    print("  generado  chrome-theme/images/generated-ntp-bg.jpg  (2560x1440)")
    print(f"variantes Glacier Signal en {WALLDIR}")


if __name__ == "__main__":
    main()
