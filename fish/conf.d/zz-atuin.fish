# atuin — magical shell history with fuzzy search.
# Local-only by default (no cloud account required).
# To enable sync later: `atuin register` then `atuin sync`.
#
# Bindings:
#   ↑           browse history with fuzzy search
#   Ctrl-R      same, from anywhere
#
# NOTA sobre el prefijo zz-: conf.d carga en orden alfabetico. Sin el prefijo,
# atuin.fish (a) cargaba ANTES que fzf.fish (f) y `fzf --fish` pisaba el
# binding de Ctrl-R. Con zz- atuin carga el ultimo y Ctrl-R es suyo, que es
# el comportamiento documentado arriba. fzf conserva Ctrl-T (files) y Alt-C (cd).

if status is-interactive
    if command -q atuin
        atuin init fish | source
    end
end
