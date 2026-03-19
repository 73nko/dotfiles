vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", {
  desc = "Exit insert mode with jk",
})

-- Clear search highlights on Esc (was <leader>nh, collided with snacks hide notification)
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", {
  desc = "Clear search highlights",
})

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "|", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "-", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tabs: <leader>T prefix (was <leader>t, collided with test prefix)
keymap.set("n", "<leader>To", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>Tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>Tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>Tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>Tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Move lines: Shift+Alt (was Alt-j/k, collided with smart-splits resize)
keymap.set("n", "<S-A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<S-A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("v", "<S-A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "<S-A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save the current buffer" })
keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit" })

keymap.set("n", "gw", "<cmd>set wrap!<CR>", {
  desc = "Toggle line wrap",
})

keymap.set("n", "<leader>bb", "<cmd>b#<CR>", {
  desc = "Switch to last buffer",
})
