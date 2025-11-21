vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", {
  desc = "Exit insert mode with jk",
})

keymap.set("n", "<leader>nh", ":nohl<CR>", {
  desc = "Clear search highlights",
})

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", {
  desc = "Increment number",
}) -- increment
keymap.set("n", "<leader>-", "<C-x>", {
  desc = "Decrement number",
}) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", {
  desc = "Split window vertically",
}) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", {
  desc = "Split window horizontally",
}) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", {
  desc = "Make splits equal size",
}) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", {
  desc = "Close current split",
}) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {
  desc = "Open new tab",
}) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", {
  desc = "Close current tab",
}) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", {
  desc = "Go to next tab",
}) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", {
  desc = "Go to previous tab",
}) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {
  desc = "Open current buffer in new tab",
}) --  move current buffer to new tab

keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move the line down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move the line up" })

keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save the current buffer" })
keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit" })

keymap.set("n", "<Esc>", ":noh<CR>", { silent = true, desc = "Removes the searched term" })

-- Git
keymap.set("n", "<leader>ga", ":!git add .<CR>", {
  silent = true,
  desc = "Stage all the changes in the current project",
})
keymap.set("n", "<leader>gc", ":!git commit -m '<left>'", {
  silent = true,
  desc = "Commit the changes",
})
keymap.set("n", "<leader>gp", ":!git push<CR>", {
  silent = true,
  desc = "Push the changes to the remote repository",
})

keymap.set("n", "gw", "<cmd>set wrap!<CR>", {
  desc = "Toggle line wrap",
})

keymap.set("n", "<leader>bb", "<cmd>b#<CR>", {
  desc = "Switch to last buffer",
})

