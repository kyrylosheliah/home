return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.keymap.set("n", "<leader>gg", "<CMD>LazyGit<CR>")
		vim.keymap.set("n", "<leader>gl", require("telescope").extensions.lazygit.lazygit)
	end,
}
