return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local swap = require("nvim-treesitter-textobjects.swap")
    local move = require("nvim-treesitter-textobjects.move")

    -- Helper to DRY up select keymaps
    local function sel(lhs, query, desc)
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, "textobjects")
      end, { desc = desc })
    end

    -- Select: assignments
    sel("a=", "@assignment.outer", "Select outer assignment")
    sel("i=", "@assignment.inner", "Select inner assignment")
    sel("l=", "@assignment.lhs", "Select LHS of assignment")
    sel("r=", "@assignment.rhs", "Select RHS of assignment")

    -- Select: object properties
    sel("a:", "@property.outer", "Select outer object property")
    sel("i:", "@property.inner", "Select inner object property")
    sel("l:", "@property.lhs", "Select LHS of object property")
    sel("r:", "@property.rhs", "Select RHS of object property")

    -- Select: parameters
    sel("aa", "@parameter.outer", "Select outer parameter")
    sel("ia", "@parameter.inner", "Select inner parameter")

    -- Select: conditionals
    sel("ai", "@conditional.outer", "Select outer conditional")
    sel("ii", "@conditional.inner", "Select inner conditional")

    -- Select: loops
    sel("al", "@loop.outer", "Select outer loop")
    sel("il", "@loop.inner", "Select inner loop")

    -- Select: function calls
    sel("af", "@call.outer", "Select outer function call")
    sel("if", "@call.inner", "Select inner function call")

    -- Select: function/method definitions
    sel("am", "@function.outer", "Select outer function def")
    sel("im", "@function.inner", "Select inner function def")

    -- Select: classes
    sel("ac", "@class.outer", "Select outer class")
    sel("ic", "@class.inner", "Select inner class")

    -- Select: blocks
    sel("aB", "@block.outer", "Select outer code block")
    sel("iB", "@block.inner", "Select inner code block")

    -- Swap next
    vim.keymap.set("n", "<leader>na", function() swap.swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
    vim.keymap.set("n", "<leader>n:", function() swap.swap_next("@property.outer") end, { desc = "Swap next property" })
    vim.keymap.set("n", "<leader>nm", function() swap.swap_next("@function.outer") end, { desc = "Swap next function" })

    -- Swap previous
    vim.keymap.set("n", "<leader>pa", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap prev parameter" })
    vim.keymap.set("n", "<leader>p:", function() swap.swap_previous("@property.outer") end, { desc = "Swap prev property" })
    vim.keymap.set("n", "<leader>pm", function() swap.swap_previous("@function.outer") end, { desc = "Swap prev function" })

    -- Move: goto next start
    local function move_map(lhs, fn, query, desc, query_group)
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        fn(query, query_group or "textobjects")
      end, { desc = desc })
    end

    move_map("]f", move.goto_next_start, "@call.outer", "Next function call start")
    move_map("]m", move.goto_next_start, "@function.outer", "Next function def start")
    move_map("]c", move.goto_next_start, "@class.outer", "Next class start")
    move_map("]i", move.goto_next_start, "@conditional.outer", "Next conditional start")
    move_map("]l", move.goto_next_start, "@loop.outer", "Next loop start")
    move_map("]s", move.goto_next_start, "@scope", "Next scope", "locals")
    move_map("]z", move.goto_next_start, "@fold", "Next fold", "folds")

    -- Move: goto next end
    move_map("]F", move.goto_next_end, "@call.outer", "Next function call end")
    move_map("]M", move.goto_next_end, "@function.outer", "Next function def end")
    move_map("]C", move.goto_next_end, "@class.outer", "Next class end")
    move_map("]I", move.goto_next_end, "@conditional.outer", "Next conditional end")
    move_map("]L", move.goto_next_end, "@loop.outer", "Next loop end")

    -- Move: goto previous start
    move_map("[f", move.goto_previous_start, "@call.outer", "Prev function call start")
    move_map("[m", move.goto_previous_start, "@function.outer", "Prev function def start")
    move_map("[c", move.goto_previous_start, "@class.outer", "Prev class start")
    move_map("[i", move.goto_previous_start, "@conditional.outer", "Prev conditional start")
    move_map("[l", move.goto_previous_start, "@loop.outer", "Prev loop start")

    -- Move: goto previous end
    move_map("[F", move.goto_previous_end, "@call.outer", "Prev function call end")
    move_map("[M", move.goto_previous_end, "@function.outer", "Prev function def end")
    move_map("[C", move.goto_previous_end, "@class.outer", "Prev class end")
    move_map("[I", move.goto_previous_end, "@conditional.outer", "Prev conditional end")
    move_map("[L", move.goto_previous_end, "@loop.outer", "Prev loop end")

    -- Repeatable move (;/, for last treesitter motion)
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- Make built-in f/F/t/T repeatable with ;/,
    -- In the main branch these were renamed to builtin_*_expr (expression mappings)
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
