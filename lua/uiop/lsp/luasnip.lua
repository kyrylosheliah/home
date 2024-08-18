return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp"
}

--[[
ls.add_snippets("all", {
	-- today time friendly
	ls.snippet("2dtf", { extras.partial(os.date, "%a %-d %b %Y %H:%M") }),
	-- today timestamp
	ls.snippet("2dt", { extras.partial(os.date, "%Y%m%d%H%M") }),
	-- today
	ls.snippet("2d", { extras.partial(os.date, "%-d %b %Y") }),
	ls.snippet("uuidgen", {
		ls.dynamic_node(1, function()
			return ls.snippet_node(nil,
				ls.text_node(uuid()))
		end)
	}),

	ls.snippet("meta-meet", {
		ls.text_node("* Meeting with "),
		ls.insert_node(1, "PERSON"),
		ls.text_node(" on "), extras.partial(os.date, "%a %-d %b %Y"),
		ls.text_node({"", "\t@meeting.meta"}),
		ls.text_node({"", "\tstarted: "}), extras.partial(os.date, "%a %-d %b %Y %H:%M"),
		ls.text_node({"", "\tend: END"}),
		ls.text_node({"", "\tattendees: "}), ls.insert_node(2, "ATTENDEES"),
		-- ls.text_node({"", "\tattendees: "}), extras.rep(1), ls.insert_node(2, ", "),
		-- ls.text_node({"", "\tattendees: "}), extras.rep(1), ls.insert_node(2, ", "),
		-- ls.insert_node(1, "PERSON"),
		ls.text_node({
			"",
			"\tsalnet task: ",
			"\t@end",
			"",
			"\t*Action Items:*",
			"\t- ( ) ",
			"",
			"\t*Notes:*",
			"  ",
		}),
		-- ls.insert_node(3, "NOTES"),
		ls.insert_node(3, "\t"),
		-- c(3, {
		-- 			t("public "),
		-- 			t("private "),
		-- 		}),
	}),
})

-- ls.add_snippets('markdown', {
-- 	ls.snippet({
-- 		trig = 'link',
-- 		name = 'hyperlink',
-- 		dscr = 'Hyperlink with the content in the clipboard'
-- 	}, {
-- 			ls.text_node '[', ls.insert_node(1, 'text'), ls.text_node ']',
-- 			ls.text_node '(', ls.dynamic_node(2, luasnip_clipboard), ls.text_node ') ',
-- 		})
-- })
]]
