-- Shows how to use the DAP plugin to debug your code.
--print("loading DAP debug.lua")
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",

    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Installs the debug adapters for you
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Add your own debuggers here
    {
      "mfussenegger/nvim-dap-python",
      ft = "python",
      dependencies = { "mfussenegger/nvim-dap" },
    },
  },
  keys = function(_, keys)
    local dap = require("dap")
    local dapui = require("dapui")

    --print("dap keys here")
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { "<leader>d", "", desc = "+DAP", mode = { "n", "v" } },
      { "<leader>db", dap.toggle_breakpoint, desc = "DAP: [b]reakpoint toggle" },

      { "<F5>", dap.continue, desc = "DAP: Start/Continue" },
      { "<F1>", dap.step_into, desc = "DAP: Step Into" },
      { "<F2>", dap.step_over, desc = "DAP: Step Over" },
      { "<F3>", dap.step_out, desc = "DAP: Step Out" },
      {
        "<leader>B",
        function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP: Set [B]reakpoint",
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { "<F7>", dapui.toggle, desc = "DAP: See last session result." },
      unpack(keys),
    }
  end,

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    --print("dap config here")
    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see son-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- "delve", -- for C++ and Rust
        "debugpy",
      },
    })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Install golang specific config
    -- require("dap-go").setup({
    --   delve = {
    --     -- On Windows delve must be run attached or it crashes.
    --     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --     detached = vim.fn.has("win32") == 0,
    --   },
    -- })
    -- Configure Delve for C++ debugging
    -- dap.adapters.delve = {
    --   type = "server",
    --   port = "${port}",
    --   executable = {
    --     command = "dlv",
    --     args = { "dap", "-l", "127.0.0.1:${port}" },
    --   },
    -- }
    -- dap.configurations.cpp = {
    --   {
    --     name = "Debug",
    --     type = "delve",
    --     request = "launch",
    --     program = function()
    --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    --     end,
    --     cwd = "${workspaceFolder}",
    --     stopOnEntry = true,
    --     args = {},
    --   },
    -- }
    --
    -- dap.configurations.rust = {
    --   {
    --     name = "Launch",
    --     type = "delve",
    --     request = "launch",
    --     program = function()
    --       local cwd = vim.fn.getcwd()
    --       local executable = vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
    --       if vim.fn.filereadable(executable) == 1 then
    --         return executable
    --       else
    --         error("Invalid executable path: " .. executable)
    --       end
    --     end,
    --     cwd = "${workspaceFolder}",
    --     stopOnEntry = false,
    --     args = {},
    --   },
    -- }
  end,
}
