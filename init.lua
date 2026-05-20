local o = vim.o
local g = vim.g

g.mapleader = " "
g.omni_sql_default_compl_type = 'syntax'

-- global options
o.wrap = false
o.nu = true
o.guicursor = ""
o.splitbelow = true
o.splitright = true
o.tabstop = 4
o.shiftwidth = 4
o.signcolumn = "yes"
o.relativenumber = true
o.winborder = "rounded"
o.hlsearch = false
o.incsearch = true
o.scrolloff = 999
o.updatetime = 10
o.colorcolumn = "0"
o.cmdheight = 1
o.termguicolors = true

-- completion popup behavior
vim.opt.completeopt = { "menuone", "noselect" }

require("utils")
require("autocmds")
require("diagnostics")
require("plugins")
require("lsp")
require("plugin_dev")
require("diff")
require("custom_commands")

vim.cmd("colorscheme PaperColor")
vim.cmd("hi statusline guibg=NONE")
vim.cmd("hi StatusLineNC guibg=NONE")

require('fzf-lua').register_ui_select()

local dev_diffview = false
if dev_diffview then
	vim.opt.runtimepath:prepend(vim.fn.expand("~/coding/contrib/diffview.nvim"))
else
	vim.pack.add({ { src = "https://github.com/dlyongemallo/diffview.nvim" } })
end

local dev_diffview_pr = false
if dev_diffview_pr then
	vim.opt.runtimepath:prepend(vim.fn.expand("~/coding/personal/diffview-pr.nvim"))
else
	vim.pack.add({ { src = "https://github.com/jesses-code-adventures/diffview-pr.nvim" } })
end

local dev_pipeline = false
if dev_pipeline then
	vim.opt.runtimepath:prepend(vim.fn.expand("~/coding/personal/pipeline.nvim"))
else
	vim.pack.add({ { src = "https://github.com/jesses-code-adventures/pipeline.nvim" } })
end

require("diff")
require("diagnostics")
require("lsp")
require("utils")
require("custom_commands")
require("autocmds")

require("dotenv").setup({
	overrides = { ".env", ".local.env", ".env.local", ".local.mine.env", ".env.mine" },
})
require("oil").setup({ view_options = { show_hidden = true } })
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		topdelete = { text = '‾' },
		changedelete = { text = "~" },
	}
})

local supermaven_api = require("supermaven-nvim.api")
if not supermaven_api.is_running() then
	require("supermaven-nvim").setup({
		keymaps = {
			accept_suggestion = "<C-Space>",
			clear_suggestion = "<C-x>",
		},
	})
end

require("nvim-treesitter").setup({
})

local function register_templ_parser()
	require('nvim-treesitter.parsers').templ = {
		install_info = {
			url = 'https://github.com/vrischmann/tree-sitter-templ',
			files = { 'src/parser.c', 'src/scanner.c' },
		},
	}
end

register_templ_parser()

vim.api.nvim_create_autocmd('User', {
	pattern = 'TSUpdate',
	callback = register_templ_parser,
})

vim.filetype.add({ extension = { templ = 'templ' } })
g.vrc_set_default_mappings = 0
g.vrc_response_default_content_type = "application/json"
g.vrc_output_buffer_name = "_OUTPUT.json"
g.vrc_auto_format_response_patterns = { json = "jq" }
g.vrc_show_command = 1

-- Neoformat
-- allow local prettier config
g.neoformat_try_node_exe = 1
g.neoformat_only_msg_on_error = 1

-- keybinds
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "File explorer (oil)" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>yy", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<leader>gt", [[:split<CR><C-w>j:resize 10<CR>:terminal<CR>]],
	{ desc = "Open terminal in split pane" })
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })
vim.keymap.set('n', '<leader>td', '<cmd>Todos<cr>', { desc = "Search TODOs" })
vim.keymap.set("n", "<leader>cf", "<cmd>:let @+ = expand('%')<CR>", { desc = "Copy current file path" })
vim.keymap.set("n", "<leader>ws", Clean_whitespace_lines,
	{ desc = "Clean whitespace: remove trailing & whitespace-only lines" })

-- keybinds (lsp)
vim.keymap.set("n", "<leader>F", function()
	if Prettier_filetype() then
		vim.cmd("Neoformat prettier")
		return
	end
	vim.lsp.buf.format { async = true }
end, { desc = "Format buffer" })

-- keybinds (fzf-lua)
vim.keymap.set("n", "<leader>ds", function() require("fzf-lua").lsp_document_symbols() end,
	{ desc = "[FZF] LSP Document symbols" })
vim.keymap.set("n", "<leader>xx", function() require("fzf-lua").diagnostics_workspace() end,
	{ desc = "[FZF] Workspace diagnostics" })
vim.keymap.set("n", "<leader>xf", function()
	vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN }, open = false })
	require("trouble").open("qflist")
end, { desc = "[Trouble] Warnings & errors quickfix" })
vim.keymap.set("n", "]x", "<cmd>cnext<CR>zz", { desc = "Next warning/error (quickfix)" })
vim.keymap.set("n", "[x", "<cmd>cprev<CR>zz", { desc = "Prev warning/error (quickfix)" })
vim.keymap.set("n", "<leader>ps", function() require("fzf-lua").grep() end, { desc = "[FZF] Grep" })
vim.keymap.set("n", "<leader>vh", function() require("fzf-lua").help_tags() end, { desc = "[FZF] Search help" })
vim.keymap.set("n", "<leader>gf", function() require("fzf-lua").git_files() end, { desc = "[FZF] Fuzzy find git files" })
vim.keymap.set("n", "<leader>km", function() require("fzf-lua").keymaps() end, { desc = "[FZF] Fuzzy find keymaps" })
vim.keymap.set("n", "<leader>pb", function() require("fzf-lua").buffers() end, { desc = "[FZF] Fuzzy find buffers" })
vim.keymap.set("n", "<leader>pf", function()
	require("fzf-lua").files({
		cmd = "fd -t f -E '.git' -E '**/*.sql.go' -E '**/*_templ.go' -E '**/*mocks.go' -E '**/*mocks_test.go' -E '_tmp'"
	})
end, { desc = "Fuzzy find files" })
vim.keymap.set("n", "<leader>lg", function()
	require("fzf-lua").live_grep({
		cmd =
		"rg -. -g '!*_mocks.go' -g '!*mocks_test.go' -g '!.git' -g '!**/*.sql.go' -g '!*_templ.go' -g '!_tmp' -g '!*.svg' --column -n"
	})
end, { desc = "Grep (live)" })

-- keybinds (vim-rest-console)
vim.keymap.set("n", "<leader>r", ":call VrcQuery()<CR>", { desc = "Make request - vim rest console" })

-- keybinds (uuid.nvim)
vim.keymap.set("n", "<leader>mid", function() require("uuid").newV4() end, { desc = "Generate UUID" })

-- keybinds (fugitive)
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Open git in fugitive" })
vim.keymap.set("n", "<leader>Gd", ":Gdiff<CR>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>Gp", ":Git pull<CR>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>GP", ":Git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>GO", ":Git push -u origin<CR>", { desc = "Git push to origin" })
