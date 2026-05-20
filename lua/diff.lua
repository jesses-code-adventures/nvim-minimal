local has_diffview_pr, diffview_pr = pcall(require, "diffview_pr")

if has_diffview_pr then
	diffview_pr.setup({
		comment_style = "minimal",
	})
end

require("diffview").setup({
	enhanced_diff_hl = true,
	use_icons = true,
	default_args = {
		DiffviewOpen = { "--untracked-files=all" },
	},
	hooks = {
		diff_buf_win_enter = function(bufnr, winid, ctx)
			if has_diffview_pr then
				diffview_pr.diff_buf_win_enter(bufnr, winid, ctx)
			end

			local is_old_side = ctx.symbol == "a"
			local add_hl = is_old_side and "DiffviewDiffAddAsDelete" or "DiffviewDiffAdd"
			local change_hl = is_old_side and "DiffviewDiffChangeDelete" or "DiffviewDiffChangeAdd"
			local text_hl = is_old_side and "DiffviewDiffTextDelete" or "DiffviewDiffTextAdd"

			vim.wo[winid].fillchars = "diff: "
			vim.wo[winid].winhighlight = table.concat({
				"DiffAdd:" .. add_hl,
				"DiffDelete:DiffviewDiffDeleteDim",
				"DiffChange:" .. change_hl,
				"DiffText:" .. text_hl,
			}, ",")
		end,
	},
	file_panel = {
		listing_style = "tree",
		win_config = {
			position = "left",
			width = 36,
		},
		show_root_path = false,
	},
})

vim.api.nvim_create_user_command('Dom', function()
	vim.cmd('DiffviewOpen --untracked-files=all origin/main')
end, { desc = 'Diffview against origin/main', nargs = 0 })

vim.api.nvim_create_user_command('Dm', function()
	vim.cmd('DiffviewOpen --untracked-files=all main')
end, { desc = 'Diffview against main', nargs = 0 })

vim.api.nvim_create_user_command('Dc', function()
	vim.cmd('DiffviewClose')
end, { desc = 'Close Diffview', nargs = 0 })

vim.api.nvim_create_user_command('Do', function()
	vim.cmd('DiffviewOpen')
end, { desc = 'Open Diffview against index', nargs = 0 })

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
