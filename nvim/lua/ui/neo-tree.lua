return {
  "nvim-neo-tree/neo-tree.nvim",

  branch = "v3.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  cmd = "Neotree",

  -- Open Neo-tree automatically when entering a directory
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
      callback = function()
        local f = vim.fn.expand("%:p")

        if vim.fn.isdirectory(f) == 1 then
          vim.cmd("Neotree current dir=" .. vim.fn.fnameescape(f))
          return true
        end
      end,
    })
  end,

  keys = {
    {
      "<leader>e",
      "<cmd>Neotree toggle position=left<cr>",
      desc = "Toggle Neo-tree",
    },
    {
      "\\",
      "<cmd>Neotree reveal position=left<cr>",
      desc = "Reveal in Neo-tree",
    },
    {
      "<leader>ne",
      "<cmd>Neotree focus position=left<cr>",
      desc = "Focus Neo-tree",
    },
  },

  opts = {
    close_if_last_window = true,

    default_component_configs = {
      git_status = {
        symbols = {
          modified = "M",
          unstaged = "○",
        },
      },
    },

    filesystem = {
      window = {
        position = "current",
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      filtered_items = {
        hide_by_name = {},
        always_show = {
          ".gitignore",
        },
        never_show = {},
      },
    },
  },
}
