return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			local keymap = vim.keymap

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DiagnosticSignHint", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DiagnosticSignInfo", linehl = "DiagnosticUnderlineInfo", numhl = "" }
			)

			-- Dap-UI Config
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Keybindings
			keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggles a dap breakpoint" })
			keymap.set("n", "<leader>dc", dap.continue, { desc = "Dap Continue" })
			keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
			keymap.set("n", "<F8>", dap.step_over, { desc = "Step Over" })
			keymap.set("n", "<F7>", dap.step_into, { desc = "Step Into" })
			keymap.set("n", "<F9>", dap.step_out, { desc = "Step Out" })

			--[[ -- Adapters
			dap.adapters.coreclr = {
				type = "executable",
				command = "/usr/local/bin/netcoredbg/netcoredbg",
				args = { "--interpreter=vscode" },
			}

			-- Debugger configs
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			} ]]
		end,
	},
	{
		{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
	},
	{
		{
			"nicholasmata/nvim-dap-cs",
			dependencies = { "mfussenegger/nvim-dap" },
			config = function()
				require("dap-cs").setup({
					netcoredbg = {
						path = "/usr/local/bin/netcoredbg/netcoredbg",
					},
				})
			end,
		},
	},
}
