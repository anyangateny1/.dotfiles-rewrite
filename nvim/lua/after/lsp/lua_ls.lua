return {
  settings = {
    Lua = {
      runtime = {
        -- tell the server you're using LuaJIT (bundled with Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        -- inline type/parameter hints (Neovim 0.10+ shows these natively)
        enable = true,
      },
    },
  },
}
