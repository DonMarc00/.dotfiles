return {
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap",
	},
	config = function()
		local dotnet = require("easy-dotnet")

		local function uname()
			return vim.loop.os_uname()
		end

		local function is_macos_arm64()
			local u = uname()
			return u.sysname == "Darwin" and u.machine == "arm64"
		end

		local function is_linux()
			return uname().sysname == "Linux"
		end

		local function resolve_netcoredbg_path()
			-- macOS arm64: use Cliffback plugin binary (bundled)
			if is_macos_arm64() then
				local p = vim.fn.stdpath("data") .. "/lazy/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"
				if vim.loop.fs_stat(p) then
					return p
				end
			end

			-- WSL/Linux: use Mason netcoredbg
			if is_linux() then
				local mason_p = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
				if vim.loop.fs_stat(mason_p) then
					return mason_p
				end
			end

			-- fallback: let easy-dotnet decide (PATH/bundled)
			return nil
		end

		dotnet.setup({
			picker = "telescope",
			debugger = {
				auto_register_dap = true,
				apply_value_converters = true,
				bin_path = resolve_netcoredbg_path(),
			},
		})
	end,
}
