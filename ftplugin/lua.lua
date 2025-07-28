local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = { version = "Lua 5.1" },
      diagnostics = {
        globals = { "bit", "vim", "it", "describe", "before_each", "after_each", "os", "require" },
      },
      library = {
        vim.fn.expand("$VIMRUNTIME/lua"),
        vim.fn.expand("lua/lsp.lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/blink.cmp/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/diffview.nvim/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/fzf-lua/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/lazy.nvim/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/nvim-dap-go/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/nvim-dap-ui/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/nvim-dap/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/nvim-treesitter/lua"),
        vim.fn.expand("$XDG_DATA_HOME/nvim/lazy/plenary.nvim/lua"),
      }
    }
  },
})
