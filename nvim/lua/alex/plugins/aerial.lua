return {
	-- see the aerial view of the code
	"stevearc/aerial.nvim",
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup({
			attach_mode = "global",
			backends = { "lsp", "treesitter", "markdown", "man" },
			show_guides = true,
			layout = {
				resize_to_content = true,
				win_opts = {
					winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
					signcolumn = "yes",
					statuscolumn = " ",
				},
				min_width = 20,
				max_width = { 50, 0.3 },
			},
			guides = {
				mid_item = "├╴",
				last_item = "└╴",
				nested_top = "│ ",
				whitespace = "  ",
			},
			icons = {
				Array = " ",
				Boolean = "󰨙 ",
				Class = " ",
				Color = " ",
				Control = " ",
				Collapsed = " ",
				Constant = "󰏿 ",
				Constructor = " ",
				Copilot = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Folder = " ",
				Function = "󰊕 ",
				Interface = " ",
				Key = " ",
				Keyword = " ",
				Method = "󰊕 ",
				Module = " ",
				Namespace = "󰦮 ",
				Null = " ",
				Number = "󰎠 ",
				Object = " ",
				Operator = " ",
				Package = " ",
				Property = " ",
				Reference = " ",
				Snippet = " ",
				String = " ",
				Struct = "󰆼 ",
				Text = " ",
				TypeParameter = " ",
				Unit = " ",
				Value = " ",
				Variable = "󰀫 ",
			},
			on_attach = function(bufnr)
				-- Use [a/]a instead of {/} to preserve vim's paragraph navigation
				vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial prev symbol" })
				vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial next symbol" })
				vim.keymap.set("n", "<leader>co", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial code outline" })
			end,
		})
	end,
}
