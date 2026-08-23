-- ui/gitsigns.lua
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
          gs.nav_hunk("next")
        end)

        return "<Ignore>"
      end, "Next Git Hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end

        vim.schedule(function()
          gs.nav_hunk("prev")
        end)
        return "<Ignore>"
      end, "Previous Git Hunk")

      -- Hunk actions
      map({ "n", "v" }, "<leader>hs", gs.stage_hunk, "Stage Hunk")
      map({ "n", "v" }, "<leader>hr", gs.reset_hunk, "Reset Hunk")

      -- Buffer actions
      map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")

      -- Other actions
      map("n", "<leader>hu", gs.stage_hunk(), "Undo Stage Hunk")
      map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>hb", gs.blame_line, "Blame Line")
    end,
  },
}
