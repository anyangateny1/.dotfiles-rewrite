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
        -- Web / JS / TS
        "biome",
        "typescript-language-server",
        "prettierd",
        "json-lsp",
        -- Shell
        "bash-language-server",
        "bash-debug-adapter",
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
        "clang-format",
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
