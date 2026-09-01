return {
  "saghen/blink.cmp",

  dependencies = {
    "saghen/blink.lib",
    "rafamadriz/friendly-snippets",
  },

  build = function()
    require("blink.cmp").build():pwait()
  end,

  opts = {
    keymap = { preset = "default" },
    completion = { documentation = { auto_show = false } },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "rust" },
    signature = {
      enabled = true,
      window = {
        show_documentation = true,
      },
    },
  },
}
