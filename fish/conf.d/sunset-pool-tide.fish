# ============================================================================
# Sunset · Pool Splash - Tide color override
# Retinta el prompt de tide al palette del style guide (§07).
# Tide guarda vars como -U (universal). Este conf.d las re-fuerza en cada
# shell interactiva para que cualquier "tide configure" accidental se revierta.
# ============================================================================

if not status is-interactive
    exit
end

# ---- Character (prompt glyph, linea 2) -------------------------------------
set -g tide_character_color            FF3D8A   # magenta normal
set -g tide_character_color_failure    FF8A3D   # tangerine en fallo

# ---- PWD (linea 1) ----------------------------------------------------------
set -g tide_pwd_color_anchors          7FE0EB   # turquoise_hi - dirs importantes
set -g tide_pwd_color_dirs             4EC9D7   # turquoise - dirs normales
set -g tide_pwd_color_truncated_dirs   A58670   # rosegold muted - segmentos omitidos

# ---- Git --------------------------------------------------------------------
set -g tide_git_color_branch           FF8A3D   # tangerine
set -g tide_git_color_dirty            FFD67A   # gold
set -g tide_git_color_conflicted       FF3D8A   # magenta
set -g tide_git_color_operation        FF3D8A   # magenta
set -g tide_git_color_staged           FFD67A   # gold
set -g tide_git_color_stash            FF8A3D   # tangerine
set -g tide_git_color_untracked        8FE3E8   # aqua
set -g tide_git_color_upstream         7FE0EB   # turquoise_hi

# ---- Status icon (success / failure) ---------------------------------------
set -g tide_status_color               7FE0EB   # turquoise_hi
set -g tide_status_color_failure       FF3D8A   # magenta

# ---- Cmd duration (>2s per guide) ------------------------------------------
set -g tide_cmd_duration_color         A58670   # rosegold muted
set -g tide_cmd_duration_threshold     2000

# ---- Context (user@host remoto) --------------------------------------------
set -g tide_context_color_default      FFC6A0   # rosegold
set -g tide_context_color_root         FF3D8A   # magenta - aviso visual
set -g tide_context_color_ssh          7FE0EB   # turquoise_hi

# ---- Time / runtime modules -----------------------------------------------
set -g tide_time_color                 7FE0EB   # turquoise_hi
set -g tide_node_color                 7FE0EB
set -g tide_python_color               FFD67A
set -g tide_ruby_color                 FF3D8A
set -g tide_go_color                   7FE0EB
set -g tide_rustc_color                FF8A3D
set -g tide_java_color                 FFD67A
set -g tide_bun_color                  FFC6A0
set -g tide_aws_color                  FF8A3D
set -g tide_kubectl_color              7FE0EB
set -g tide_docker_color               4EC9D7
set -g tide_gcloud_color               7FE0EB
set -g tide_terraform_color            FF3D8A
set -g tide_direnv_color               FFD67A

# ---- Jobs / vi-mode -------------------------------------------------------
set -g tide_jobs_color                 FF8A3D
set -g tide_vi_mode_color_default      FF3D8A
set -g tide_vi_mode_color_replace      FF8A3D
set -g tide_vi_mode_color_visual       FFD67A

# ---- Frame / separators (discretos, no roban foco) ------------------------
set -g tide_prompt_color_frame_and_connection  3A1550
set -g tide_prompt_color_separator_same_color  A58670

# ---- Misc -----------------------------------------------------------------
set -g tide_prompt_add_newline_before  true
set -g tide_prompt_transient_enabled   true
