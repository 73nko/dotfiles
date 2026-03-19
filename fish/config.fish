# ============================================
# PATH
# ============================================
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path /Applications/Docker.app/Contents/Resources/bin

# Disable greeting
set -g fish_greeting ""

# ============================================
# Tokyo Night — fish syntax highlighting (matched to nvim)
# ============================================
set -g fish_color_command        89b4fa    # blue    — commands (@function)
set -g fish_color_builtin        7dcfff    # cyan    — builtins (@function.builtin)
set -g fish_color_keyword        c4a7ff    # purple  — keywords (@keyword)
set -g fish_color_param          e2e8f0    # text    — arguments (@variable)
set -g fish_color_quote          6ee7a0    # mint    — strings (@string)
set -g fish_color_redirection    56d4e0    # teal    — redirections (@type)
set -g fish_color_end            c4a7ff    # purple  — semicolons, &&
set -g fish_color_error          f472b6    # pink    — errors
set -g fish_color_comment        3b4566    # muted   — comments (@comment)
set -g fish_color_operator       89b4fa    # blue    — operators (@operator)
set -g fish_color_escape         fdba74    # orange  — escape sequences (@constant)
set -g fish_color_autosuggestion 3b4566    # muted   — ghost text
set -g fish_color_cancel         f472b6    # pink    — Ctrl+C
set -g fish_color_search_match   --background=1e2d4a
set -g fish_pager_color_prefix        c4a7ff --bold --underline
set -g fish_pager_color_completion    e2e8f0
set -g fish_pager_color_description  3b4566
set -g fish_pager_color_progress     56d4e0 --background=04060b

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
abbr -a python python3
abbr -a pip pip3

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
abbr -a del-branches 'git branch | grep -v main | xargs git branch -D'

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
abbr -a tna 'tmux new -s YOUR-ORG'
abbr -a taw 'tmux attach -t YOUR-ORG'
abbr -a tbs 'tmux attach -t bundle-shopify'
abbr -a tconf 'nvim ~/.config/tmux/tmux.conf'

# ============================================
# Utilities
# ============================================
abbr -a we 'curl wttr.in/Madrid?1nqF'
abbr -a bou 'brew update && brew outdated && brew upgrade && brew cleanup'
abbr -a app-listen 'lsof -nP -iTCP -sTCP:LISTEN'
abbr -a up-all topgrade
abbr -a reload-fish 'source ~/.config/fish/config.fish'
abbr -a edit-fish 'nvim ~/.config/fish/config.fish'
abbr -a ncheat 'glow ~/.config/nvim/cheatsheet.md'
abbr -a awt 'cd ~/YOUR-ORG'

# 'ssh' and 'dy' are full functions (see functions/) to handle env vars and complex args

# ============================================
# FZF (requiere fzf >= 0.48 para --fish)
# ============================================
set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

set -x FZF_DEFAULT_OPTS "\
  --color=fg:#e2e8f0,bg:#06080f,hl:#c4a7ff \
  --color=fg+:#e2e8f0,bg+:#1e2d4a,hl+:#c4a7ff \
  --color=info:#56d4e0,prompt:#c4a7ff,pointer:#f472b6 \
  --color=marker:#6ee7a0,spinner:#56d4e0,header:#89b4fa"

set -x FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

# ============================================
# Node — fnm (loaded via conf.d/fnm.fish)
# FZF, Zoxide, Direnv, pay-respects are also in conf.d/
# ============================================

# ============================================
# Secrets (API Keys, Tokens, etc.)
# Must use fish syntax: set -x VAR value
# ============================================
if test -f ~/.secrets.fish
    source ~/.secrets.fish
end

# Added by Antigravity
fish_add_path "$HOME/.antigravity/antigravity/bin"

# OpenClaw Completion
if test -f "$HOME/.openclaw/completions/openclaw.fish"
    source "$HOME/.openclaw/completions/openclaw.fish"
end
