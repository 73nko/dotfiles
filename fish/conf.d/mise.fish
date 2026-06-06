# mise — gestor unificado de versiones de herramientas + env vars + tasks.
# Sustituye a fnm (Node, ya eliminado) y puede sustituir a direnv.
#
# Setup (una vez):
#   1. brew install mise (ya en el Brewfile)
#   2. mise settings add idiomatic_version_file_enable_tools node
#      (sin esto NO lee .nvmrc/.node-version, solo mise.toml y .tool-versions)
#   3. mise use -g node@lts   (global de fallback; por proyecto: mise use node@22)
#   4. En repos con version nueva no instalada: mise install
#
# direnv se mantiene aparte: los .envrc existentes siguen funcionando.
# Migrar env vars a mise.toml por proyecto es opcional y gradual.

if command -q mise
    mise activate fish | source
end
