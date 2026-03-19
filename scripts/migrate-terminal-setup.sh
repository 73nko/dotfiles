#!/bin/bash
set -euo pipefail

# ============================================
# Terminal Setup Migration Script
# Run once to apply all cleanup changes
# ============================================

echo "=== Terminal Setup Migration ==="
echo ""

# 1. Remove deprecated packages
echo "[1/6] Removing deprecated packages..."
brew uninstall --force thefuck 2>/dev/null && echo "  Removed thefuck" || echo "  thefuck already removed"
brew uninstall --force neofetch 2>/dev/null && echo "  Removed neofetch" || echo "  neofetch already removed"
brew uninstall --force bash-completion 2>/dev/null && echo "  Removed bash-completion" || echo "  bash-completion already removed"
brew uninstall --force skhd 2>/dev/null && echo "  Removed skhd" || echo "  skhd already removed"

# Stop skhd service if running
skhd --stop-service 2>/dev/null && echo "  Stopped skhd service" || true

# 2. Install replacements
echo ""
echo "[2/6] Installing new packages..."
brew install timescam/homebrew-tap/pay-respects 2>/dev/null && echo "  Installed pay-respects" || echo "  pay-respects already installed"
brew install fastfetch 2>/dev/null && echo "  Installed fastfetch" || echo "  fastfetch already installed"
brew install direnv 2>/dev/null && echo "  Installed direnv" || echo "  direnv already installed"
brew install dragon 2>/dev/null && echo "  Installed dragon" || echo "  dragon already installed"

# 3. Remove duplicate cargo fd-find (brew fd is the same)
echo ""
echo "[3/6] Cleaning up cargo duplicates..."
cargo uninstall fd-find 2>/dev/null && echo "  Removed cargo fd-find (brew fd is identical)" || echo "  cargo fd-find already removed"

# 4. Remove Oh-My-Fish
echo ""
echo "[4/6] Removing Oh-My-Fish..."
if command -v omf &>/dev/null; then
    omf destroy 2>/dev/null && echo "  Removed OMF via omf destroy" || echo "  OMF destroy failed, manual cleanup needed"
else
    echo "  OMF command not found (already removed or not in PATH)"
fi
rm -rf "$HOME/.config/omf" 2>/dev/null && echo "  Removed ~/.config/omf" || true
rm -rf "$HOME/.local/share/omf" 2>/dev/null && echo "  Removed ~/.local/share/omf" || true

# 5. Remove unused tmux plugins
echo ""
echo "[5/6] Cleaning unused tmux plugins..."
for plugin in tmux-colors-solarized tmux-themepack tmux-tokyo-night tmux-yank; do
    rm -rf "$HOME/.config/tmux/plugins/$plugin" 2>/dev/null && echo "  Removed $plugin" || true
done

# 6. Remove neofetch and skhd configs
echo ""
echo "[6/6] Cleaning up old config directories..."
rm -rf "$HOME/.config/neofetch" 2>/dev/null && echo "  Removed neofetch config" || true
rm -rf "$HOME/.config/skhd" 2>/dev/null && echo "  Removed skhd config" || true

echo ""
echo "=== Migration complete! ==="
echo ""
echo "Next steps (manual):"
echo "  1. Reload fish:  source ~/.config/fish/config.fish"
echo "  2. Reload tmux:  tmux source-file ~/.config/tmux/tmux.conf"
echo "  3. Re-export Brewfile:  bash ~/.config/scripts/brew-export.sh"
echo "  4. Update Yazi plugins:  ya pkg upgrade"
echo "  5. Test pay-respects by mistyping a command, then pressing F"
