return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      pattern = [[.*<((KEYWORDS)%(\s*\([^)]*\))?\s*:]],
    },
    search = { pattern = [[\b(KEYWORDS)(\s*\([^)]*\))?\s*:]] },
  },
}
