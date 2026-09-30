local dap = require("dap")
local bash_debug_dir = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter"

dap.adapters.bashdb = {
  type = "executable",
  command = bash_debug_dir .. "/bash-debug-adapter",
  name = "bashdb",
}

dap.configurations.sh = {
  {
    type = "bashdb",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    pathBash = "/bin/bash",
    pathBashdb = bash_debug_dir .. "/extension/bashdb_dir/bashdb",
    pathBashdbLib = bash_debug_dir .. "/extension/bashdb_dir",
    pathCat = "cat",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    args = {},
    env = {},
    terminalKind = "integrated",
  },
}
