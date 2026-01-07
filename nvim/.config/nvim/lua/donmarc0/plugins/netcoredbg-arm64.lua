-- lua/donmarc0/plugins/netcoredbg-arm64.lua
return {
	"Cliffback/netcoredbg-macOS-arm64.nvim",
	dependencies = { "mfussenegger/nvim-dap" },
	config = function()
		-- Only meaningful on macOS arm64; harmless elsewhere
		local uname = vim.loop.os_uname()
		if uname.sysname == "Darwin" and uname.machine == "arm64" then
			require("netcoredbg-macOS-arm64").setup(require("dap"))
		end
	end,
}
