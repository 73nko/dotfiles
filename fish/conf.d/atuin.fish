# atuin — magical shell history with fuzzy search.
# Local-only by default (no cloud account required).
# To enable sync later: `atuin register` then `atuin sync`.
#
# Bindings (default):
#   ↑           browse history with fuzzy search
#   Ctrl-R      same, from anywhere
#
# Disable Ctrl-R rebind by passing --disable-ctrl-r if you prefer fish's default.

if status is-interactive
    if command -q atuin
        atuin init fish | source
    end
end
