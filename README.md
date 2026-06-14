# dotfiles

Configuracion completa de mi Mac: fish, nvim, tmux, ghostty, yazi, AeroSpace,
sketchybar y la capa visual Violet Hour Glass. Todo converge con UN comando.

(README reescrito 2026-06: el anterior era el auto-generado de dotfyle, solo
cubria nvim y describia plugins que ya no existen.)

## Replicar en un Mac nuevo

```sh
# 1. Clonar EN ~/.config (el repo ES el XDG config dir)
git clone git@github.com:YOUR-USER/dotfiles.git ~/.config

# 2. Converger la maquina (instala Xcode CLT, brew, todo el Brewfile,
#    rustup, fish como shell, fisher, mise, plugins de tmux/yazi, tema,
#    defaults de macOS, servicios). Idempotente: re-correrlo = todo SKIP.
bash ~/.config/scripts/setup.sh
```

`setup.sh` es la unica fuente de orquestacion. Subcomandos:

```sh
setup.sh            # converger (= sync)
setup.sh doctor     # health check, no toca nada
setup.sh export     # re-exporta el Brewfile (filtra .brewfile-exclude)
setup.sh --upgrade  # sync + upgrade de paquetes existentes
```

Desde fish, los atajos son `up-mac` (sync) y `mac-doctor`.

## Pasos manuales (una vez por maquina)

Cosas que requieren login o permisos que macOS no deja automatizar:

1. `gh auth login` y re-correr setup.sh (instala las gh extensions).
2. nvim: abrir, dejar que lazy/mason instalen, y `:LspCopilotSignIn`
   (ghost text + NES via sidekick.nvim, cuenta GitHub).
3. 1Password: iniciar sesion. Secrets de shell: `~/.secrets.fish`
   (NO versionado; pendiente de migrar a `op run`).
4. Permisos macOS: Screen Recording para sketchybar, Accessibility para
   AeroSpace, Calendar para icalBuddy. macOS los resetea tras algunos updates;
   `setup.sh doctor` lo recuerda.
5. `atuin login` si quieres sync de historial entre maquinas.

## Donde vive cada cosa

| Capa | Fichero(s) |
| --- | --- |
| Paquetes (brew/cask/mas) | `.Brewfile` (+ `.brewfile-exclude` para el export) |
| Toolchains (node/go/python/java/deno/pnpm + go/cargo/pipx tools) | `mise/config.toml` |
| Rust | rustup (deliberadamente fuera de mise) |
| Shell | `fish/` (plugins en `fish_plugins`, fuente de verdad de fisher) |
| Editor | `nvim/` (lazy.nvim; cheatsheet en `nvim/cheatsheet.md`, `ncheat`) |
| Multiplexor | `tmux/tmux.conf` (TPM; tpm/smart-splits/sessionx, nada mas) |
| Terminal | `ghostty/config` |
| File manager | `yazi/` |
| Window manager | `aerospace/`, `borders/`, `sketchybar/` |
| Defaults macOS | `scripts/macos-tweaks.sh` (reversible con `-revert`) |
| Capa visual | `scripts/macos-violet-hour.sh`, `wallpapers/`, `Styles/` |

Principio del repo: cada valor vive en UN sitio. setup.sh nunca duplica
config, solo converge contra estos ficheros.

## Auditorias

El estado y las decisiones recientes estan documentados en
`CONFIG-AUDIT-2026-06.md` y `nvim/AUDIT-PLUGINS-2026-06.md`.
