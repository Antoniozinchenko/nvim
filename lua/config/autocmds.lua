-- Enable wrap mode for json files
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc", "*.arb" },
  command = "setlocal wrap",
})

-- Flutter .arb files should be treated as json
vim.filetype.add({
  extension = {
    arb = "json",
  },
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save (skip non-modifiable buffers)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.bo.modifiable then return end
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, cursor)
  end,
})

-- Auto-close terminal buffer on exit
vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    vim.cmd("bdelete!")
  end,
})
