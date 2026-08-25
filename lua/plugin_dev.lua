---@param dev boolean
---@param dir string
---@param url string
---@param version string?
local function handle_dev_plugin(dev, dir, url, version)
	local expanded_dir = vim.fn.expand(dir)
	if dev and vim.fn.isdirectory(expanded_dir) == 1 then
		vim.opt.runtimepath:prepend(expanded_dir)
	else
		vim.pack.add({ { src = url, version = version } })
	end
end

handle_dev_plugin(false, "~/coding/contrib/diffview.nvim", "https://github.com/dlyongemallo/diffview.nvim", "main")
-- handle_dev_plugin(true, "~/coding/personal/diffview-pr.nvim", "https://github.com/jesses-code-adventures/diffview-pr.nvim")
handle_dev_plugin(false, "~/coding/personal/pipeline.nvim", "https://github.com/jesses-code-adventures/pipeline.nvim")
