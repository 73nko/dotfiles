# personal/ — optional private layer

Public setup does not require this directory. It is an optional, manually
managed home for machine- or organization-specific configuration that must not
be published. Everything below `personal/` is ignored except this README.

## Suggested structure

```text
personal/
├── assets/
│   └── wallpapers/
│       └── glacier-signal-source.jpg
├── fish/                  private abbreviations and functions
│   └── work.fish          loaded by fish/config.fish when present
├── tmux/                  private bindings
│   └── work.conf          loaded by tmux/tmux.conf when present
├── fastfetch/
│   └── logo.txt           optional private ASCII logo
└── work/                  private helper files, if needed
```

Organization-specific Fish abbreviations and internal command wrappers are
intentionally private and deferred from the public setup. Add them under
`personal/fish/`; do not add them to the public `fish/config.fish`.

## Cross-Mac synchronization

Keep this directory as a separate private Git repository. The parent dotfiles
repository ignores it, and `scripts/sync-dotfiles.sh` pulls it with
`--ff-only` whenever the nested checkout exists:

```sh
git -C ~/.config/personal init
git -C ~/.config/personal remote add origin <private-repository-url>
git -C ~/.config/personal add .
git -C ~/.config/personal commit -m "Track private Mac configuration"
git -C ~/.config/personal push -u origin main
```

On another Mac, remove the empty scaffold left by the public clone if needed,
then clone that private repository at the same path. If you do not want a
private remote, manually copy `personal/` from a trusted source instead.

`scripts/setup.sh` never creates, downloads, or requires private files. The sync
wrapper only updates an already configured nested repository; setup uses an
optional asset only when it is already present.

The Glacier Signal source wallpaper also belongs here because the public
dotfiles repository should not redistribute third-party artwork. Setup derives
the display crops and Chrome new-tab image locally when
`assets/wallpapers/glacier-signal-source.jpg` exists.

Fish and tmux safely skip their personal globs when no matching files exist.
Fastfetch is different: its tracked config points to
`personal/fastfetch/logo.txt`; add that optional file or change the logo `type`
in `fastfetch/config.jsonc` to `auto`.

gh-dash organization filters are also local, but use the separate ignored
`gh-dash/config.yml`: copy `gh-dash/config.yml.example`, then replace
`YOUR-ORG`. They are not loaded from `personal/`.

Before publishing public changes, confirm private files remain absent from the
parent repository's `git status`.
