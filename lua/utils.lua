function Prettier_filetype()
	return vim.bo.filetype == "javascript" or
		vim.bo.filetype == "typescript" or
		vim.bo.filetype == "javascriptreact" or
		vim.bo.filetype == "typescriptreact" or
		vim.bo.filetype == "vue"
end

vim.filetype.add({
	extension = {
		templ = "templ",
		prisma = "prisma",
	},
})

-- Clean whitespace function: removes trailing whitespace and converts whitespace-only lines to empty lines
function Clean_whitespace_lines()
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local modified = false
	local whitespace_only_count = 0
	local trailing_count = 0

	for i, line in ipairs(lines) do
		local original_line = line

		-- Remove trailing whitespace
		line = string.gsub(line, "%s+$", "")

		-- Check if original line had trailing whitespace
		if line ~= original_line then
			trailing_count = trailing_count + 1
			modified = true
		end

		-- Check if line contains only whitespace (spaces, tabs) in the original
		if string.match(original_line, "^%s+$") then
			line = ""
			whitespace_only_count = whitespace_only_count + 1
			modified = true
		end

		lines[i] = line
	end

	if modified then
		-- Save cursor position
		local cursor = vim.api.nvim_win_get_cursor(0)

		-- Replace buffer content
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

		-- Restore cursor position
		vim.api.nvim_win_set_cursor(0, cursor)

		-- Create detailed notification
		local message = "Whitespace cleaned:"
		if whitespace_only_count > 0 then
			message = message .. " " .. whitespace_only_count .. " whitespace-only lines"
		end
		if trailing_count > 0 then
			if whitespace_only_count > 0 then message = message .. "," end
			message = message .. " " .. trailing_count .. " lines with trailing whitespace"
		end

		vim.notify(message, vim.log.levels.INFO)
	else
		vim.notify("No whitespace issues found", vim.log.levels.INFO)
	end
end
