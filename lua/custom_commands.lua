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
	vim.cmd('DiffviewOpen origin/main')
end, { desc = 'Diffview against origin/main', nargs = 0 })

vim.api.nvim_create_user_command('Dm', function()
	vim.cmd('DiffviewOpen main')
end, { desc = 'Diffview against main', nargs = 0 })

vim.api.nvim_create_user_command('Dc', function()
	vim.cmd('DiffviewClose')
end, { desc = 'Close Diffview', nargs = 0 })

-- vim.api.nvim_create_user_command('DiffviewPRComment', function(args)
-- 	local ok, pr = pcall(require, 'diffview_pr_comment')
-- 	if not ok then
-- 		vim.notify('diffview-pr.nvim is not available', vim.log.levels.WARN)
-- 		return
-- 	end
-- 	pr.open(args.line1, args.line2)
-- end, { desc = 'Create a GitHub PR comment from a Diffview selection', range = true })
--
-- vim.api.nvim_create_user_command('DiffviewPRCommentsRefresh', function()
-- 	local ok, pr = pcall(require, 'diffview_pr_comment')
-- 	if not ok then
-- 		vim.notify('diffview-pr.nvim is not available', vim.log.levels.WARN)
-- 		return
-- 	end
-- 	pr.refresh()
-- end, { desc = 'Refresh GitHub PR comments in Diffview', nargs = 0 })
--
-- vim.api.nvim_create_user_command('DiffviewPRDebug', function()
-- 	local ok, pr = pcall(require, 'diffview_pr_comment')
-- 	if not ok then
-- 		vim.notify('diffview-pr.nvim is not available', vim.log.levels.WARN)
-- 		return
-- 	end
-- 	pr.debug_state()
-- end, { desc = 'Print Diffview PR plugin state', nargs = 0 })

local function github_diff_highlights()
	local highlights = {
		DiffAdd = { bg = "#1f3d2a", fg = "#b7dfb9" },
		DiffChange = { bg = "#3a2f1f" },
		DiffDelete = { bg = "#4a2528", fg = "#e8b9b7" },
		DiffText = { bg = "#5a4724", fg = "#eadca6" },
		Folded = { bg = "#161b22", fg = "#8b949e" },
		FoldColumn = { bg = "#0d1117", fg = "#8b949e" },
		TabLineSel = { bg = "#bc5215", fg = "#100f0f" },
		diffAdded = { fg = "#87a987" },
		diffRemoved = { fg = "#bf8f8f" },
		diffChanged = { fg = "#d29922" },
		DiffviewNormal = { fg = "#c9d1d9" },
		DiffviewCursorLine = { bg = "#2a2f36" },
		DiffviewFilePanelTitle = { fg = "#8b949e", bold = true },
		DiffviewFilePanelFileName = { fg = "#c9d1d9" },
		DiffviewFilePanelSelected = { fg = "#ffffff", bold = true },
		DiffviewFilePanelPath = { fg = "#8b949e" },
		DiffviewFilePanelInsertions = { fg = "#87a987" },
		DiffviewFilePanelDeletions = { fg = "#bf8f8f" },
		DiffviewDiffAdd = { bg = "#1f3d2a", fg = "#b7dfb9" },
		DiffviewDiffChange = { bg = "#3a2f1f" },
		DiffviewDiffChangeAdd = { bg = "#1f3d2a", fg = "#b7dfb9" },
		DiffviewDiffChangeDelete = { bg = "#4a2528", fg = "#e8b9b7" },
		DiffviewDiffText = { bg = "#5a4724", fg = "#eadca6" },
		DiffviewDiffTextAdd = { bg = "#2d5a3a", fg = "#e6f4e8" },
		DiffviewDiffTextDelete = { bg = "#6b3036", fg = "#f4e1e1" },
		DiffviewDiffAddAsDelete = { bg = "#4a2528", fg = "#e8b9b7" },
		DiffviewDiffDelete = { bg = "#4a2528", fg = "#e8b9b7" },
		DiffviewDiffDeleteDim = { bg = "NONE", fg = "NONE" },
	}

	for group, attrs in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, attrs)
	end
end

github_diff_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = github_diff_highlights })
