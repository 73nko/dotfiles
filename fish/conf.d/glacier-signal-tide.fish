# ============================================================================
# Glacier Signal - Tide color override
# Retinta el prompt de tide al palette del style guide v2 (§08).
# Tide guarda vars como -U (universal). Este conf.d las re-fuerza en cada
# shell interactiva para que cualquier "tide configure" accidental se revierta.
# ============================================================================

if not status is-interactive
    exit
end

# ---- Layout: items on each side of the prompt ------------------------------
# Universal (-U) so they survive restarts. Only seeded if they do NOT exist
# yet (first install on a new machine). This way a later `tide configure` can
# customize them without this conf.d overwriting on every shell.
if not set -q _tide_left_items
    set -U _tide_left_items os pwd git newline character
end
if not set -q _tide_right_items
    set -U _tide_right_items status cmd_duration context jobs direnv node python rustc java ruby go kubectl aws elixir time
end

# ---- Character (prompt glyph, linea 2) -------------------------------------
set -g tide_character_color            22b8f5   # orchid - prompt normal
set -g tide_character_color_failure    5ff2cf   # rose_mist - en fallo

# ---- PWD (linea 1) ----------------------------------------------------------
set -g tide_pwd_color_anchors          b8f1ff   # cyan_mist - dirs importantes
set -g tide_pwd_color_dirs             7fe0ff   # ice - dirs normales
set -g tide_pwd_color_truncated_dirs   839b9e   # silver muted - segmentos omitidos

# ---- Git --------------------------------------------------------------------
set -g tide_git_color_branch           5ff2cf   # rose_mist
set -g tide_git_color_dirty            e0fbff   # bloom
set -g tide_git_color_conflicted       5ff2cf   # rose_mist
set -g tide_git_color_operation        22b8f5   # orchid
set -g tide_git_color_staged           e0fbff   # bloom
set -g tide_git_color_stash            a8ecff   # lilac
set -g tide_git_color_untracked        b8f1ff   # cyan_mist
set -g tide_git_color_upstream         7fe0ff   # ice

# ---- Status icon (success / failure) ---------------------------------------
set -g tide_status_color               b8f1ff   # cyan_mist - clean
set -g tide_status_color_failure       5ff2cf   # rose_mist

# ---- Cmd duration (>2s per guide §08) --------------------------------------
set -g tide_cmd_duration_color         839b9e   # silver muted
set -g tide_cmd_duration_threshold     2000

# ---- Context (user@host remoto) --------------------------------------------
set -g tide_context_color_default      f3faf7   # star
set -g tide_context_color_root         5ff2cf   # rose_mist - aviso visual
set -g tide_context_color_ssh          7fe0ff   # ice

# ---- Time / runtime modules -----------------------------------------------
set -g tide_time_color                 5f9bd8   # periwinkle
set -g tide_node_color                 7fe0ff
set -g tide_python_color               e0fbff
set -g tide_ruby_color                 22b8f5
set -g tide_go_color                   7fe0ff
set -g tide_rustc_color                5ff2cf
set -g tide_java_color                 e0fbff
set -g tide_bun_color                  f3faf7
set -g tide_aws_color                  5ff2cf
set -g tide_kubectl_color              7fe0ff
set -g tide_docker_color               5f9bd8
set -g tide_gcloud_color               7fe0ff
set -g tide_terraform_color            22b8f5
set -g tide_direnv_color               e0fbff

# ---- Jobs / vi-mode -------------------------------------------------------
set -g tide_jobs_color                 5ff2cf
set -g tide_vi_mode_color_default      22b8f5
set -g tide_vi_mode_color_replace      5ff2cf
set -g tide_vi_mode_color_visual       e0fbff

# ---- Frame / separators (discretos, no roban foco) ------------------------
set -g tide_prompt_color_frame_and_connection  0d3547
set -g tide_prompt_color_separator_same_color  839b9e

# ---- Misc -----------------------------------------------------------------
set -g tide_prompt_add_newline_before  true
set -g tide_prompt_transient_enabled   true
