return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		-- Load Lua snippets from donmarc0/snippets dynamically
		require("luasnip.loaders.from_lua").load({
			paths = vim.fn.stdpath("config") .. "/lua/donmarc0/snippets",
		})
	end,
}
