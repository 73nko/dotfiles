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
# Nebula Theme — fish syntax highlighting
# ============================================
set -g fish_color_command        7AB9F5    # blue    — commands
set -g fish_color_builtin        CBA6F7    # mauve   — builtins
set -g fish_color_keyword        BD93F9    # purple  — keywords (if/for/while)
set -g fish_color_param          CDD6F4    # text    — arguments
set -g fish_color_quote          A6E3A1    # green   — strings
set -g fish_color_redirection    4DD0E1    # cyan    — redirections
set -g fish_color_end            CBA6F7    # mauve   — semicolons, &&
set -g fish_color_error          F48FB1    # rose    — errors
set -g fish_color_comment        4A5480    # muted   — comments
set -g fish_color_operator       FF79C6    # pink    — operators
set -g fish_color_escape         FAB387    # peach   — escape sequences
set -g fish_color_autosuggestion 4A5480    # muted   — ghost text
set -g fish_color_cancel         F48FB1    # rose    — Ctrl+C
set -g fish_color_search_match   --background=252840
set -g fish_pager_color_prefix        FF79C6 --bold --underline
set -g fish_pager_color_completion    CDD6F4
set -g fish_pager_color_description  4A5480
set -g fish_pager_color_progress     4DD0E1 --background=070A13


# ============================================
# Prompt — starship va primero, antes de cualquier
# cosa que pueda fallar
# ============================================
if command -q starship
    starship init fish | source
end

# ============================================
# Vi Mode
# ============================================
fish_vi_key_bindings

# ============================================
# Basic Aliases
# ============================================
alias .. 'cd ..'
alias cc clear
alias n nvim
alias python python3
alias pip pip3

# ============================================
# File Navigation & Listing
# ============================================
alias ls 'eza --icons=always'
alias l 'eza --icons=always -l'
alias la 'eza --icons=always -a'
alias lla 'eza --icons=always -la'
alias lt 'eza --icons=always --tree'
alias cat 'bat --paging=never'

# ============================================
# Git Abbreviations — idénticas al plugin git de oh-my-zsh
# Aliases con rama dinámica están en functions/ (gcm, gpsup, ggpull, ggpush, grbm, gswm)
# ============================================
abbr -a g       'git'
# --- Add ---
abbr -a ga      'git add'
abbr -a gaa     'git add --all'
abbr -a gapa    'git add --patch'
abbr -a gau     'git add --update'
abbr -a gav     'git add --verbose'
# --- Branch ---
abbr -a gb      'git branch'
abbr -a gba     'git branch --all'
abbr -a gbd     'git branch --delete'
abbr -a gbD     'git branch --delete --force'
abbr -a gbl     'git blame -w'
abbr -a gbnm    'git branch --no-merged'
abbr -a gbr     'git branch --remote'
# --- Commit ---
abbr -a gc      'git commit --verbose'
abbr -a gca     'git commit --verbose --all'
abbr -a gcmsg   'git commit --message'
abbr -a gcam    'git commit --all --message'
abbr -a gcs     'git commit --gpg-sign'
abbr -a gcf     'git config --list'
abbr -a gcfu    'git commit --fixup'
# --- Checkout / Switch ---
abbr -a gco     'git checkout'
abbr -a gcb     'git checkout -b'
abbr -a gcB     'git checkout -B'
abbr -a gsw     'git switch'
abbr -a gswc    'git switch --create'
# --- Cherry-pick ---
abbr -a gcp     'git cherry-pick'
abbr -a gcpa    'git cherry-pick --abort'
abbr -a gcpc    'git cherry-pick --continue'
# --- Clone ---
abbr -a gcl     'git clone --recurse-submodules'
abbr -a gclean  'git clean --interactive -d'
# --- Diff ---
abbr -a gd      'git diff'
abbr -a gdca    'git diff --cached'
abbr -a gdcw    'git diff --cached --word-diff'
abbr -a gds     'git diff --staged'
abbr -a gdw     'git diff --word-diff'
abbr -a gdup    'git diff @{upstream}'
# --- Fetch ---
abbr -a gf      'git fetch'
abbr -a gfa     'git fetch --all --tags --prune'
abbr -a gfo     'git fetch origin'
# --- Log ---
abbr -a glo     'git log --oneline --decorate'
abbr -a glog    'git log --oneline --decorate --graph'
abbr -a gloga   'git log --oneline --decorate --graph --all'
abbr -a glg     'git log --stat'
# --- Merge ---
abbr -a gm      'git merge'
abbr -a gma     'git merge --abort'
abbr -a gmc     'git merge --continue'
abbr -a gms     'git merge --squash'
abbr -a gmff    'git merge --ff-only'
# --- Pull ---
abbr -a gl      'git pull'
abbr -a gpr     'git pull --rebase'
abbr -a gpra    'git pull --rebase --autostash'
# --- Push ---
abbr -a gp      'git push'
abbr -a gpd     'git push --dry-run'
abbr -a gpf     'git push --force-with-lease'
abbr -a gpv     'git push --verbose'
abbr -a gpod    'git push origin --delete'
# --- Rebase ---
abbr -a grb     'git rebase'
abbr -a grba    'git rebase --abort'
abbr -a grbc    'git rebase --continue'
abbr -a grbi    'git rebase --interactive'
abbr -a grbo    'git rebase --onto'
abbr -a grbs    'git rebase --skip'
# --- Reflog ---
abbr -a grf     'git reflog'
# --- Remote ---
abbr -a gr      'git remote'
abbr -a grv     'git remote --verbose'
abbr -a gra     'git remote add'
abbr -a grrm    'git remote remove'
abbr -a grmv    'git remote rename'
abbr -a grset   'git remote set-url'
abbr -a grup    'git remote update'
# --- Reset ---
abbr -a grh     'git reset'
abbr -a grhh    'git reset --hard'
abbr -a grhs    'git reset --soft'
# --- Restore ---
abbr -a grs     'git restore'
abbr -a grss    'git restore --source'
abbr -a grst    'git restore --staged'
# --- Revert ---
abbr -a grev    'git revert'
abbr -a greva   'git revert --abort'
abbr -a grevc   'git revert --continue'
# --- Rm ---
abbr -a grm     'git rm'
abbr -a grmc    'git rm --cached'
# --- Show ---
abbr -a gsh     'git show'
# --- Stash ---
abbr -a gsta    'git stash push'
abbr -a gstp    'git stash pop'
abbr -a gstaa   'git stash apply'
abbr -a gstl    'git stash list'
abbr -a gstd    'git stash drop'
abbr -a gstc    'git stash clear'
abbr -a gsts    'git stash show --patch'
abbr -a gstall  'git stash --all'
# --- Status ---
abbr -a gst     'git status'
abbr -a gss     'git status --short'
abbr -a gsb     'git status --short --branch'
# --- Tag ---
abbr -a gta     'git tag --annotate'
abbr -a gtv     'git tag | sort -V'
# --- Misc ---
abbr -a gcount     'git shortlog --summary --numbered'
abbr -a gignore    'git update-index --assume-unchanged'
abbr -a gunignore  'git update-index --no-assume-unchanged'
abbr -a ship-it    'git push --force origin main:production'
abbr -a del-branches 'git branch | grep -v main | xargs git branch -D'
# Aliases dinámicos (necesitan la rama actual o main) — ver functions/
# gcm   → git checkout main/master
# gswm  → git switch main/master
# grbm  → git rebase main/master
# gpsup → git push --set-upstream origin <current>
# ggpull → git pull origin <current>
# ggpush → git push origin <current>

# ============================================
# Tmux Aliases
# ============================================
alias t tmux
alias tn 'tmux new'
alias td 'tmux detach'
alias ta 'tmux attach-session'
alias trw 'tmux rename-window'
alias trs 'tmux rename-session'
alias tns 'tmux new -s'
alias tna 'tmux new -s YOUR-ORG'
alias taw 'tmux attach -t YOUR-ORG'
alias tbs 'tmux attach -t bundle-shopify'
alias tconf 'nvim ~/.config/tmux/tmux.conf'

# ============================================
# Utilities
# ============================================
alias we 'curl wttr.in/Madrid?1nqF'
alias bou 'brew update && brew outdated && brew upgrade && brew cleanup'
alias app-listen 'lsof -nP -iTCP -sTCP:LISTEN'
alias up-all topgrade
alias reload-fish 'source ~/.config/fish/config.fish'
alias edit-fish 'nvim ~/.config/fish/config.fish'
alias ncheat 'glow ~/.config/nvim/cheatsheet.md'
alias awt 'cd ~/YOUR-ORG'
# 'ssh' and 'dy' are full functions (see functions/) to handle env vars and complex args

# ============================================
# FZF (requiere fzf >= 0.48 para --fish)
# ============================================
set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

set -x FZF_DEFAULT_OPTS "\
  --color=fg:#CBE0F0,bg:#011628,hl:#B388FF \
  --color=fg+:#CBE0F0,bg+:#143652,hl+:#B388FF \
  --color=info:#06BCE4,prompt:#2CF9ED,pointer:#2CF9ED \
  --color=marker:#2CF9ED,spinner:#2CF9ED,header:#2CF9ED"

set -x FZF_CTRL_T_OPTS "--preview 'bat -n --color=always --line-range :500 {}'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

if command -q fzf
    fzf --fish 2>/dev/null | source
end

# ============================================
# Node — fnm (reemplaza nvm, soporte nativo fish)
# Instalar: brew install fnm
# ============================================
if command -q fnm
    fnm env --use-on-cd --shell fish | source
end

# ============================================
# Secrets (API Keys, Tokens, etc.)
# El archivo debe usar sintaxis fish: set -x VAR value
# ============================================
if test -f ~/.secrets.fish
    source ~/.secrets.fish
end

# ============================================
# thefuck
# ============================================
if command -q thefuck
    thefuck --alias | source
end

# OpenClaw Completion
source "$HOME/.openclaw/completions/openclaw.fish"
