-- Define a function to highlight color hex codes in strings
local function highlightHex()
	-- Define highlighting group for hex color codes within strings
	vim.cmd("highlight HexColor guifg=#RRGGBB ctermfg=hexadecimal")

	-- Define a pattern to match hex color codes within strings
	local pattern = [["#[0-9a-fA-F]\+"]]

	-- Get current buffer handle
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get content of the current buffer
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	-- Loop through each line in the buffer
	for lnum, line in ipairs(lines) do
		-- Find matches of the pattern in the line
		for match in line:gmatch(pattern) do
			-- Calculate start and end positions of the match
			local start_col, end_col = line:find(match, 1, true)

			-- Apply highlighting to the match
			vim.api.nvim_buf_add_highlight(bufnr, -1, "HexColor", lnum - 1, start_col - 1, end_col)
		end
	end
end

vim.cmd("command! HighlightHex lua require('azinch.plugins.color-highlight').highlightHex()")

-- Call the highlightHex function when opening TypeScript/TSX files
vim.api.nvim_exec(
	[[
    augroup HighlightHexInStrings
        autocmd!
        autocmd FileType typescript,typescriptreact lua require('azinch.plugins.color-highlight).highlightHex()
    augroup END
]],
	false
)
