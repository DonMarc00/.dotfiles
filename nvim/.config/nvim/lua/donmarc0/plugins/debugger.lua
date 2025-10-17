return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
		-- Per-project configs (see step 3)
		"ldelossa/nvim-dap-projects",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.set_log_level("TRACE")
		dapui.setup()

		-- Signs (kept)
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
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

		-- Auto open/close dap-ui
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({ reset = true })
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Keybindings (kept)
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

		---------------------------------------------------------------------------
		-- Rust adapters (pick ONE block and keep the other commented)
		---------------------------------------------------------------------------

		-- Option A: codelldb (recommended)
		-- Try Mason first, then Homebrew fallback.
		local function detect_codelldb()
			local mason_cmd = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
			if vim.loop.fs_stat(mason_cmd) then
				return mason_cmd
			end
			-- Homebrew (Apple Silicon)
			if vim.loop.fs_stat("/opt/homebrew/bin/codelldb") then
				return "/opt/homebrew/bin/codelldb"
			end
			-- Homebrew (Intel)
			if vim.loop.fs_stat("/usr/local/bin/codelldb") then
				return "/usr/local/bin/codelldb"
			end
			return nil
		end

		local codelldb_path = detect_codelldb()
		if codelldb_path then
			dap.adapters.codelldb = function(cb, _)
				cb({
					type = "server",
					port = "${port}",
					executable = {
						command = codelldb_path,
						args = { "--port", "${port}" },
					},
				})
			end
		end

		require("nvim-dap-projects").search_project_config()
	end,
}
