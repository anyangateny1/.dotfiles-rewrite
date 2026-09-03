return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },

  config = function()
    local lint = require("lint")

    lint.linters["markdownlint-cli2"].args = {
      "--config",
      vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml",
      "-",
    }

    lint.linters_by_ft = {
      sh = { "shellcheck" },
      bash = { "shellcheck" },

      markdown = { "markdownlint-cli2" },

      python = { "ruff" },
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
