local M = { "smartinellimarco/nvcheatsheet.nvim" }

M.opts = {
	-- Default header
	header = {
		"                                      ",
		"                                      ",
		"                                      ",
		"█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀",
		"█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░",
		"                                      ",
		"                                      ",
		"                                      ",
	},
	layout = "column",
	-- Example keymaps (this doesn't create any)
	keymaps = {
		["Oil"] = {
			{ "Toggle oil (closes without saving)", "<leader>q" },
			{ "Select entry", "⏎" },
			{ "Select entry", "l" },
			{ "Go to parent", "h" },
			{ "Open vertical split", "⌃v" },
			{ "Open horizontal split", "⌃x" },
			{ "Go to current working directory", "." },
		},
		["Substitute"] = {
			{ "Replace string in file (c for confirm)", ":%s/o-string/r-string/gc" },
			{ "Delete string in file", ":%s/o-string//gc" },
		},
		["Surround"] = {
			{ "Surround in visual mode", "S{" },
			{ "surr*ound_word", "ysiw)" },
			{ "*make strings", "ys$'" },
			{ "[delete ar*ound me!]", "ds]" },
			{ "remove <b>HTML t*ags</b>", "dst" },
			{ "<b>or tag* types</b>", "csth1<CR>" },
			{ "delete(functi*on calls)", "dsf" },
		},
		["Macros"] = {
			{ "Record to register a", "qa" },
			{ "Play register a", "@a" },
		},
	},
}

function M.config(_, opts)
	local nvcheatsheet = require("nvcheatsheet")

	nvcheatsheet.setup(opts)

	-- You can also close it with <Esc>
	vim.keymap.set("n", "<leader>ch", nvcheatsheet.toggle)
end

return M
