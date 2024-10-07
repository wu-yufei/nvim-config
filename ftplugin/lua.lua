if vim.fn.executable("lua-language-server") == 1 then
	vim.lsp.start({
		name = "lua_ls",
		cmd = { "lua-language-server" },
		root_dir = vim.fs.root(0, { ".git", "stylua.toml" }),
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
				},
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
					},
				},
			})
		end,
		settings = {
			Lua = {},
		},
	})
end
