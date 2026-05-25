-- when yanking, highlight the yanked text
local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})
vim.api.nvim_create_autocmd('TextYankPost', {
	group = yank_group,
	pattern = '*',
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 40,
		})
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'go', 'lua', 'templ', 'prisma', 'javascript', 'css', 'markdown', 'markdown_inline' },
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.cmd([[
  au BufNewFile,BufRead *.env.* set filetype=sh
]])

-- enable omnifunc for insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.opt_local.omnifunc = "syntaxcomplete#Complete"
	end,
})
