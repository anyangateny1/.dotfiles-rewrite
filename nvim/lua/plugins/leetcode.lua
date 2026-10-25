return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  opts = {},
  config = function(_, opts)
    require("leetcode").setup(opts)

    vim.api.nvim_create_user_command("LeetCookieSync", function()
      local script = vim.fn.stdpath("config") .. "/scripts/sync_leetcode_cookie.py"
      local output = vim.fn.system({ "python3", script })
      if vim.v.shell_error ~= 0 then
        vim.notify(vim.trim(output), vim.log.levels.ERROR)
        return
      end

      vim.notify(vim.trim(output), vim.log.levels.INFO)
    end, { desc = "Sync LeetCode cookie from Firefox and refresh session" })
  end,
}
