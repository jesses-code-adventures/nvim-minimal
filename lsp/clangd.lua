-- install: clang install with macos

---@type vim.lsp.Config
return {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--fallback-style=none',
        '--function-arg-placeholders=false',
    },
    filetypes = { 'c', 'cpp' },
    root_markers = {
        '.git',
        '.clangd',
        'compile_commands.json',
        'compile_flags.txt',
  },
}
