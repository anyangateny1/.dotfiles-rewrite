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
        -- C/C++
        "clangd",
        -- Markdown
        "markdownlint-cli2",
      },
    },
  },
}
