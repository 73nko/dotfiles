-- blink.cmp: Rust-powered completion (replaces nvim-cmp + 5 dependencies)
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets", -- vscode-style snippets
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "none",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
      ["<CR>"] = { "accept", "fallback" },
      -- Tab: accept blink si visible; si no, accept NeoCodeium si hay ghost text;
      -- si no, snippet forward; si no, Tab normal.
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.accept()
          end
        end,
        function()
          local ok, neocodeium = pcall(require, "neocodeium")
          if ok and neocodeium.visible() then
            neocodeium.accept()
            return true
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },
    completion = {
      -- auto_brackets OFF: nvim-autopairs es el unico dueño de los brackets.
      -- Con ambos activos, aceptar una funcion del menu podia producir (().
      accept = { auto_brackets = { enabled = false } },
      list = { selection = { preselect = false, auto_insert = false } },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    snippets = { preset = "default" },
    signature = { enabled = true },
  },
}
