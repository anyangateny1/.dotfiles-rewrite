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
        "prettierd",
        "json-lsp",
        -- Shell
        "bash-language-server",
        "shellcheck",
        "shfmt",
        -- Lua
        "lua-language-server",
        "stylua",
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
