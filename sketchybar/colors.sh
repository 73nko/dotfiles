#!/usr/bin/env bash
# Sunset · Pool Splash — color tokens for SketchyBar (0xAARRGGBB)
# Mapped 1:1 to ~/.config/Style Guide.html §02 + §09.

# warm — identity
export MAGENTA=0xffff3d8a
export MAGENTA_HI=0xffffb8d5
export TANGERINE=0xffff8a3d
export PEACH=0xffffb07a
export GOLD=0xffffd67a

# cool — structure
export TURQUOISE=0xff4ec9d7
export TURQUOISE_HI=0xff7fe0eb
export AQUA=0xff8fe3e8
export DEEP_POOL=0xff0d4858

# ground
export DUSK=0xff1a0a28
export PLUM=0xff3a1550
export WINE=0xff6a2050
export SUNBURN=0xffc95a4a
export SUNSOFT=0xfff2a070
export ROSEGOLD=0xffffc6a0
export CREAM=0xfff5ecd7

# transparent surfaces
export TRANSPARENT=0x00000000
export BAR_COLOR=0x991a0a28          # dusk @ 60% — transparent glassy bar
export BG_PILL=0x66ffc6a0            # rosegold @ 40% — neutral pill
export BG_PILL_QUIET=0x1affc6a0      # rosegold @ 10% — barely there
export BG_PILL_COOL=0x337fe0eb       # turquoise hi @ 20% — branch/clock
export BG_PILL_WARM=0x33ff3d8a       # magenta @ 20% — mode/identity
export BG_PILL_TANG=0x33ff8a3d       # tangerine @ 20% — diagnostics

# default fg
export WHITE=$ROSEGOLD
export MUTED=0x99ffc6a0              # rosegold @ 60%
export FAINT=0x59ffc6a0              # rosegold @ 35%
