return {
  -- Gitsigns (inline blame, hunk actions — already loaded in editor.lua, keymaps added here)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gs = require("gitsigns")
      gs.setup({
        current_line_blame = true,
        current_line_blame_opts = { delay = 300 },
        on_attach = function(bufnr)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "]g", function() gs.nav_hunk("next") end, "Next git hunk")
          map("n", "[g", function() gs.nav_hunk("prev") end, "Prev git hunk")
        end,
      })

      -- Global keymaps (work with which-key immediately)
      local keymap = vim.keymap.set
      keymap("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
      keymap("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
      keymap("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      keymap("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
      keymap("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
      keymap("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
      keymap("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
      keymap("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
      keymap("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff this (~)" })
    end,
  },

  -- Fugitive (git commands :Git, :Gvdiffsplit, etc.)
  { "tpope/vim-fugitive" },

  -- Diffview (side-by-side diff, file history)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>go", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Branch history" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })
    end,
  },
}
