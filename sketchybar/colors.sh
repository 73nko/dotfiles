#!/usr/bin/env bash
# Violet Hour · Glass — color tokens for SketchyBar (0xAARRGGBB)
# Mapped 1:1 to ~/.config/Styles/Violet Hour · Glass.html §03 + §05.
#
# NOTE: los nombres de export son "slots" estables — los items y plugins los
# referencian por nombre. El valor de cada slot se remapeó a la paleta Violet
# Hour; el comentario de cada línea indica el color real que contiene ahora.

# identity (orchid -> bloom)
export MAGENTA=0xffb39dff            # orchid     — identidad primaria
export MAGENTA_HI=0xffd6c8ff         # lilac      — identidad brillante
export TANGERINE=0xffe2bcff          # rose_mist  — funciones / diagnósticos
export PEACH=0xffb9e0ff              # cyan_mist  — acento estructural suave
export GOLD=0xfff0d2ff               # bloom      — valores / batería alta

# structure (periwinkle -> cyan_mist)
export TURQUOISE=0xff8da7ff          # periwinkle — estructura base / clock
export TURQUOISE_HI=0xffa8c9ff       # ice        — foco / activo
export AQUA=0xffb9e0ff               # cyan_mist  — estructura secundaria
export DEEP_POOL=0xff3c54a3          # skyline    — texto sobre ice

# ground
export DUSK=0xff0d0d2c               # night      — base ventana
export PLUM=0xff1a1745               # indigo     — superficie elevada
export WINE=0xff2c2766               # violet     — cielo wallpaper
export SUNBURN=0xff4a3d95            # mauve      — cielo wallpaper
export SUNSOFT=0xff6e5ec4            # dawn       — horizonte
export ROSEGOLD=0xffece6ff           # star       — foreground por defecto
export CREAM=0xffece6ff              # star

# transparent surfaces
export TRANSPARENT=0x00000000
export BAR_COLOR=0x990d0d2c          # night @ 60% — barra glassy translúcida
export BG_PILL=0x66c4bee0            # silver @ 40% — pill neutra
export BG_PILL_QUIET=0x1ac4bee0      # silver @ 10% — apenas visible
export BG_PILL_COOL=0x33a8c9ff       # ice @ 20% — branch / clock
export BG_PILL_WARM=0x33b39dff       # orchid @ 20% — mode / identidad
export BG_PILL_TANG=0x33e2bcff       # rose_mist @ 20% — diagnósticos

# default fg
export WHITE=$ROSEGOLD               # star
export MUTED=0x94c4bee0              # silver @ 58%
export FAINT=0x59c4bee0              # silver @ 35%
