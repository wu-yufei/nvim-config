if vim.fn.executable("lua-language-server") == 1 then
	vim.lsp.start({
		name = "texlab",
		cmd = { "texlab" },
		root_dir = vim.fs.root(0, { ".git", "Tectonic.toml" }),
		settings = {
			texlab = {
				build = {
					executable = "tectonic",
					args = { "-X",
						"compile",
						"%f",
						"--synctex",
						"--keep-logs",
						"--keep-intermediates" },
				},
				forwardSearch = {
					executable = "zathura",
					args = { "--synctex-forward", "%l:1:%f", "%p" },
				},
			},
		}
	})
end
