-- vim:foldmethod=marker

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
