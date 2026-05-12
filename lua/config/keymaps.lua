local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

----------------------------------------------------------------------
-- General
----------------------------------------------------------------------
-- Escape insert mode with jk
keymap("i", "jk", "<ESC>", opts)

-- Save / Quit
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
keymap("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })

-- Delete single character without copying into register
keymap("n", "x", '"_x', opts)

----------------------------------------------------------------------
-- Splits
----------------------------------------------------------------------
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
keymap("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>-", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Navigate between splits
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize splits (Alt+arrows, with macOS Option key equivalents)
keymap("n", "<A-Up>", "<cmd>resize +2<CR>", opts)
keymap("n", "<A-Down>", "<cmd>resize -2<CR>", opts)
keymap("n", "<A-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<A-Right>", "<cmd>vertical resize +2<CR>", opts)

----------------------------------------------------------------------
-- Scrolling (center cursor)
----------------------------------------------------------------------
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

----------------------------------------------------------------------
-- Buffer navigation / close (LunarVim style)
----------------------------------------------------------------------
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>c", "<cmd>bdelete<CR>", { desc = "Close buffer" })
keymap("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bb", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bc", "<cmd>bdelete<CR>", { desc = "Close buffer" })
keymap("n", "<leader>bC", "<cmd>%bdelete|edit#|bdelete#<CR>", { desc = "Close other buffers" })
keymap("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })
keymap("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
keymap("n", "<leader>b1", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1" })
keymap("n", "<leader>b2", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2" })
keymap("n", "<leader>b3", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3" })
keymap("n", "<leader>b4", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4" })
keymap("n", "<leader>b5", "<cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to buffer 5" })
keymap("n", "<leader>bP", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" })
keymap("n", "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", { desc = "Sort by extension" })
keymap("n", "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", { desc = "Sort by directory" })
keymap("n", "<leader>bj", "<cmd>BufferLinePick<CR>", { desc = "Jump to buffer" })

----------------------------------------------------------------------
-- Terminal
----------------------------------------------------------------------
keymap("n", "<leader>Lt", "<cmd>15 split<CR><cmd>terminal<CR>", { desc = "Open terminal" })
keymap("t", "<Esc>", "<C-\\><C-n>", opts) -- exit terminal mode

----------------------------------------------------------------------
-- File explorer
----------------------------------------------------------------------
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "File explorer" })

----------------------------------------------------------------------
-- Comment toggle (Neovim 0.10+ built-in gc)
----------------------------------------------------------------------
keymap("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
keymap("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

----------------------------------------------------------------------
-- Copy file path to clipboard
----------------------------------------------------------------------
keymap("n", "<leader>y", function()
  local filepath = vim.fn.expand("%")
  vim.fn.setreg("+", filepath)
  vim.notify("Copied: " .. filepath)
end, { desc = "Copy file path" })

----------------------------------------------------------------------
-- Move lines in visual mode
----------------------------------------------------------------------
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

----------------------------------------------------------------------
-- LSP keybindings (LunarVim style: <leader>l*)
-- These are set here as fallbacks; LSP-attached keymaps are in lsp.lua
----------------------------------------------------------------------
keymap("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "LSP info" })

----------------------------------------------------------------------
-- Switch case (camelCase <-> snake_case)
----------------------------------------------------------------------
local function switch_case()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local word = vim.fn.expand("<cword>")
  local word_start = vim.fn.matchstrpos(vim.fn.getline("."), "\\k*\\%" .. (col + 1) .. "c\\k*")[2]

  if word:find("[a-z][A-Z]") then
    -- camelCase -> snake_case
    local snake = word:gsub("([a-z])([A-Z])", "%1_%2"):lower()
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake })
  elseif word:find("_[a-z]") then
    -- snake_case -> camelCase
    local camel = word:gsub("(_)([a-z])", function(_, l) return l:upper() end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel })
  else
    vim.notify("Not a snake_case or camelCase word", vim.log.levels.WARN)
  end
end

keymap("n", "<leader>S", switch_case, { desc = "Switch case (camel/snake)" })

----------------------------------------------------------------------
-- Venn diagram mode
----------------------------------------------------------------------
function _G.Toggle_venn()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
    vim.b.venn_enabled = true
    vim.cmd("setlocal ve=all")
    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
  else
    vim.cmd("setlocal ve=")
    vim.cmd("mapclear <buffer>")
    vim.b.venn_enabled = nil
  end
end

keymap("n", "<leader>v", "<cmd>lua Toggle_venn()<CR>", { desc = "Toggle Venn diagram mode" })
