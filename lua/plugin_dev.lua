local dev_diffview = false
if dev_diffview then
	vim.opt.runtimepath:prepend(vim.fn.expand("~/coding/contrib/diffview.nvim"))
else
	vim.pack.add({ { src = "https://github.com/dlyongemallo/diffview.nvim", version = "main" } })
end

local dev_diffview_pr = true
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

