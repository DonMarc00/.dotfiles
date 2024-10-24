return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			local keymap = vim.keymap

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
