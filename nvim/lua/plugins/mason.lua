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
        -- Shell
        "bash-language-server",
        "shellcheck",
        "shfmt",
        -- Lua
        "lua-language-server",
        "stylua",
      },
    },
  },
}
