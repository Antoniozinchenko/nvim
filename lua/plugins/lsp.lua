return {
  -- Mason: LSP server manager
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "jsonls",
          "ts_ls",
        },
      })
    end,
  },

  -- LSP config (Neovim 0.12+ native vim.lsp.config API)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_lsp.default_capabilities()

      -- LSP attach keybindings (LunarVim style: <leader>l*)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local buf = ev.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
          end

          -- LunarVim-style LSP keybindings
          map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>lr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>ld", function() vim.diagnostic.open_float() end, "Line diagnostics")
          map("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          map("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", "Document symbols")
          map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", "Workspace symbols")
          map("n", "<leader>lR", "<cmd>Telescope lsp_references<CR>", "References")
          map("n", "<leader>lD", vim.lsp.buf.declaration, "Declaration")
          map("n", "<leader>lt", vim.lsp.buf.type_definition, "Type definition")

          -- Standard LSP keymaps
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", "<cmd>Telescope lsp_references<CR>", "References")
          map("n", "gi", vim.lsp.buf.implementation, "Implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover docs")
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        end,
      })

      -- Diagnostics appearance
      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Server configs using vim.lsp.config (Neovim 0.12+)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("jsonls", { capabilities = capabilities })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })

      vim.lsp.enable({ "lua_ls", "jsonls", "ts_ls" })
    end,
  },

  -- Formatting (replaces null-ls formatters)
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescript = { "eslint_d" },
          typescriptreact = { "eslint_d" },
        },
        format_on_save = false,
      })

      -- Override <leader>lf to use conform
      vim.keymap.set("n", "<leader>lf", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format (conform)" })
    end,
  },

  -- Linting (replaces null-ls linters)
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- LspSaga
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("lspsaga").setup({
        move_in_saga = { prev = "<C-k>", next = "<C-j>" },
        finder = {
          silent = true,
          default = "def+ref+imp",
          layout = "float",
          keys = {
            shuttle = "[]",
            toggle_or_open = "<CR>",
            jump_to = "e",
            vsplit = "v",
            split = "s",
            tabe = "t",
            tabnew = "n",
            quit = "q",
            close = "<Esc>",
          },
        },
        definition = { edit = "<CR>" },
      })

      local keymap = vim.keymap.set
      keymap("n", "gh", "<cmd>Lspsaga finder<CR>", { desc = "LSP finder", silent = true })
      keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition", silent = true })
      keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition", silent = true })
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover doc", silent = true })
      keymap("n", "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { desc = "Float terminal", silent = true })
      keymap("n", "∂", "<cmd>Lspsaga term_toggle<CR>", { silent = true }) -- macOS Option+d
    end,
  },
}
