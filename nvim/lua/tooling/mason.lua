return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- General
        "prettier",
        -- Shell
        "bash-language-server",
        "shellcheck",
        "shfmt",
        -- Lua
        "lua-language-server",
        "stylua",
        -- Go
        "gopls",
        "golangci-lint",
        "delve",
        -- C/C++
        "clangd",
        "codelldb",
        -- Python
        "pyright",
        "ruff",
        "debugpy",
        -- Markdown
        "markdownlint-cli2",
      },
    },
  },
}
