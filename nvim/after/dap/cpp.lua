-- {
--   "version": "0.2.0",
--   "configurations": [
--     {
--       "name": "C/C++: Launch",
--       "type": "codelldb",
--       "request": "launch",
--       "program": "${workspaceFolder}/build/your_binary",
--       "cwd": "${workspaceFolder}",
--       "args": [],
--       "stopOnEntry": false
--     }
--   ]
-- }
local dap = require("dap")

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.cpp = {
  {
    name = "Launch executable",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/build/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp
