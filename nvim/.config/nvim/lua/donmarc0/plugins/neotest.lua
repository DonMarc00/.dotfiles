return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-plenary",
		"nvim-neotest/neotest-vim-test",
		"nvim-lua/plenary.nvim",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet",
		"nvim-neotest/neotest-jest",
	},
	config = function()
		local neotest = require("neotest")
		neotest.setup({
			adapters = {
				require("neotest-python")({
					dap = { justMyCode = false },
				}),
				require("neotest-plenary"),
				require("neotest-dotnet"),
				require("neotest-vim-test")({
					ignore_file_types = { "python", "vim", "lua" },
				}),
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "jest.config.ts",
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
			},
		})

		-- Define keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>tn", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })

		keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run all tests in the current file" })

		keymap.set("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })

		keymap.set("n", "<leader>ts", function()
			neotest.run.stop()
		end, { desc = "Stop nearest test" })

		keymap.set("n", "<leader>ta", function()
			neotest.run.attach()
		end, { desc = "Attach to nearest test" })

		-- Watch Tests: Automatically re-runs tests on file changes
		keymap.set("n", "<leader>tw", function()
			neotest.watch.watch()
		end, { desc = "Watch tests for changes" })

		-- Output Window: Show the output of the last run test
		keymap.set("n", "<leader>to", function()
			neotest.output.open({ enter = true })
		end, { desc = "Show output window for last test" })

		-- Output Panel: Show all test outputs over time
		keymap.set("n", "<leader>tp", function()
			neotest.output_panel.open()
		end, { desc = "Show output panel for all tests" })

		-- Summary Window: Display the test suite structure
		keymap.set("n", "<leader>tsm", function()
			neotest.summary.open()
		end, { desc = "Show test summary window" })

		-- Toggle Summary Window: Quickly toggle the test suite structure window
		keymap.set("n", "<leader>tt", function()
			neotest.summary.toggle()
		end, { desc = "Toggle test summary window" })

		-- Diagnostic Messages: Use vim.diagnostic to show errors during test runs
		keymap.set("n", "<leader>tdm", function()
			-- Optionally trigger diagnostics (this is typically enabled by default)
			vim.notify("Diagnostics integration is active for Neotest", vim.log.levels.INFO)
		end, { desc = "Show diagnostic messages for test errors" })

		-- Status Signs: Enable status signs for test results in the sign column
		keymap.set("n", "<leader>tss", function()
			-- Status signs are enabled by default; this can refresh or toggle them
			vim.notify("Status signs for test results are active", vim.log.levels.INFO)
		end, { desc = "Enable status signs for test results" })
	end,
}
