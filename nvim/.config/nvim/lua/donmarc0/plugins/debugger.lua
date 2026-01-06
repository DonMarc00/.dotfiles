return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
		{ "Cliffback/netcoredbg-macOS-arm64.nvim" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.set_log_level("TRACE")
		dapui.setup()

		---------------------------------------------------------------------------
		-- Terminal support for interactive programs
		---------------------------------------------------------------------------
		dap.defaults = dap.defaults or {}
		dap.defaults.fallback = dap.defaults.fallback or {}
		dap.defaults.fallback.focus_terminal = true
		dap.defaults.fallback.terminal_win_cmd = "botright split | resize 12 | terminal"

		-- Some nvim-dap versions don't define `dap.handlers`
		dap.handlers = dap.handlers or {}

		-- Force "runInTerminal" to create a real Neovim terminal split (stdin goes to your app)
		dap.handlers["runInTerminal"] = function(_, body)
			vim.cmd(dap.defaults.fallback.terminal_win_cmd)

			-- Ensure a shell is running in the terminal
			local chan = vim.b.terminal_job_id
			if not chan or chan == 0 then
				chan = vim.fn.termopen(vim.o.shell)
				vim.b.terminal_job_id = chan
			end

			-- Apply cwd
			if body.cwd and body.cwd ~= "" then
				vim.fn.chansend(chan, "cd " .. vim.fn.shellescape(body.cwd) .. "\n")
			end

			-- Apply env
			if body.env and type(body.env) == "table" then
				for k, v in pairs(body.env) do
					vim.fn.chansend(chan, "export " .. k .. "=" .. vim.fn.shellescape(v) .. "\n")
				end
			end

			-- Run command (body.args includes executable and args)
			local args = body.args or {}
			local cmd = table.concat(args, " ")
			vim.fn.chansend(chan, cmd .. "\n")

			-- Reply to adapter
			return { processId = vim.fn.getpid() }
		end

		---------------------------------------------------------------------------
		-- Signs (yours)
		---------------------------------------------------------------------------
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
		-- Keybindings (yours)
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

		---------------------------------------------------------------------------
		-- Adapter selection
		---------------------------------------------------------------------------
		local uname = vim.loop.os_uname()
		local is_macos_arm64 = (uname.sysname == "Darwin" and uname.machine == "arm64")

		if is_macos_arm64 then
			require("netcoredbg-macOS-arm64").setup(dap)
		else
			local netcoredbg = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
			if vim.fn.has("win32") == 1 then
				netcoredbg = netcoredbg .. ".exe"
			end

			if vim.loop.fs_stat(netcoredbg) == nil then
				vim.notify(
					"[nvim-dap] netcoredbg not found via Mason. Install it with :Mason (netcoredbg).",
					vim.log.levels.WARN
				)
			else
				local adapter = {
					type = "executable",
					command = netcoredbg,
					args = { "--interpreter=vscode" },
				}
				dap.adapters.coreclr = adapter
				dap.adapters.netcoredbg = adapter
			end
		end

		---------------------------------------------------------------------------
		-- C# configurations
		---------------------------------------------------------------------------
		local has_dotnet_picker, dotnet = pcall(require, "donmarc0.configs.dotnet_dap")

		dap.configurations.cs = {
			(has_dotnet_picker and {
				type = "coreclr",
				name = "Launch (pick project)",
				request = "launch",
				program = function()
					local project_root = select(1, dotnet.pick_project())
					if not project_root then
						error("[nvim-dap] Launch cancelled (no project selected).")
					end
					return dotnet.build_dll_path_for_project(project_root)
				end,
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			} or nil),
			{
				type = "coreclr",
				name = "Attach to process",
				request = "attach",
				processId = function()
					return require("dap.utils").pick_process()
				end,
			},
		}

		-- remove nil entries
		local cleaned = {}
		for _, cfg in ipairs(dap.configurations.cs) do
			if cfg then
				table.insert(cleaned, cfg)
			end
		end
		dap.configurations.cs = cleaned
	end,
}
