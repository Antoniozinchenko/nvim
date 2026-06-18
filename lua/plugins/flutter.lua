return {
  -- Flutter tools
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    config = function()
      require("flutter-tools").setup({
        fvm = true,
        ui = {
          border = "rounded",
          notification_style = "plugin",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          register_configurations = function(_)
            local dap = require("dap")
            dap.set_log_level("TRACE")
            dap.configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
          end,
        },
        dev_log = { enabled = false },
        lsp = {
          -- Neovim 0.12+: use built-in document colors instead of plugin-managed ones
          on_attach = function(_, bufnr)
            pcall(vim.lsp.document_color.enable, true, bufnr)
          end,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            enableSdkFormatter = true,
          },
        },
      })

      -- Load flutter telescope extension
      pcall(function()
        require("telescope").load_extension("flutter")
      end)

      -- Flutter which-key mappings
      local keymap = vim.keymap.set
      keymap("n", "<leader>Fc", "<cmd>Telescope flutter commands<CR>", { desc = "Flutter commands" })
      keymap("n", "<leader>Fd", "<cmd>FlutterDevices<CR>", { desc = "Flutter devices" })
      keymap("n", "<leader>Fe", "<cmd>FlutterEmulators<CR>", { desc = "Flutter emulators" })
      keymap("n", "<leader>Fr", "<cmd>FlutterReload<CR>", { desc = "Hot reload" })
      keymap("n", "<leader>FR", "<cmd>FlutterRestart<CR>", { desc = "Hot restart" })
      keymap("n", "<leader>Fq", "<cmd>FlutterQuit<CR>", { desc = "Quit app" })
      keymap("n", "<leader>FL", "<cmd>FlutterIntlGenerate<CR>", { desc = "Intl generate" })
      keymap("n", "<leader>Fl", "<cmd>FlutterIntlDownload<CR>", { desc = "Intl download .arb" })
      keymap("n", "<leader>Fu", "<cmd>FlutterIntlUpload<CR>", { desc = "Intl upload .arb" })
      keymap("n", "<leader>Fv", "<cmd>Telescope flutter fvm<CR>", { desc = "Flutter version" })
    end,
  },

  -- Flutter intl
  {
    "Antoniozinchenko/flutter-intl",
    commit = "c482c157783da18623b99fe61114eed3d46ad86b",
    config = function()
      require("flutter-intl").setup()
    end,
  },

  -- DAP (needed by flutter-tools debugger)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").restart() end, desc = "Restart" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dx", function()
        local dap = require("dap")
        local filters = dap.defaults.fallback.exception_breakpoints
        if #filters == 0 then
          dap.defaults.fallback.exception_breakpoints = { "uncaught" }
          dap.set_exception_breakpoints({ "uncaught" })
          vim.notify("DAP: break on uncaught exceptions ON")
        else
          dap.defaults.fallback.exception_breakpoints = {}
          dap.set_exception_breakpoints({})
          vim.notify("DAP: break on uncaught exceptions OFF")
        end
      end, desc = "Toggle exception breakpoints" },
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug step out" },
    },
    config = function()
      local dapui = require("dapui")
      dapui.setup()

      -- Auto open/close DAP UI
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Ignore uncaught exceptions — only stop on breakpoints
      dap.defaults.fallback.exception_breakpoints = {}
    end,
  },
}
