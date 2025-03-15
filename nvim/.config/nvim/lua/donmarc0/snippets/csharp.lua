local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("cs", {
	s("usingsgi", {
		t("using Gtue.Inspectmobilityservice."),
	}),
})
