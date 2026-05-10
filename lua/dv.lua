require("diffview_pr").setup({
	comment_style = "minimal",
})

require("diffview").setup({
	enhanced_diff_hl = true,
	use_icons = true,
	default_args = {
		DiffviewOpen = { "--untracked-files=all" },
	},
	hooks = {
		diff_buf_win_enter = function(bufnr, winid, ctx)
			require("diffview_pr").diff_buf_win_enter(bufnr, winid, ctx)

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
	},
})
