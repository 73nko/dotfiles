#!/usr/bin/env python3
"""Sunset Pool Splash wallpaper generator.

Renders the gradient defined in Style Guide.html section 06:
  175deg, dusk -> plum -> wine -> sunburn -> sunsoft
plus subtle magenta + turquoise radial glows from the style page.
"""
import math
import os
import sys
from PIL import Image

OUT_DIR = os.path.expanduser("~/.config/wallpapers")
os.makedirs(OUT_DIR, exist_ok=True)

# linear gradient stops (offset 0..1, RGB)
STOPS = [
    (0.00, (0x1A, 0x0A, 0x28)),  # dusk
    (0.25, (0x3A, 0x15, 0x50)),  # plum
    (0.55, (0x6A, 0x20, 0x50)),  # wine
    (0.85, (0xC9, 0x5A, 0x4A)),  # sunburn
    (1.00, (0xF2, 0xA0, 0x70)),  # sunsoft
]

# radial glow specs taken from Style Guide.html .page background
GLOWS = [
    # (cx_pct, cy_pct, rx_pct, ry_pct, rgba)
    (0.50, 0.00, 0.80, 0.50, (0xFF, 0x3D, 0x8A, int(0.12 * 255))),
    (0.90, 0.30, 0.60, 0.40, (0x7F, 0xE0, 0xEB, int(0.08 * 255))),
]

ANGLE_DEG = 175.0  # near-vertical, leaning slightly


def lerp(a, b, t):
    return tuple(int(round(a[i] + (b[i] - a[i]) * t)) for i in range(3))


def sample_gradient(t):
    if t <= STOPS[0][0]:
        return STOPS[0][1]
    if t >= STOPS[-1][0]:
        return STOPS[-1][1]
    for i in range(len(STOPS) - 1):
        a_off, a_col = STOPS[i]
        b_off, b_col = STOPS[i + 1]
        if a_off <= t <= b_off:
            local = (t - a_off) / (b_off - a_off)
            return lerp(a_col, b_col, local)
    return STOPS[-1][1]


def build_lookup(steps=4096):
    return [sample_gradient(i / (steps - 1)) for i in range(steps)]


def render(width, height, path):
    img = Image.new("RGB", (width, height))
    px = img.load()
    lut = build_lookup()
    n = len(lut)

    # CSS 0deg points up; 175deg means almost down-and-slightly-right.
    # Direction vector for CSS angle theta (degrees):
    #   dx = sin(theta), dy = -cos(theta)
    # so increasing projection along (dx, dy) moves toward the gradient end.
    theta = math.radians(ANGLE_DEG)
    dx = math.sin(theta)
    dy = -math.cos(theta)

    # project the four corners to find min/max scalar t
    corners = [(0, 0), (width, 0), (0, height), (width, height)]
    proj = [c[0] * dx + c[1] * dy for c in corners]
    pmin, pmax = min(proj), max(proj)
    span = pmax - pmin if pmax != pmin else 1.0

    print(f"  rendering {width}x{height} -> {os.path.basename(path)}")
    # row-by-row precompute for speed
    for y in range(height):
        ydy = y * dy
        for x in range(width):
            t = (x * dx + ydy - pmin) / span
            if t < 0:
                t = 0.0
            elif t > 1:
                t = 1.0
            idx = int(t * (n - 1))
            px[x, y] = lut[idx]

    base = img.convert("RGBA")

    # apply radial glows
    for cx_pct, cy_pct, rx_pct, ry_pct, (gr, gg, gb, ga) in GLOWS:
        cx = cx_pct * width
        cy = cy_pct * height
        rx = rx_pct * width
        ry = ry_pct * height
        glow = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        gp = glow.load()
        rx2 = rx * rx
        ry2 = ry * ry
        for y in range(height):
            dyy = (y - cy)
            dyy2 = dyy * dyy
            for x in range(width):
                dxx = (x - cx)
                d = (dxx * dxx) / rx2 + dyy2 / ry2
                if d < 1.0:
                    # smooth falloff (matches CSS radial-gradient with implicit falloff)
                    fall = (1.0 - d)
                    fall = fall * fall  # quadratic for softer edge
                    a = int(ga * fall)
                    if a > 0:
                        gp[x, y] = (gr, gg, gb, a)
        base = Image.alpha_composite(base, glow)

    base.convert("RGB").save(path, "PNG", optimize=True)
    print(f"  done: {os.path.getsize(path) / 1024:.0f} KiB")


def main():
    targets = [
        # primary monitor: LG HDR DQHD ultrawide
        (5120, 1440, "sunset-pool-splash-5120x1440.png"),
        # optional secondary: M1 Max built-in or any ~16:10 retina
        (3456, 2234, "sunset-pool-splash-3456x2234.png"),
        # generic 5K2K-ish for safety scaling
        (5120, 2880, "sunset-pool-splash-5120x2880.png"),
    ]
    only = sys.argv[1] if len(sys.argv) > 1 else None
    for w, h, name in targets:
        if only and only not in name:
            continue
        render(w, h, os.path.join(OUT_DIR, name))


if __name__ == "__main__":
    main()
