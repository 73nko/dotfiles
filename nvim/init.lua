-- Desactiva netrw antes de cualquier plugin (Snacks explorer es el file tree oficial).
-- Evita que :e some_dir/ o :Ex abra buffers con filetype=netrw, que rompen
-- :DapContinue, conform, null-ls, y otros plugins que hacen lookup por filetype.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("alex.core")
require("alex.lazy")
