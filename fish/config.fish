# ============================================
# PATH
# ============================================
# Homebrew — Apple Silicon (/opt/homebrew) and Intel (/usr/local)
# fish_add_path silently skips non-existent paths
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# Disable greeting
set -g fish_greeting ""

# ============================================
# Violet Hour · Glacier Signal — fish syntax highlighting (repaleta 2026-07)
# Antes "Neon Nocturne" (paleta distinta de nvim). Unificado al espectro nuevo:
# command=gold, builtin=teal, keyword=orchid, string=green, type=azure...
# ============================================
set -g fish_color_command        ffd873    # amber  — commands (@function)
set -g fish_color_builtin        5ff2cf    # mint   — builtins (@function.builtin)
set -g fish_color_keyword        22b8f5    # orchid — keywords (@keyword)
set -g fish_color_param          f3faf7    # star   — arguments (@variable)
set -g fish_color_quote          8fdc8f    # jade  — strings (@string)
set -g fish_color_redirection    b8f1ff    # cyan-mist  — redirections (@type)
set -g fish_color_end            22b8f5    # orchid — semicolons, &&
set -g fish_color_error          ff7a6e    # coral  — errors
set -g fish_color_comment        559eb7    # comment lifted — comments (@comment)
set -g fish_color_operator       22b8f5    # orchid — operators (@operator)
set -g fish_color_escape         ffd873    # amber  — escape sequences (@constant)
set -g fish_color_autosuggestion 438198    # dim    — ghost text (subtil a proposito)
set -g fish_color_cancel         ff7a6e    # coral  — Ctrl+C
set -g fish_color_search_match   --background=0f526f
set -g fish_pager_color_prefix        ffd873 --bold --underline
set -g fish_pager_color_completion    f3faf7
set -g fish_pager_color_description  559eb7
set -g fish_pager_color_progress     ffd873 --background=062230

# ============================================
# Vi Mode
# ============================================
fish_vi_key_bindings

# ============================================
# Basic Abbreviations (expand inline — better history & debugging)
# ============================================
abbr -a -- .. 'cd ..'
abbr -a cc clear
abbr -a n nvim

# ============================================
# File Navigation & Listing
# ============================================
abbr -a ls 'eza --icons=always'
abbr -a l 'eza --icons=always -l'
abbr -a la 'eza --icons=always -a'
abbr -a lla 'eza --icons=always -la'
abbr -a lt 'eza --icons=always --tree'
abbr -a cat 'bat --paging=never'

# ============================================
# Git Extras (plugin-git handles the bulk via __git.init)
# Dynamic aliases are in functions/ (gcm, gpsup, ggpull, ggpush, grbm, gswm)
# ============================================
# NOTE: 'g', 'gcount', 'gignore', 'gunignore' are now handled by plugin-git
abbr -a prune-branches 'gh poi'

# ============================================
# Tmux Abbreviations
# ============================================
abbr -a t tmux
abbr -a tn 'tmux new'
abbr -a td 'tmux detach'
abbr -a ta 'tmux attach-session'
abbr -a trw 'tmux rename-window'
abbr -a trs 'tmux rename-session'
abbr -a tns 'tmux new -s'
abbr -a tconf 'nvim ~/.config/tmux/tmux.conf'

# ============================================
# Utilities
# ============================================
abbr -a we 'curl wttr.in/Madrid?1nqF'
abbr -a bou 'brew update && brew outdated && brew upgrade && brew cleanup'
abbr -a app-listen 'lsof -nP -iTCP -sTCP:LISTEN'
abbr -a up-all topgrade
# Converge la maquina al estado de los dotfiles (un solo comando para todo)
abbr -a up-mac 'bash ~/.config/scripts/setup.sh'
abbr -a mac-doctor 'bash ~/.config/scripts/setup.sh doctor'
abbr -a reload-fish 'source ~/.config/fish/config.fish'
abbr -a edit-fish 'nvim ~/.config/fish/config.fish'
abbr -a ncheat 'nvim ~/.config/nvim/cheatsheet.md'
abbr -a ncheatw 'open ~/.config/nvim/cheatsheet.html'

# 'ssh' and 'dy' are full functions (see functions/) to handle env vars and complex args

# ============================================
# FZF (requiere fzf >= 0.48 para --fish)
# ============================================
set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

set -x FZF_DEFAULT_OPTS "\
  --color=fg:#f3faf7,bg:#062230,hl:#ffd873 \
  --color=fg+:#8fdc8f,bg+:#0f526f,hl+:#ffd873 \
  --color=info:#5ff2cf,prompt:#22b8f5,pointer:#ff7a6e \
  --color=marker:#8fdc8f,spinner:#5ff2cf,header:#b8f1ff"

set -x FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# ============================================
# Node — mise (loaded via conf.d/mise.fish)
# FZF, Zoxide, Direnv, pay-respects are also in conf.d/
# ============================================

# ============================================
# Secrets (API Keys, Tokens, etc.)
# Must use fish syntax: set -x VAR value
# ============================================
if test -f ~/.secrets.fish
    source ~/.secrets.fish
end

# ============================================
# Personal layer (gitignored in the public repo).
# User-specific abbrs, functions and bindings.
# See ~/.config/personal/README.md for the structure.
# ============================================
for file in ~/.config/personal/fish/*.fish
    test -f "$file"; and source "$file"
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
