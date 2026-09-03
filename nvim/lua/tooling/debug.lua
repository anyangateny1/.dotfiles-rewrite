return {
  "mfussenegger/nvim-dap",

  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",

    "mfussenegger/nvim-dap-python",
    "theHamsta/nvim-dap-virtual-text",
  },

  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F1>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F3>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>b",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>B",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Conditional Breakpoint",
    },
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },
    {
      "<leader>dq",
      function()
        local dap = require("dap")
        local dapui = require("dapui")

        dap.disconnect({ terminateDebuggee = true })
        dap.close()
        dapui.close()
      end,
      desc = "Debug: Quit",
    },
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Auto-load per-adapter configs from after/dap/*.lua
    local dap_dir = vim.fn.stdpath("config") .. "/after/dap"
    for name, ftype in vim.fs.dir(dap_dir) do
      if ftype == "file" and name:match("%.lua$") then
        dofile(dap_dir .. "/" .. name)
      end
    end

    require("nvim-dap-virtual-text").setup({
      commented = true,
    })
  end,
}
