return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction" },
  keys = {
    { "<leader>jr", "<cmd>OverseerRun<cr>", desc = "Jobs: Run task" },
    { "<leader>jt", "<cmd>OverseerToggle<cr>", desc = "Jobs: Toggle task list" },
    { "<leader>ja", "<cmd>OverseerQuickAction<cr>", desc = "Jobs: Task action" },
  },
  opts = {},
}
