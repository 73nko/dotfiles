# Neovim Cheatsheet

This is a cheatsheet for your Neovim configuration. It contains all the keymaps, commands, and plugins that are configured in your setup.

## Core Keymaps

| Keymap       | Description                                  |
| ------------ | -------------------------------------------- |
| `<leader>`   | Space                                        |
| `jk`         | Exit insert mode                             |
| `<leader>nh` | Clear search highlights                      |
| `<leader>+`  | Increment number                             |
| `<leader>-`  | Decrement number                             |
| `<leader>sv` | Split window vertically                      |
| `<leader>sh` | Split window horizontally                    |
| `<leader>se` | Make splits equal size                       |
| `<leader>sx` | Close current split                          |
| `<leader>to` | Open new tab                                 |
| `<leader>tx` | Close current tab                            |
| `<leader>tn` | Go to next tab                               |
| `<leader>tp` | Go to previous tab                           |
| `<leader>tf` | Open current buffer in new tab               |
| `<A-j>`      | Move the line down                           |
| `<A-k>`      | Move the line up                             |
| `<leader>w`  | Save the current buffer                      |
| `<leader>q`  | Quit                                         |
| `<Esc>`      | Removes the searched term                    |
| `<leader>ga` | Stage all the changes in the current project |
| `<leader>gc` | Commit the changes                           |
| `<leader>gp` | Push the changes to the remote repository    |

## Plugins

Here is a list of all the plugins that are configured in your Neovim setup.

### aerial.nvim

A code outline window for skimming and quick navigation.

| Keymap      | Description             |
| ----------- | ----------------------- |
| `{`         | Go to previous symbol   |
| `}`         | Go to next symbol       |
| `<leader>a` | Toggle Aerial code view |

### alpha-nvim

A dashboard for Neovim.

| Keymap   | Description                           |
| -------- | ------------------------------------- |
| `e`      | New File                              |
| `SPC ee` | Toggle file explorer                  |
| `SPC ff` | Find File                             |
| `SPC fs` | Find Word                             |
| `SPC wr` | Restore Session For Current Directory |
| `q`      | Quit NVIM                             |

### auto-session

A session manager for Neovim.

| Keymap       | Description                            |
| ------------ | -------------------------------------- |
| `<leader>wr` | Restore session for cwd                |
| `<leader>ws` | Save session for auto session root dir |

### nvim-autopairs

A plugin that automatically closes pairs of brackets, quotes, etc. It has no keymaps.

### opencode.nvim

AI coding assistant plugin.

| Keymap       | Description           |
| ------------ | --------------------- |
| `<leader>aa` | Ask AI (@this)        |
| `<leader>as` | Select AI Action      |
| `<leader>ac` | Add to Context        |
| `<leader>at` | Toggle AI Window      |
| `<leader>au` | Scroll AI Window Up   |
| `<leader>ad` | Scroll AI Window Down |

### bufferline.nvim

A plugin that shows the open buffers in the tabline.

| Keymap       | Description                |
| ------------ | -------------------------- |
| `<S-h>`      | Go to previous buffer      |
| `<S-l>`      | Go to next buffer          |
| `[b`         | Go to previous buffer      |
| `]b`         | Go to next buffer          |
| `<leader>bp` | Toggle pin buffer          |
| `<leader>bP` | Close non-pinned buffers   |
| `<leader>bo` | Close other buffers        |
| `<leader>br` | Close buffers to the right |
| `<leader>bl` | Close buffers to the left  |


### nvim-dap

Debugging Adapter Protocol (DAP) support.

| Keymap       | Description       |
| ------------ | ----------------- |
| `<leader>db` | Toggle Breakpoint |
| `<leader>dc` | Continue          |
| `<leader>di` | Step Into         |
| `<leader>do` | Step Over         |
| `<leader>dO` | Step Out          |
| `<leader>dr` | Open REPL         |
| `<leader>dt` | Toggle DAP UI     |

### neotest

Testing framework integration.

| Keymap       | Description        |
| ------------ | ------------------ |
| `<leader>tt` | Run Nearest Test   |
| `<leader>tT` | Run File Tests     |
| `<leader>td` | Debug Nearest Test |
| `<leader>ts` | Toggle Summary     |
| `<leader>to` | Show Output        |

### nvim-colorizer.lua

A plugin that highlights colors in your code. It has no keymaps.

### tokyonight.nvim

A colorscheme for Neovim. It is set as the default colorscheme.

### nvim-notify

A notification manager for Neovim. It is used to display notifications from other plugins.

### smart-splits.nvim

A plugin for managing window splits.

| Keymap  | Description        |
| ------- | ------------------ |
| `<C-h>` | Move cursor left   |
| `<C-j>` | Move cursor down   |
| `<C-k>` | Move cursor up     |
| `<C-l>` | Move cursor right  |
| `<C-c>` | Close split        |
| `<A-h>` | Resize split left  |
| `<A-j>` | Resize split down  |
| `<A-k>` | Resize split up    |
| `<A-l>` | Resize split right |

### Comment.nvim

A commenting plugin for Neovim. It provides the following keymaps:

| Keymap        | Description                               |
| ------------- | ----------------------------------------- |
| `gcc`         | Toggle comment line                       |
| `gbc`         | Toggle comment block                      |
| `gc` + motion | Toggle comment for the given motion       |
| `gb` + motion | Toggle block comment for the given motion |
