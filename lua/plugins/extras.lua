return {
  -- Trouble v3 (diagnostics list)
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = function()
      require("trouble").setup()

      local keymap = vim.keymap.set
      keymap("n", "<leader>tr", "<cmd>Trouble lsp_references toggle<CR>", { desc = "References" })
      keymap("n", "<leader>tf", "<cmd>Trouble lsp_definitions toggle<CR>", { desc = "Definitions" })
      keymap("n", "<leader>td", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
      keymap("n", "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", { desc = "Quickfix" })
      keymap("n", "<leader>tl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list" })
      keymap("n", "<leader>tw", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
      keymap("n", "<leader>tt", "<cmd>TodoTelescope<CR>", { desc = "TODO list" })
    end,
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- Copilot
  { "github/copilot.vim" },

  -- Venn (draw diagrams)
  { "jbyuki/venn.nvim", cmd = "VBox" },

  -- MDX syntax
  { "jxnblk/vim-mdx-js" },

  -- Image preview
  {
    "adelarsq/image_preview.nvim",
    event = "VeryLazy",
    config = function()
      require("image_preview").setup()
    end,
  },
}
