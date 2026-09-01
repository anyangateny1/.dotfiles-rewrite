local dap = require("dap")
local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"

require("dap-python").setup(mason_packages .. "/debugpy/venv/bin/python")

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    -- Prefer a local venv when available.
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
      elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        return cwd .. "/.venv/bin/python"
      else
        return "/usr/bin/python3"
      end
    end,
  },
}
