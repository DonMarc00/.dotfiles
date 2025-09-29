return {
	"3rd/image.nvim",
	build = false,
	opts = {
		processor = "magick_cli",
	},
	config = function()
		require("image").setup({
			kitty_method = "normal",
			backend = "kitty",
			processor = "magick_cli",

			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					only_render_image_at_cursor_mode = "popup",
					floating_windows = false,
					filetypes = { "markdown", "vimwiki" },
				},
				neorg = { enabled = true, filetypes = { "norg" } },
				typst = { enabled = true, filetypes = { "typst" } },
				html = { enabled = false },
				css = { enabled = false },
			},

			max_width = nil,
			max_height = nil,
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,

			-- Helpful with tmux splits so images don’t linger/overlap
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },

			editor_only_render_when_focused = false,

			-- If you like correct auto hide/show per tmux window, set this true
			-- and ensure 'visual-activity off' in tmux.conf
			tmux_show_only_in_active_window = true,

			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		})
	end,
}
