return {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    typescript = {
      diagnostics = {
        ignoredCodes = { 6133, 6192 },
      },
    },
    javascript = {
      diagnostics = {
        ignoredCodes = { 6133, 6192 },
      },
    },
  },
}
