#!/usr/bin/env fish

# ============================================================================
# Fisher + plugins. Idempotente. Lee fish_plugins como fuente de verdad.
# ============================================================================

# 1. Asegurar que fisher esta instalado.
if not type -q fisher
    echo "Installing fisher..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    and fisher install jorgebucaran/fisher
end

# 2. Sincronizar plugins desde el manifesto fish_plugins.
#    `fisher update` instala los que faltan, actualiza los existentes,
#    y desinstala los que no estan en fish_plugins. Drift cero.
echo "Syncing plugins from fish_plugins..."
fisher update
