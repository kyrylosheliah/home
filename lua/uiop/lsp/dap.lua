return {

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
    },

    -- stylua: ignore
    keys = {
      { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      --{ "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

    config = function(_, opts)

      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      local mason_nvim_dap = require("mason-nvim-dap")
      if mason_nvim_dap ~= nil then
        mason_nvim_dap.setup()
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
      -- Extends dap.configurations with entries read from .vscode/launch.json
      if vim.fn.filereadable(".vscode/launch.json") then
        vscode.load_launchjs()
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason.nvim",
      "mfussenegger/nvim-dap",
    },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
    },
  },

}
--[[

-- vim.keymap.set("n", "<F1>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<leader>uc", ":lua require'dap'.continue()<CR>")

-- vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<leader>ui", ":lua require'dap'.step_into()<CR>")

-- vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>uo", ":lua require'dap'.step_over()<CR>")

-- vim.keymap.set("n", "<F4>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>uO", ":lua require'dap'.step_out()<CR>")

vim.keymap.set("n", "<leader>ub", ":lua require'dap'.toggle_breakpoint()<CR>")
-- vim.keymap.set("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<CR>")

-- vim.keymap.set("n", "<A-F9>", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>uB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")

-- -- vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")

vim.keymap.set("n", "<leader>ur", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>uR", ":lua require'dap'.run_last()<CR>")

-- -- vim.keymap.set("n", "<leader>ut", ":lua require'dap-go'.debug_test()<CR>")
--]]
