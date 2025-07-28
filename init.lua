vim.g.mapleader = " "
vim.g.omni_sql_default_compl_type = 'syntax'

-- global options
vim.o.wrap = false
vim.o.nu = true
vim.o.guicursor = ""
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.winborder = "rounded"
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.scrolloff = 999
vim.o.updatetime = 10
vim.o.colorcolumn = "0"
vim.o.cmdheight = 0
vim.filetype.add {
    extension = {
        templ = "templ",
    },
}
vim.opt.termguicolors = true

-- get plugins
vim.pack.add{
  { src = "https://github.com/NLKNguyen/papercolor-theme" },
  -- { src = "https://github.com/kvrohit/rasmus.nvim" },
  -- { src = "https://github.com/kepano/flexoki-neovim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/supermaven-inc/supermaven-nvim" },
  { src = "https://github.com/vrischmann/tree-sitter-templ" },
  { src = "https://github.com/diepm/vim-rest-console" },
  { src = "https://github.com/jesses-code-adventures/dotenv.nvim" },
  { src = "https://github.com/timwmillard/uuid.nvim" },
}

-- lsp & diagnostics
require("diagnostics")
require("lsp")
vim.lsp.enable({ "lua_ls", "ruff", "gopls" })

vim.cmd("colorscheme PaperColor")
vim.cmd("hi statusline guibg=NONE")
vim.cmd("hi StatusLineNC guibg=NONE")

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "bit", "vim", "it", "describe", "before_each", "after_each", "os", "require" },
      },
      library = {
        vim.fn.expand("$VIMRUNTIME/lua"),
      }
    }
  },
})

-- setup plugins
require("dotenv").setup({
	overrides = { ".env", ".local.env", ".env.local", ".local.mine.env", ".env.mine" },
})
require("oil").setup( { view_options = { show_hidden = true } })
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		topdelete = { text = '‾' },
		changedelete = { text = "~" },
	}
})
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<C-Space>",
		clear_suggestion = "<C-x>",
	},
})
require("nvim-treesitter").setup({
	sync_install = false,
	auto_install = true,
	highlight = { enable = true },
	additional_vim_regex_highlighting = false,
})
-- TODO: only enable for go and templ files
require("tree-sitter-templ").setup()
vim.g.vrc_set_default_mappings = 0
vim.g.vrc_response_default_content_type = "application/json"
vim.g.vrc_output_buffer_name = "_OUTPUT.json"
vim.g.vrc_auto_format_response_patterns = { json = "jq" }

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

vim.cmd([[
  au BufNewFile,BufRead *.env.* set filetype=sh
]])

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


-- keybinds
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "File explorer (oil)" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set({ "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>yy", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<leader>gt", [[:vsplit<CR><C-w>L:vertical resize -60<CR>:terminal<CR>]], { desc = "Open terminal in split pane" })
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })
vim.keymap.set('n', '<leader>td', '<cmd>Todos<cr>', { desc = "Search TODOs" })
vim.keymap.set("n", "<leader>cf", "<cmd>:let @+ = expand('%')<CR>", { desc = "Copy current file path" })

-- keybinds (fzf-lua)
vim.keymap.set("n", "<leader>ds", function() require("fzf-lua").lsp_document_symbols() end, { desc = "[LSP] Document symbols" })
vim.keymap.set("n", "<leader>xx", function() require("fzf-lua").diagnostics_workspace() end, { desc = "[LSP} Fuzzy find workspace diagnostics" })
vim.keymap.set("n", "<leader>ps", function() require("fzf-lua").grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>vh", function() require("fzf-lua").help_tags() end, { desc = "Search help" })
vim.keymap.set("n", "<leader>gf", function() require("fzf-lua").git_files() end, { desc = "Fuzzy find git files" })
vim.keymap.set("n", "<leader>km", function() require("fzf-lua").keymaps() end, { desc = "Fuzzy find keymaps" })
vim.keymap.set("n", "<leader>pb", function() require("fzf-lua").buffers() end, { desc = "Fuzzy find buffers" })
vim.keymap.set("n", "<leader>pf", function() require("fzf-lua").files({
	cmd = "fd -t f -E '.git' -E '**/*.sql.go' -E '**/*_templ.go' -E '**/*mocks.go' -E '**/*mocks_test.go' -E '_tmp'"
}) end, { desc = "Fuzzy find files" })
vim.keymap.set("n", "<leader>lg", function() require("fzf-lua").live_grep({
	cmd = "rg -. -g '!*_mocks.go' -g '!*mocks_test.go' -g '!.git' -g '!**/*.sql.go' -g '!*_templ.go' -g '!_tmp' --column -n"
}) end, { desc = "Grep (live)" })

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
