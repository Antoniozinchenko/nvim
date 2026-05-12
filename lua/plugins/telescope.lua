return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      })

      telescope.load_extension("fzf")

      -- LunarVim-style telescope keymaps
      local builtin = require("telescope.builtin")
      local keymap = vim.keymap.set
      keymap("n", "<leader>f", builtin.find_files, { desc = "Find files" })
      keymap("n", "<leader>st", builtin.live_grep, { desc = "Search text" })
      keymap("n", "<leader>sb", builtin.buffers, { desc = "Search buffers" })
      keymap("n", "<leader>sh", builtin.help_tags, { desc = "Search help" })
      keymap("n", "<leader>sr", builtin.oldfiles, { desc = "Recent files" })
      keymap("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
      keymap("n", "<leader>sd", builtin.diagnostics, { desc = "Search diagnostics" })
      keymap("n", "<leader>sc", builtin.commands, { desc = "Search commands" })
      keymap("n", "<leader>sg", builtin.git_status, { desc = "Git changed files" })
      keymap("n", "<leader>sG", builtin.git_commits, { desc = "Git commits" })
    end,
  },
}
