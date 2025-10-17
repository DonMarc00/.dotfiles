return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod
		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		local custom_actions = transform_mod({
			open_trouble_qflist = function(_)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--glob=!**/*.Test/**",
					"--glob=!**/*.test/**",
					"--glob=!**/TestResults/**",
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				live_grep_args = {
					auto_quoting = true,
					mappings = {
						i = {
							-- Quote current prompt
							["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
							-- Quote and append --iglob (type a glob after pressing)
							["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
								postfix = " --iglob ",
							}),
							-- Freeze results -> fuzzy refine
							["<C-space>"] = require("telescope-live-grep-args.actions").to_fuzzy_refine,
						},
					},
					-- you can add theme/layout here if you want:
					-- theme = "dropdown",
					-- layout_config = { mirror = true },
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")

		-- keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy find buffers" })
		keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd (excluding tests)" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

		-- Existing: include tests
		keymap.set("n", "<leader>fgt", function()
			require("telescope.builtin").live_grep({
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
			})
		end, { desc = "Find string in cwd (including tests)" })

		keymap.set("n", "<leader>fg", function()
			require("telescope").extensions.live_grep_args.live_grep_args()
		end, { desc = "Live grep (args)" })

		keymap.set("n", "<leader>fh", function()
			require("telescope").extensions.live_grep_args.live_grep_args({
				additional_args = function(_)
					return { "--glob", "*.html" }
				end,
			})
		end, { desc = "Live grep in HTML files only" })

		local lga_shortcuts = require("telescope-live-grep-args.shortcuts")
		keymap.set("n", "<leader>gc", lga_shortcuts.grep_word_under_cursor, { desc = "Live grep word under cursor" })
	end,
}
