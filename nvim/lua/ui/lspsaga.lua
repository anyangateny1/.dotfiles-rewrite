return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lspsaga").setup({
      code_action = {
        extend_gitsigns = false,
      },
      definition = {
        keys = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>i",
          tabe = "<C-c>t",
        },
      },
      rename = {
        keys = {
          quit = "<C-c>",
          select = "x",
        },
      },
      finder = {
        keys = {
          vsplit = "s",
          split = "i",
          tabe = "t",
          quit = { "q", "<ESC>" },
        },
      },
    })

    local keymap = vim.keymap.set

    keymap("n", "gh", "<cmd>Lspsaga finder<CR>", { desc = "LSP: Find symbol (def/ref/impl)" })
    keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP: Code actions" })
    keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "LSP: Rename symbol" })

    keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "LSP: Goto definition" })
    keymap("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Goto declaration (no Saga equivalent)" })
    keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { desc = "LSP: Peek definition" })
    keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "LSP: Peek type definition" })
    keymap("n", "gT", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "LSP: Goto type definition" })

    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "LSP: Hover documentation" })
    keymap("n", "<leader>K", "<cmd>Lspsaga hover_doc ++keep<CR>", { desc = "LSP: Pin hover documentation" })

    keymap("n", "gr", "<cmd>Lspsaga finder ref<CR>", { desc = "LSP: References" })
    keymap("n", "gI", "<cmd>Lspsaga finder imp<CR>", { desc = "LSP: Implementations" })

    keymap("n", "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "LSP: Show line diagnostics" })

    keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "LSP: Previous diagnostic" })
    keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "LSP: Next diagnostic" })
    keymap("n", "[E", function()
      require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, { desc = "LSP: Previous error" })
    keymap("n", "]E", function()
      require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, { desc = "LSP: Next error" })

    keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { desc = "LSP: Incoming calls" })
    keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "LSP: Outgoing calls" })

    keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "LSP: Toggle outline" })

    keymap({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { desc = "Toggle floating terminal" })
  end,
}
