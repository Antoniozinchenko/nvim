return {
  -- Bufferline (tab-style buffer bar)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          diagnostics = "nvim_lsp",
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
          },
          separator_style = "thin",
        },
      })
    end,
  },

  -- Lualine (status line)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_c = {
            { "filename", path = 1 },
            {
              function()
                if vim.inspect(vim.b.venn_enabled) == "true" then
                  return "Diagram mode"
                end
                return ""
              end,
            },
          },
        },
      })
    end,
  },

  -- NvimTree (file explorer)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local api = require("nvim-tree.api")

      local function on_attach(bufnr)
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close directory"))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        view = { side = "left", width = 30 },
        renderer = {
          icons = { show = { git = true } },
        },
        filters = { dotfiles = false },
        git = { enable = true },
        update_focused_file = {
          enable = true,
          update_root = false,
        },
      })
    end,
  },

  -- Which-key (keybinding hints)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = { spelling = { enabled = true } },
      })
      wk.add({
        { "<leader>l", group = "LSP" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Trouble" },
        { "<leader>T", group = "Tests" },
        { "<leader>F", group = "Flutter" },
        { "<leader>d", group = "Debug" },
        { "<leader>b", group = "Buffers" },
        { "<leader>bs", group = "Sort" },
        { "<leader>g", group = "Git" },
      })
    end,
  },

  -- Alpha (dashboard)
  {
    "goolord/alpha-nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },

  -- Dressing (better UI for inputs/selects)
  { "stevearc/dressing.nvim", event = "VeryLazy" },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Neovim 0.12 has built-in gc/gcc commenting via vim.keymap defaults

  -- Git signs (config in git.lua)

  -- Indent blank line
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },
}
