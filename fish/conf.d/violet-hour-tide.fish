# ============================================================================
# Violet Hour · Glass - Tide color override
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
set -g tide_character_color            b39dff   # orchid - prompt normal
set -g tide_character_color_failure    e2bcff   # rose_mist - en fallo

# ---- PWD (linea 1) ----------------------------------------------------------
set -g tide_pwd_color_anchors          b9e0ff   # cyan_mist - dirs importantes
set -g tide_pwd_color_dirs             a8c9ff   # ice - dirs normales
set -g tide_pwd_color_truncated_dirs   777494   # silver muted - segmentos omitidos

# ---- Git --------------------------------------------------------------------
set -g tide_git_color_branch           e2bcff   # rose_mist
set -g tide_git_color_dirty            f0d2ff   # bloom
set -g tide_git_color_conflicted       e2bcff   # rose_mist
set -g tide_git_color_operation        b39dff   # orchid
set -g tide_git_color_staged           f0d2ff   # bloom
set -g tide_git_color_stash            d6c8ff   # lilac
set -g tide_git_color_untracked        b9e0ff   # cyan_mist
set -g tide_git_color_upstream         a8c9ff   # ice

# ---- Status icon (success / failure) ---------------------------------------
set -g tide_status_color               b9e0ff   # cyan_mist - clean
set -g tide_status_color_failure       e2bcff   # rose_mist

# ---- Cmd duration (>2s per guide §08) --------------------------------------
set -g tide_cmd_duration_color         777494   # silver muted
set -g tide_cmd_duration_threshold     2000

# ---- Context (user@host remoto) --------------------------------------------
set -g tide_context_color_default      ece6ff   # star
set -g tide_context_color_root         e2bcff   # rose_mist - aviso visual
set -g tide_context_color_ssh          a8c9ff   # ice

# ---- Time / runtime modules -----------------------------------------------
set -g tide_time_color                 8da7ff   # periwinkle
set -g tide_node_color                 a8c9ff
set -g tide_python_color               f0d2ff
set -g tide_ruby_color                 b39dff
set -g tide_go_color                   a8c9ff
set -g tide_rustc_color                e2bcff
set -g tide_java_color                 f0d2ff
set -g tide_bun_color                  ece6ff
set -g tide_aws_color                  e2bcff
set -g tide_kubectl_color              a8c9ff
set -g tide_docker_color               8da7ff
set -g tide_gcloud_color               a8c9ff
set -g tide_terraform_color            b39dff
set -g tide_direnv_color               f0d2ff

# ---- Jobs / vi-mode -------------------------------------------------------
set -g tide_jobs_color                 e2bcff
set -g tide_vi_mode_color_default      b39dff
set -g tide_vi_mode_color_replace      e2bcff
set -g tide_vi_mode_color_visual       f0d2ff

# ---- Frame / separators (discretos, no roban foco) ------------------------
set -g tide_prompt_color_frame_and_connection  1a1745
set -g tide_prompt_color_separator_same_color  777494

# ---- Misc -----------------------------------------------------------------
set -g tide_prompt_add_newline_before  true
set -g tide_prompt_transient_enabled   true
