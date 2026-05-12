return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
      "Antoniozinchenko/neotest-dart",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dart")({
            command = "fvm flutter",
            use_lsp = true,
            custom_test_method_names = { "testGoldens" },
          }),
          require("neotest-jest")({
            jestCommand = "yarn test --",
          }),
        },
      })

      local keymap = vim.keymap.set
      keymap("n", "<leader>Tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
      keymap("n", "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
      keymap("n", "<leader>To", function() require("neotest").summary.toggle() end, { desc = "Toggle summary" })
      keymap("n", "<leader>Tg", function() require("neotest").run.run({ extra_args = "--update-goldens" }) end, { desc = "Update goldens" })
    end,
  },
  { "Antoniozinchenko/neotest-dart" },
  { "haydenmeade/neotest-jest" },
}
