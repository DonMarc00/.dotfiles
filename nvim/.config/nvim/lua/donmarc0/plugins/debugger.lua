return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.set_log_level("TRACE")
		dapui.setup()

		-- IMPORTANT for interactive console apps:
		-- program stdin goes to the terminal window, not the DAP repl.
		dap.defaults.fallback.terminal_win_cmd = "botright split | resize 12 | terminal"

		---------------------------------------------------------------------------
		-- Signs (yours)
		---------------------------------------------------------------------------
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignHint" })
		vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define(
			"DapStopped",
			{ text = "", texthl = "DiagnosticSignInfo", linehl = "DiagnosticUnderlineInfo" }
		)

		---------------------------------------------------------------------------
		-- Auto open/close dap-ui (yours)
		---------------------------------------------------------------------------
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({ reset = true })
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		---------------------------------------------------------------------------
		-- Keybinds (yours, unchanged)
		---------------------------------------------------------------------------
		local keymap = vim.keymap
		keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggles a dap breakpoint" })
		keymap.set("n", "<leader>dc", dap.continue, { desc = "Dap Continue" })
		keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
		keymap.set("n", "<F8>", dap.step_over, { desc = "Step Over" })
		keymap.set("n", "<F7>", dap.step_into, { desc = "Step Into" })
		keymap.set("n", "<F9>", dap.step_out, { desc = "Step Out" })
		keymap.set("n", "<leader>dut", function()
			dapui.toggle({ reset = true })
		end, { desc = "Toggle DapUi" })

		-- Intentionally: NO dap.adapters.coreclr and NO dap.configurations.cs
		-- easy-dotnet registers everything (auto_register_dap).
	end,
}
