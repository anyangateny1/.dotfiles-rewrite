vim.api.nvim_set_hl(0, "@keyword.operator.cpp", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@lsp.type.operator.cpp", { link = "@keyword" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or client.name ~= "clangd" then
      return
    end

    vim.keymap.set("n", "<leader>ch", function()
      client:request("textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(event.buf) }, function(err, result)
        if err then
          vim.notify("clangd: " .. (err.message or tostring(err)), vim.log.levels.WARN)
          return
        end
        if not result or result == "" then
          vim.notify("No corresponding source/header found", vim.log.levels.INFO)
          return
        end
        vim.cmd("edit " .. vim.uri_to_fname(result))
      end)
    end, { buffer = event.buf, desc = "[C]langd Switch [H]eader/Source" })
  end,
})

return {
  cmd = {
    "clangd",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--query-driver=/usr/bin/g++*,/usr/bin/gcc*,/usr/bin/clang*",
  },
}
