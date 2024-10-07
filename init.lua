-- vim:foldmethod=marker

-- {{{ rocks.nvim
do
	-- Specifies where to install/use rocks.nvim
	local install_location = vim.fs.joinpath(vim.fn.stdpath("data"), "rocks")

	-- Set up configuration options related to rocks.nvim (recommended to leave as default)
	local rocks_config = {
		rocks_path = vim.fs.normalize(install_location),
	}

	vim.g.rocks_nvim = rocks_config

	-- Configure the package path (so that plugin code can be found)
	local luarocks_path = {
		vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
		vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
	}
	package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

	-- Configure the C path (so that e.g. tree-sitter parsers can be found)
	local luarocks_cpath = {
		vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
		vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
	}
	package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

	-- Load all installed plugins, including rocks.nvim itself
	vim.opt.runtimepath:append(
		vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")
	)
end

-- If rocks.nvim is not installed then install it!
if not pcall(require, "rocks") then
	local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache"), "rocks.nvim")

	if not vim.uv.fs_stat(rocks_location) then
		-- Pull down rocks.nvim
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/nvim-neorocks/rocks.nvim",
			rocks_location,
		})
	end

	-- If the clone was successful then source the bootstrapping script
	assert(vim.v.shell_error == 0, "rocks.nvim installation failed. Try exiting and re-entering Neovim!")

	vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))

	vim.fn.delete(rocks_location, "rf")
end
-- }}}

-- {{{ appearence
-- for diagnostic
vim.opt.signcolumn = "yes"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.statusline = "%f %h%w%r"
vim.opt.statusline:append(" %{%get(b:, 'gitsigns_head', '')%}")
vim.opt.statusline:append(" %{get(b:, 'gitsigns_status', '')}")
vim.opt.statusline:append("%=%(%l,%c%V %= %P%)")
-- }}}

-- {{{ terminal
-- Maybe this is not usable in tmux
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
-- }}}

-- {{{ fold
vim.wo.foldmethod = "manual"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- }}}

-- {{{ LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		-- backport from nightly
		vim.keymap.set("n", "grn", vim.lsp.buf.rename)
		vim.keymap.set("n", "gra", vim.lsp.buf.code_action)
		vim.keymap.set("n", "grr", vim.lsp.buf.references)
		vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help)
	end,
})
-- }}}

-- {{{ fcitx5
if vim.fn.executable("fcitx5-remote") == 1 then
	local fcitx5state = tonumber(vim.fn.system("fcitx5-remote"))
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			fcitx5state = tonumber(vim.fn.system("fcitx5-remote"))
			vim.fn.system("fcitx5-remote -c")
		end,
	})
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			-- if fcitx5 was activated
			if fcitx5state == 2 then
				vim.fn.system("fcitx5-remote -o")
			end
		end,
	})
end
-- }}}
