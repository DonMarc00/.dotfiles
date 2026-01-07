return {
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		local dotnet = require("easy-dotnet")

		local function is_macos_arm64()
			local u = vim.loop.os_uname()
			return u.sysname == "Darwin" and u.machine == "arm64"
		end

		-- Cliffback ships an arm64 netcoredbg inside the plugin repo.
		-- This path matches lazy.nvim’s default install layout.
		local function resolve_netcoredbg_path()
			if is_macos_arm64() then
				local p = vim.fn.stdpath("data") .. "/lazy/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"
				if vim.loop.fs_stat(p) then
					return p
				end
			end
			-- On WSL/Linux you can typically just rely on PATH,
			-- or leave nil if easy-dotnet-server bundles for your platform.
			return nil
		end

		dotnet.setup({
			picker = "telescope",
			debugger = {
				auto_register_dap = true,
				apply_value_converters = true,
				-- Force an arm64 debugger on Apple Silicon; otherwise let server decide / use bundled.
				bin_path = resolve_netcoredbg_path(),
			},
		})

		-- Optional convenience (does not replace your DAP keys):
		-- vim.keymap.set("n", "<leader>dd", function() vim.cmd("Dotnet debug") end, { desc = "Dotnet debug (pick)" })
		-- vim.keymap.set("n", "<leader>dD", function() vim.cmd("Dotnet debug default") end, { desc = "Dotnet debug default" })
	end,
}
