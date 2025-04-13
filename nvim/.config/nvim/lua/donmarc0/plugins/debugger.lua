return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mxsdev/nvim-dap-vscode-js",
		{
			"microsoft/vscode-js-debug",
			version = "1.x",
			build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
		},
		{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
		{
			"nicholasmata/nvim-dap-cs",
			config = function()
				require("dap-cs").setup({
					netcoredbg = {
						path = "/usr/local/bin/netcoredbg/netcoredbg",
					},
				})
			end,
		},
	},
	config = function()
		local dap = require("dap")
		dap.set_log_level("TRACE")
		local dapui = require("dapui")
		local dapVsCodeJs = require("dap-vscode-js")
		dapVsCodeJs.setup({
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
		})
		dapui.setup()
		local keymap = vim.keymap

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

		-- Dap-UI Config
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({ reset = true })
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
		keymap.set("n", "<leader>dut", dapui.toggle, { desc = "Toggle DapUi" })

		dap.adapters.chrome = {
			type = "executable",
			command = "node",
			args = { vim.fn.getenv("VS_CODE_CHROME_DEBUGER") },
		}

		for _, language in ipairs({ "typescript", "javascript" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch current file in new node process",
					program = "${file}",
				},
				{
					type = "pwa-node",
					request = "attach",
					processId = require("dap.utils").pick_process,
					name = "Attach debugger to existing `node --inspect` process",
					sourceMaps = true,
					resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules**" },
					cwd = "${workspaceFolder}",
					skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
				},
				{
					-- 1) Angular at root `src`
					type = "pwa-chrome",
					request = "attach",
					name = "Debug Angular (root src)",
					url = "http://localhost:4200", -- or your serve port
					webRoot = "${workspaceFolder}/src",
					sourceMaps = true,
					protocol = "inspector",
					port = 9222,
					skipFiles = { "**/node_modules/**" },
				},
				{
					-- 2) Angular in `projects/my-app/src`
					type = "chrome",
					request = "attach",
					name = "Debug Angular (projects folder)",
					program = "${file}",
					webRoot = "${workspaceFolder}/projects/gtue-inspectmobility/src",
					sourceMapPathOverrides = {
						["webpack://projects/gtue-inspectmobility/src/*"] = "${workspaceFolder}/projects/gtue-inspectmobility/src/*",
						["webpack://src/*"] = "${workspaceFolder}/projects/gtue-inspectmobility/src/*",
					},
					protocol = "inspector",
					port = 9222,
					skipFiles = { "**/node_modules/**" },
				},
			}
		end
	end,
}
