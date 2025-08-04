return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup({})

		vim.keymap.set("n", "<leader>dod", function()
			vim.cmd("DiffviewOpen develop...HEAD")
		end, { desc = "Diffview: Open develop...HEAD" })
	end,
}
