return {
	cmd = { "clangd", "--background-index", "--clang-tidy" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd" },
	filetypes = { "c", "cpp" },
}
