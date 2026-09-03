local style_files = { ".clang-format", "_clang-format", "clang-format.yaml" }

local function find_clang_style(path)
  return vim.fs.find(style_files, { path = path, upward = true })[1]
    or (vim.fn.filereadable(vim.fs.normalize("~/.clang-format")) == 1 and vim.fs.normalize("~/.clang-format") or nil)
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },

  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "never" })
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },

      c = { "clang-format" },
      cpp = { "clang-format" },

      sh = { "shfmt" },

      markdown = { "prettierd" },

      python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
    },
    formatters = {
      prettierd = {
        env = { PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/.prettierrc.json" },
      },
      ["clang-format"] = {
        cwd = function(_, ctx)
          local f = find_clang_style(ctx.filename)
          return f and vim.fs.dirname(f) or nil
        end,
        prepend_args = function(_, ctx)
          local f = find_clang_style(ctx.filename)
          return f and { "-style=file:" .. f } or {}
        end,
      },
    },
    -- Format on save can be disabled
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "never" }
    end,
  },

  vim.api.nvim_create_user_command("ClangFormatWhich", function()
    local ft = vim.bo.filetype
    if ft ~= "c" and ft ~= "cpp" then
      vim.notify("ClangFormatWhich: not a C/C++ buffer (ft=" .. ft .. ")", vim.log.levels.INFO)
      return
    end
    local f = find_clang_style(vim.api.nvim_buf_get_name(0))
    vim.notify(
      f and ("clang-format will use: " .. f) or "clang-format: no style file found",
      f and vim.log.levels.INFO or vim.log.levels.WARN
    )
  end, { desc = "Show which clang-format config is used" }),

  vim.keymap.set("n", "<leader>cf", function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      vim.notify("Autoformat: OFF", vim.log.levels.WARN)
    else
      vim.notify("Autoformat: ON", vim.log.levels.INFO)
    end
  end, {
    desc = "Toggle autoformat-on-save",
  }),
}
