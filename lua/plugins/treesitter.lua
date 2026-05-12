return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Neovim 0.12+: treesitter highlight/indent are built-in.
      -- The plugin is used only for parser installation.
      local parsers = {
        "bash", "c", "cpp", "javascript", "json", "lua",
        "typescript", "tsx", "css", "yaml", "dart", "ruby",
        "markdown", "python", "markdown_inline", "vim", "vimdoc",
      }

      -- Install missing parsers
      local ts_install = require("nvim-treesitter.install")
      for _, lang in ipairs(parsers) do
        if not pcall(vim.treesitter.language.inspect, lang) then
          ts_install.install(lang)
        end
      end

      -- Enable built-in treesitter highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
