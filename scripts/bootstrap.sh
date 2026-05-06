#!/bin/bash
set -euo pipefail

# ============================================
# Bootstrap script for a fresh macOS machine
# Replicates the full terminal setup from ~/.config
#
# Prerequisites:
#   - macOS (Apple Silicon or Intel)
#   - This .config folder copied/cloned to ~/.config
#
# Usage:
#   bash ~/.config/scripts/bootstrap.sh
# ============================================

DOTFILES_DIR="$HOME/.config"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="/tmp/bootstrap-$(date +%Y%m%d-%H%M%S).log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

step=0
total_steps=14

progress() {
    step=$((step + 1))
    echo -e "\n${BLUE}[$step/$total_steps]${NC} $1"
}

ok() {
    echo -e "  ${GREEN}OK${NC} $1"
}

warn() {
    echo -e "  ${YELLOW}SKIP${NC} $1"
}

fail() {
    echo -e "  ${RED}FAIL${NC} $1"
}

# ============================================
# 0. Preflight checks
# ============================================
echo -e "${BLUE}=== macOS Terminal Bootstrap ===${NC}"
echo "Log file: $LOG_FILE"
echo ""

if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}This script is for macOS only.${NC}"
    exit 1
fi

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}~/.config not found. Clone/copy your dotfiles there first.${NC}"
    exit 1
fi

# ============================================
# 1. Xcode Command Line Tools
# ============================================
progress "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
    ok "Already installed"
else
    echo "  Installing (this may take a while)..."
    xcode-select --install 2>&1 | tee -a "$LOG_FILE"
    echo "  Waiting for installation to complete..."
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    ok "Installed"
fi

# ============================================
# 2. Homebrew
# ============================================
progress "Homebrew"
if command -v brew &>/dev/null; then
    ok "Already installed"
else
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>&1 | tee -a "$LOG_FILE"

    # Add brew to PATH for the rest of this script
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    ok "Installed"
fi

# ============================================
# 3. Rust toolchain (needed BEFORE Brewfile for cargo packages)
# ============================================
progress "Rust toolchain"
if command -v rustup &>/dev/null; then
    ok "Rustup already installed"
elif command -v rustc &>/dev/null; then
    ok "Rust available via Homebrew"
else
    echo "  Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 2>&1 | tee -a "$LOG_FILE"
    source "$HOME/.cargo/env"
    ok "Rust installed"
fi

# ============================================
# 4. Install everything from Brewfile
# ============================================
progress "Brew packages, casks, and Mac App Store apps"
if [[ -f "$DOTFILES_DIR/.Brewfile" ]]; then
    echo "  This installs CLI tools, GUI apps, fonts, VS Code extensions,"
    echo "  Go binaries, Cargo crates, and Mac App Store apps."
    echo "  It may take 10-20 minutes on a fresh machine."
    echo ""
    brew bundle --file="$DOTFILES_DIR/.Brewfile" 2>&1 | tee -a "$LOG_FILE"
    ok "Brewfile installed"
else
    fail ".Brewfile not found at $DOTFILES_DIR/.Brewfile"
fi

# ============================================
# 5. Set Fish as default shell
# ============================================
progress "Fish shell as default"
FISH_PATH="$(command -v fish 2>/dev/null)"
if [[ -z "$FISH_PATH" ]]; then
    fail "Fish not found. It should have been installed via Brewfile"
fi

if [[ "$SHELL" == *"fish"* ]]; then
    ok "Already default shell"
else
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
        ok "Added $FISH_PATH to /etc/shells"
    fi
    chsh -s "$FISH_PATH"
    ok "Default shell changed to Fish"
fi

# ============================================
# 6. Fisher + Fish plugins
# ============================================
progress "Fisher plugin manager and Fish plugins"
if [[ -f "$DOTFILES_DIR/fish/functions/fisher.fish" ]]; then
    ok "Fisher already present in config"
else
    echo "  Installing Fisher..."
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" 2>&1 | tee -a "$LOG_FILE"
    ok "Fisher installed"
fi

# Install plugins from fish_plugins manifest
if [[ -f "$DOTFILES_DIR/fish/fish_plugins" ]]; then
    echo "  Installing Fish plugins from manifest..."
    fish -c "fisher update" 2>&1 | tee -a "$LOG_FILE"
    ok "Fish plugins installed (fisher, plugin-git, tide)"
else
    warn "fish_plugins manifest not found"
fi

# Re-apply Tide fish-path patch (fisher update overwrites it).
# Tide bakes the resolved Cellar fish path into fish_prompt at session start,
# so upgrading fish via brew breaks every running session. Swap to the stable
# symlink so the baked-in path survives upgrades.
TIDE_PROMPT="$DOTFILES_DIR/fish/functions/fish_prompt.fish"
if [[ -f "$TIDE_PROMPT" ]] && grep -q '^status fish-path | read -l fish_path' "$TIDE_PROMPT"; then
    sed -i '' 's#^status fish-path | read -l fish_path#command -v fish | read -l fish_path#' "$TIDE_PROMPT"
    ok "Patched Tide fish_prompt to use stable fish path"
fi

# ============================================
# 7. Tide prompt configuration
# ============================================
progress "Tide prompt"
# Tide's universal variables are stored in fish_variables which is already
# part of the config. If it exists, Tide will pick up the configuration
# automatically on first launch.
if [[ -f "$DOTFILES_DIR/fish/fish_variables" ]]; then
    ok "Tide configuration found in fish_variables (will auto-load)"
else
    warn "fish_variables not found. Run 'tide configure' manually after first launch"
fi

# ============================================
# 8. TPM (tmux plugin manager)
# ============================================
progress "Tmux Plugin Manager (TPM)"
TPM_DIR="$DOTFILES_DIR/tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
    ok "TPM already present"
else
    echo "  Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" 2>&1 | tee -a "$LOG_FILE"
    ok "TPM installed"
fi

echo "  Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins" 2>&1 | tee -a "$LOG_FILE" || warn "TPM install_plugins failed (tmux may not be running)"
ok "Tmux plugins installed"

# ============================================
# 9. Yazi plugins
# ============================================
progress "Yazi plugins"
if command -v ya &>/dev/null; then
    ya pkg install 2>&1 | tee -a "$LOG_FILE"
    ok "Yazi plugins installed"
else
    warn "ya command not found. Install yazi first, then run 'ya pkg install'"
fi

# ============================================
# 10. Node.js via fnm

# ============================================
progress "Node.js via fnm"
if command -v fnm &>/dev/null; then
    CURRENT_NODE=$(fnm current 2>/dev/null || echo "none")
    if [[ "$CURRENT_NODE" == "none" ]] || [[ "$CURRENT_NODE" == "system" ]]; then
        echo "  Installing latest LTS Node..."
        fnm install --lts 2>&1 | tee -a "$LOG_FILE"
        fnm default lts-latest 2>&1 | tee -a "$LOG_FILE"
        ok "Node.js LTS installed"
    else
        ok "Node.js $CURRENT_NODE already active"
    fi
else
    warn "fnm not found. It should have been installed via Brewfile"
fi

# ============================================
# 11. Borders service (window borders)

# ============================================
progress "Borders service"
if command -v borders &>/dev/null; then
    brew services start borders 2>&1 | tee -a "$LOG_FILE" || true
    ok "Borders service started"
else
    warn "borders not found"
fi

# ============================================
# 12. macOS defaults
# ============================================
progress "macOS preferences"

# Faster key repeat (useful for vim navigation)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Disable press-and-hold for keys (enable key repeat everywhere)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Save screenshots to ~/Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

ok "macOS preferences set"

# ============================================
# 13. Git identity
# ============================================
progress "Git identity"
GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [[ -z "$GIT_NAME" ]]; then
    echo -n "  Your name for git commits: "
    read -r GIT_NAME
    git config --global user.name "$GIT_NAME"
    ok "Set git user.name = $GIT_NAME"
else
    ok "Already set: $GIT_NAME"
fi

if [[ -z "$GIT_EMAIL" ]]; then
    echo -n "  Your email for git commits: "
    read -r GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
    ok "Set git user.email = $GIT_EMAIL"
else
    ok "Already set: $GIT_EMAIL"
fi

# Set sensible git defaults
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true
git config --global pull.rebase true
git config --global core.editor nvim
ok "Git defaults set (main branch, auto remote, rebase pull, nvim editor)"

# ============================================
# 14. Health check
# ============================================
progress "Health check"
echo ""
ERRORS=0

check_cmd() {
    if command -v "$1" &>/dev/null; then
        echo -e "  ${GREEN}OK${NC}  $1 $(command -v "$1")"
    else
        echo -e "  ${RED}MISSING${NC}  $1"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "  Core tools:"
check_cmd fish
check_cmd nvim
check_cmd tmux
check_cmd git
check_cmd brew

echo "  Terminal & shell:"
check_cmd ghostty
check_cmd fzf
check_cmd fd
check_cmd bat
check_cmd eza
check_cmd zoxide
check_cmd pay-respects
check_cmd fastfetch
check_cmd direnv
check_cmd fnm
check_cmd yazi

echo "  Dev tools:"
check_cmd node
check_cmd go
check_cmd rustc
check_cmd cargo
check_cmd bun
check_cmd deno
check_cmd docker
check_cmd gh
check_cmd lazygit

echo "  Services:"
if brew services list 2>/dev/null | grep -q "borders.*started"; then
    echo -e "  ${GREEN}OK${NC}  borders (running)"
else
    echo -e "  ${YELLOW}WARN${NC}  borders (not running)"
fi

echo ""
if [[ $ERRORS -eq 0 ]]; then
    echo -e "  ${GREEN}All checks passed!${NC}"
else
    echo -e "  ${YELLOW}$ERRORS tool(s) missing. Check the log for install errors.${NC}"
fi

# ============================================
# Done
# ============================================
echo ""
echo -e "${GREEN}=== Bootstrap complete! ===${NC}"
echo ""
echo "What to do now:"
echo ""
echo "  IMPORTANT: if you ran this from an existing fish session, that"
echo "  session's prompt now references a stale Cellar fish path (brew"
echo "  upgraded fish out from under it). Run 'exec fish' or open a new"
echo "  terminal to refresh."
echo ""
echo "  1. Open Ghostty (it's your terminal now)"
echo "  2. Fish + Tide prompt should load automatically"
echo "  3. Start tmux and press Ctrl-a + I to install plugins"
echo "     (TPM script may have already handled this)"
echo "  4. Run 'fastfetch' to verify everything looks right"
echo ""
echo "Optional manual steps:"
echo "  - Sign in to Mac App Store for mas-installed apps"
echo "  - Run 'tide configure' if the prompt doesn't look right"
echo "  - Set up ~/.secrets.fish with your API keys"
echo "  - Log in to 1Password, Slack, Figma, etc."
echo "  - Import your SSH keys and GPG keys"
echo ""
echo "Full log: $LOG_FILE"
