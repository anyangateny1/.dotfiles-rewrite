return {
  "lewis6991/gitsigns.nvim",

  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    -- Update faster
    current_line_blame_opts = {
      delay = 100,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> | <summary>",

    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          desc = desc,
          silent = true,
        })
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end

        vim.schedule(function()
          gs.nav_hunk("next", { wrap = false }) ---@diagnostic disable-line: missing-fields
        end)

        return "<Ignore>"
      end, "Next Git Hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end

        vim.schedule(function()
          gs.nav_hunk("prev", { wrap = false }) ---@diagnostic disable-line: missing-fields
        end)
        return "<Ignore>"
      end, "Previous Git Hunk")

      -- Hunk actions
      map({ "n", "v" }, "<leader>hs", gs.stage_hunk, "Stage Hunk")
      map({ "n", "v" }, "<leader>hr", gs.reset_hunk, "Reset Hunk")
      map("n", "<leader>hu", gs.stage_hunk, "Undo Stage Hunk")

      -- Buffer actions
      map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")

      -- Other actions
      map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>tD", gs.preview_hunk_inline, "Toggle Preview hunk")

      map("n", "<leader>hd", gs.diffthis, "Split window diff")

      map("n", "<leader>hb", gs.blame_line, "Blame Line")
      map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle Line Blame")
    end,
  },
}
