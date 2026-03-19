-- Hook ts-context-commentstring into Neovim's native gc/gcc (replaces Comment.nvim)
return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    enable_autocmd = false,
  },
  init = function()
    -- Skip the deprecated module check
    vim.g.skip_ts_context_commentstring_module = true
  end,
  config = function(_, opts)
    require("ts_context_commentstring").setup(opts)
    -- Integrate with native Neovim commenting (gc/gcc)
    local get_option = vim.filetype.get_option
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.filetype.get_option = function(filetype, option)
      return option == "commentstring"
          and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
    end
  end,
}
