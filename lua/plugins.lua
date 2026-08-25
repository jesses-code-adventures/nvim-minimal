vim.pack.add {
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- depended on by neotest
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",   version = "main" },
	{ src = "https://github.com/NLKNguyen/papercolor-theme" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/vrischmann/tree-sitter-templ" },
	{ src = "https://github.com/diepm/vim-rest-console" },
	{ src = "https://github.com/jesses-code-adventures/dotenv.nvim" },
	{ src = "https://github.com/timwmillard/uuid.nvim" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },        -- depended on by neotest
	{ src = "https://github.com/antoinemadec/FixCursorHold.nvim" }, -- depended on by neotest
	{ src = "https://github.com/sbdchd/neoformat" },
	{ src = "https://github.com/fredrikaverpil/neotest-golang" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/nvim-neotest/neotest",              data = {} },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
}

require("dotenv").setup({
	overrides = { ".env", ".local.env", ".env.local", ".local.mine.env", ".env.mine" },
})
require("oil").setup({ view_options = { show_hidden = true } })
require("fzf-lua").setup({
	previewers = {
		builtin = {
			treesitter = {
				disabled = { "markdown" },
			},
		},
	},
	winopts = {
		treesitter = { enabled = false },
	},
})
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

local function register_templ_parser()
	require('nvim-treesitter.parsers').templ = {
		install_info = {
			url = 'https://github.com/vrischmann/tree-sitter-templ',
			files = { 'src/parser.c', 'src/scanner.c' },
		},
	}
end

register_templ_parser()

require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd('User', {
	pattern = 'TSUpdate',
	callback = register_templ_parser,
})

vim.filetype.add({ extension = { templ = 'templ' } })
