# personal/ — optional private layer

Public setup does not require this directory. It is an optional, manually
managed home for machine- or organization-specific configuration that must not
be published. Everything below `personal/` is ignored except this README.

## Suggested structure

```text
personal/
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

## Manual copy semantics

`scripts/setup.sh` does not create, download, back up, or synchronize this
layer. On another Mac, either create an empty scaffold or manually copy your
private `personal/` directory from a trusted source after cloning the public
repository.

Fish and tmux safely skip their personal globs when no matching files exist.
Fastfetch is different: its tracked config points to
`personal/fastfetch/logo.txt`; add that optional file or change the logo `type`
in `fastfetch/config.jsonc` to `auto`.

gh-dash organization filters are also local, but use the separate ignored
`gh-dash/config.yml`: copy `gh-dash/config.yml.example`, then replace
`YOUR-ORG`. They are not loaded from `personal/`.

Before publishing changes, confirm private files remain absent from
`git status`.
