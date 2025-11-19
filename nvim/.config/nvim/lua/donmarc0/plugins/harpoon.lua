return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		local keymap = vim.keymap

		harpoon:setup({})

		--------------------------------------------------------------------------
		-- Telescope-UI for Harpoon
		--------------------------------------------------------------------------
		local conf = require("telescope.config").values

		local function toggle_telescope(harpoon_list)
			local file_paths = {}
			for _, item in ipairs(harpoon_list.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				})
				:find()
		end

		-- Öffnet Harpoon-Liste in Telescope
		keymap.set("n", "<leader>hf", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Harpoon: Öffne Telescope-UI" })

		keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Aktuelle Datei hinzufügen" })

		keymap.set("n", "<leader>hp", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Vorheriger" })
		keymap.set("n", "<leader>hn", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Nächster" })

		--------------------------------------------------------------------------
		-- Optional: native Harpoon-Quick-Menu statt Telescope
		-- keymap.set("n", "<leader>e", function()
		--   harpoon.ui:toggle_quick_menu(harpoon:list())
		-- end, { desc = "Harpoon: Quick-Menu" })
		--------------------------------------------------------------------------
	end,
}
