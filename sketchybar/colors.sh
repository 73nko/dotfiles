#!/usr/bin/env bash
# Glacier Signal — color tokens for SketchyBar (0xAARRGGBB)
# Mapped 1:1 to ~/.config/Styles/Glacier Signal.html §03 + §05.
#
# NOTE: los nombres de export son "slots" estables — los items y plugins los
# referencian por nombre. El valor de cada slot se remapeó a Glacier Signal;
# el comentario de cada línea indica el color real que contiene ahora.

# identity (signal -> frost)
export MAGENTA=0xff22b8f5            # signal     — identidad primaria
export MAGENTA_HI=0xffa8ecff         # glow      — identidad brillante
export TANGERINE=0xff5ff2cf          # mint  — funciones / diagnósticos
export PEACH=0xffb8f1ff              # cyan_mist  — acento estructural suave
export GOLD=0xffe0fbff               # frost      — valores / batería alta

# structure (steel -> cyan_mist)
export TURQUOISE=0xff5f9bd8          # steel — estructura base / clock
export TURQUOISE_HI=0xff7fe0ff       # ice        — foco / activo
export AQUA=0xffb8f1ff               # cyan_mist  — estructura secundaria
export DEEP_POOL=0xff0a3e57          # skyline    — texto sobre ice

# ground
export DUSK=0xff062230               # night      — base ventana
export PLUM=0xff0d3547               # fjord     — superficie elevada
export WINE=0xff174b60               # ridge      — sombra de montaña
export SUNBURN=0xff2e6b83            # mauve      — cielo wallpaper
export SUNSOFT=0xff7fb5c4            # dawn       — horizonte
export ROSEGOLD=0xfff3faf7           # snow       — foreground por defecto
export CREAM=0xfff3faf7              # snow

# transparent surfaces
export TRANSPARENT=0x00000000
export BAR_COLOR=0x99062230          # night @ 60% — barra glassy translúcida
export BG_PILL=0x66c3d9d6            # silver @ 40% — pill neutra
export BG_PILL_QUIET=0x1ac3d9d6      # silver @ 10% — apenas visible
export BG_PILL_COOL=0x337fe0ff       # ice @ 20% — branch / clock
export BG_PILL_WARM=0x3322b8f5       # signal @ 20% — mode / identidad
export BG_PILL_TANG=0x335ff2cf       # mint @ 20% — diagnósticos

# default fg
export WHITE=$ROSEGOLD               # snow
export MUTED=0x94839b9e              # muted @ 58%
export FAINT=0x59c3d9d6              # silver @ 35%
