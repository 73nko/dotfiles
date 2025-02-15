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

-- Move th line up and down
keymap.set("n", "<A-<>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move the line down" })
keymap.set("n", "<A->>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move the line up" })

-- search and replace
keymap.set("n", "<leader>sr", function()
  local search = vim.fn.input("Search: ")
  local replace = vim.fn.input("Replace with: ")
  vim.cmd(string.format("%%s/%s/%s/gc", search, replace))
end, { desc = "Search and replace" }) -- search and replac text

keymap.set("n", "<C-d>", "yyp", { noremap = true, silent = true })
keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true }) -- save the current buffer
keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true }) -- save the current buffer
keymap.set(
  "v",
  "<leader>/",
  [[y/\V<C-R>=escape(@",'/\')<CR><CR>]],
  { noremap = true, silent = true, desc = "Search the selected word inside the buffer" }
)

keymap.set("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true, desc = "Removes the searched term" })
