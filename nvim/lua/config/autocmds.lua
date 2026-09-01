-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Trim trailing whitespace before save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("trim-whitespace", { clear = true }),
  callback = function()
    local pos = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", pos)
  end,
})

-- Spell only in prose-like buffers (toggle anytime with <leader>ts)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("spell-prose", { clear = true }),
  pattern = { "markdown", "text", "gitcommit", "gitrebase" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
