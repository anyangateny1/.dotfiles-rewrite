return {
  "mfussenegger/nvim-lint",

  config = function()
    local lint = require("lint")

    lint.linters.shellcheck.args = {
      "--format",
      "json1",
      "--shell=bash",
      "--severity=warning",
      "-",
    }
  end,
}
