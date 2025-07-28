-- global options
vim.o.wrap = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.winborder = "rounded"
vim.g.mapleader = " "
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- plugins
vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
}
require("oil").setup( { view_options = { show_hidden = true } })

-- commands
vim.api.nvim_create_user_command('Todos', function()
    require('fzf-lua').grep { search = [[TODO:|todo!\(.*\)|HACK:|hack!\(.*\)]], no_esc = true }
end, { desc = 'Grep TODOs', nargs = 0 })

vim.api.nvim_create_user_command('Scratch', function()
    vim.cmd 'bel 10new'
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


-- lsp
vim.lsp.enable({ "lua_ls", "ruff", "gopls" })

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
vim.keymap.set("n", "<leader>pf", function() require("fzf-lua").files({
	cmd = "rg -. -g '!*_mocks.go' -g '!*mocks_test.go' -g '!.git' -g '!**/*.sql.go' -g '!*_templ.go' -g '!_tmp'"	
}) end, { desc = "Fuzzy find files" })
vim.keymap.set("n", "<leader>ds", function() require("fzf-lua").lsp_document_symbols() end, { desc = "[LSP] Document symbols" })
vim.keymap.set("n", "<leader>xx", function() require("fzf-lua").diagnostics_workspace() end, { desc = "[LSP} Fuzzy find workspace diagnostics" })
vim.keymap.set("n", "<leader>lg", function() require("fzf-lua").live_grep({
	cmd = "fd -t f -E '.git' -E '**/*.sql.go' -E '**/*_templ.go' -E '**/*mocks.go' -E '**/*mocks_test.go' -E '_tmp'"
}) end, { desc = "Live grep" })
