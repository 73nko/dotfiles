# personal/ — gitignored private layer

This folder holds everything that does NOT get published in the public
dotfiles repo: company identifiers, internal tooling, abbrs and bindings
specific to the personal workflow.

The whole folder is gitignored except for this README, which acts as a
scaffold so a fork knows this layer exists.

## Structure

```
personal/
├── work/                  company or side-project tooling
├── fastfetch/             custom logo ASCII art
│   └── logo.txt           referenced from fastfetch/config.jsonc
├── fish/                  specific abbrs and functions
│   └── work.fish          auto-sourced by fish/config.fish
├── tmux/                  specific bindings
│   └── work.conf          auto-sourced by tmux/tmux.conf
└── gh-dash/               overrides with private orgs
```

## How it plugs in

The public dotfiles conditionally `source` this layer:

- `fish/config.fish` sources `personal/fish/*.fish` at the end if it exists
- `tmux/tmux.conf` runs `source-file personal/tmux/*.conf` if it exists
- `gh-dash/config.yml` references orgs as a `YOUR-ORG` placeholder that
  you can replace in your own `config.yml.local` (also gitignored)
- `fastfetch/config.jsonc` points to `personal/fastfetch/logo.txt`; if
  missing, change the `type` to `auto` for the default OS logo

## How to replicate in your fork

1. Clone the public repo
2. `mkdir -p personal/{fish,tmux,gh-dash,fastfetch}` at the root of your clone
3. Add your own private abbrs / bindings / orgs / logo here
4. Never commit the content: `.gitignore` covers `personal/*`
