-- DIAGNOSTICS

-- LSP
local methods = vim.lsp.protocol.Methods

local function on_attach(client, bufnr)
	vim.keymap.set({ 'n', 'x' }, 'gra', '<cmd>FzfLua lsp_code_actions<cr>',
		{ buffer = bufnr, desc = 'vim.lsp.buf.code_action()' })

	vim.keymap.set('n', 'grr', '<cmd>FzfLua lsp_references<cr>', { buffer = bufnr, desc = 'vim.lsp.buf.references()' })

	vim.keymap.set('n', 'gy', '<cmd>FzfLua lsp_typedefs<cr>', { buffer = bufnr, desc = 'Go to type definition' })
	vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end,
		{ buffer = bufnr, desc = 'Show diagnostics' })

	vim.keymap.set('n', '<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>',
		{ buffer = bufnr, desc = 'Document symbols' })
	vim.keymap.set('n', '<leader>fS', function()
		-- Disable the grep switch header.
		require('fzf-lua').lsp_live_workspace_symbols({ no_header_i = true })
	end, { buffer = bufnr, desc = 'Workspace symbols' })

	vim.keymap.set('n', '[d', function()
		vim.diagnostic.jump({ count = -1 })
	end, { buffer = bufnr, desc = 'Previous diagnostic' })
	vim.keymap.set('n', ']d', function()
		vim.diagnostic.jump({ count = 1 })
	end, { buffer = bufnr, desc = 'Next diagnostic' })
	vim.keymap.set('n', '[e', function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
	end, { buffer = bufnr, desc = 'Previous error' })
	vim.keymap.set('n', ']e', function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
	end, { buffer = bufnr, desc = 'Next error' })

	if client:supports_method(methods.textDocument_definition, bufnr) then
		vim.keymap.set('n', 'gd', function()
			require('fzf-lua').lsp_definitions({ jump1 = true })
		end, { buffer = bufnr, desc = 'Go to definition' })
		vim.keymap.set('n', 'gD', function()
			require('fzf-lua').lsp_definitions({ jump1 = false })
		end, { buffer = bufnr, desc = 'Peek definition' })
	end

	if client:supports_method('textDocument/completion') then
		vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
	end

	vim.cmd("set completeopt+=noselect")

	if client:supports_method(methods.textDocument_inlayHint) and vim.g.inlay_hints then
		local inlay_hints_group = vim.api.nvim_create_augroup('mariasolos/toggle_inlay_hints', { clear = false })

		-- Initial inlay hint display.
		-- Idk why but without the delay inlay hints aren't displayed at the very start.
		vim.defer_fn(function()
			local mode = vim.api.nvim_get_mode().mode
			vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = bufnr })
		end, 500)

		vim.api.nvim_create_autocmd('InsertEnter', {
			group = inlay_hints_group,
			desc = 'Enable inlay hints',
			buffer = bufnr,
			callback = function()
				if vim.g.inlay_hints then
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
				end
			end,
		})

		vim.api.nvim_create_autocmd('InsertLeave', {
			group = inlay_hints_group,
			desc = 'Disable inlay hints',
			buffer = bufnr,
			callback = function()
				if vim.g.inlay_hints then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end,
		})
	end

	-- Add "Fix all" command for ESLint.
	if client.name == 'eslint' then
		vim.keymap.set('n', '<leader>ce', function()
			if not client then
				return
			end

			client:request(vim.lsp.protocol.Methods.workspace_executeCommand, {
				command = 'eslint.applyAllFixes',
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = vim.lsp.util.buf_versions[bufnr],
					},
				},
			}, nil, bufnr)
		end, { desc = 'Fix all ESLint errors', buffer = bufnr })
	end
end

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
	return hover {
		max_height = math.floor(vim.o.lines * 0.5),
		max_width = math.floor(vim.o.columns * 0.4),
	}
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
	return signature_help({
		max_height = math.floor(vim.o.lines * 0.5),
		max_width = math.floor(vim.o.columns * 0.4),
	})
end

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'Configure LSP keymaps',
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if not client then
			return
		end

		on_attach(client, args.buf)
	end,
})

vim.lsp.handlers[methods.textDocument_publishDiagnostics] = function(err, result, ctx, config)
	local uri = result.uri
	if vim.fn.filereadable(vim.uri_to_fname(uri)) == 0 then
		return
	end
	vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if not client then
		return
	end

	on_attach(client, vim.api.nvim_get_current_buf())

	return register_capability(err, res, ctx)
end
