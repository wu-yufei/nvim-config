if vim.fn.executable("pylsp") == 1 then
	vim.lsp.start({
		name = "pylsp",
		cmd = { "pylsp" },
		root_dir = vim.fs.root(0, { "pyproject.toml", "setup.cfg", "setup.py", "requirements.txt" }),
	})
end
