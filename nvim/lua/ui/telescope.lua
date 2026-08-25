return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  keys = {
    {
      "<leader>sf",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "[S]earch [F]iles",
    },
    {
      "<leader>sg",
      function()
        require("telescope.builtin").live_grep(require("telescope.themes").get_ivy())
      end,
      desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sn",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[S]earch [N]eovim files",
    },
    {
      "<leader>sd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "[S]earch [D]iagnostics",
    },
  },
  opts = {
    defaults = { file_ignore_patterns = {} },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
  end,
}
