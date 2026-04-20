# ============================================
# Environment variables
# ============================================

# Abre man pages en nvim con sintaxis, búsqueda y navegación vim.
# Requiere nvim. El `!` al final evita "Press ENTER or type command to continue".
if command -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER 'nvim +Man!'
end
