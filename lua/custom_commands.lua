-- commands
vim.api.nvim_create_user_command('Todos', function()
	require('fzf-lua').grep { search = [[TODO:|todo!\(.*\)|HACK:|hack!\(.*\)]], no_esc = true }
end, { desc = 'Grep TODOs', nargs = 0 })

vim.api.nvim_create_user_command('Scratch', function()
	vim.cmd('bel 10new')
	local buf = vim.api.nvim_get_current_buf()
	for name, value in pairs {
		filetype = 'scratch',
		buftype = 'nofile',
		bufhidden = 'wipe',
		swapfile = false,
		modifiable = true,
	} do
		vim.api.nvim_set_option_value(name, value, { buf = buf })
	end
end, { desc = 'Open a scratch buffer', nargs = 0 })

vim.api.nvim_create_user_command('Dom', function()
	vim.cmd('DiffviewOpen origin/main...HEAD')
end, { desc = 'Diffview against origin/main', nargs = 0 })

vim.api.nvim_create_user_command('Dm', function()
	vim.cmd('DiffviewOpen main...HEAD')
end, { desc = 'Diffview against main', nargs = 0 })

vim.api.nvim_create_user_command('Dc', function()
	vim.cmd('DiffviewClose')
end, { desc = 'Close Diffview', nargs = 0 })

local function muted_diff_highlights()
	local highlights = {
		DiffAdd = { bg = "#26332b" },
		DiffChange = { bg = "#2f2f24" },
		DiffDelete = { bg = "#332626", fg = "#8a6f6f" },
		DiffText = { bg = "#3a3726" },
		Folded = { bg = "#2b2923", fg = "#d7af5f" },
		FoldColumn = { bg = "#1c1c1c", fg = "#d7af5f" },
		TabLineSel = { bg = "#d7af5f", fg = "#1c1c1c" },
		DiffviewDiffAddAsDelete = { bg = "#332626", fg = "#8a6f6f" },
		DiffviewDiffDelete = { fg = "#5f5f5f" },
		DiffviewFilePanelInsertions = { fg = "#87a987" },
		DiffviewFilePanelDeletions = { fg = "#a98787" },
	}

	for group, attrs in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, attrs)
	end
end

muted_diff_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = muted_diff_highlights })
