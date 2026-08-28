return {
  "nvim-mini/mini.statusline",
  version = false,
  opts = {
    section_location = function()
      return string.format("%d:%d", vim.fn.line("."), vim.fn.col("."))
    end,
  },
}
