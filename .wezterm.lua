--if true then return {} end

local wezterm = require("wezterm")
local act = wezterm.action
-- local mux = wezterm.mux
local config = wezterm.config_builder()

-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
-- config.front_end = "WebGpu"

--config.front_end = "OpenGL"
config.front_end = "Software"
--config.front_end = "WebGpu"
config.prefer_egl = true -- prefer opengl gpu api
config.max_fps = 60
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type
config.harfbuzz_features = { 'calt=0' } -- disable font ligatures
config.font_size = 15.0
local font_name = "IosevkaTerm Nerd Font Mono"
--config.font = wezterm.font(font_name)
config.font = wezterm.font_with_fallback({
  { family = font_name },
  { family = "Consolas" },
  { family = "Ubuntu" },
})
--config.cell_width = 0.9
local opacity = 0.5
config.window_background_opacity = opacity
config.win32_system_backdrop = "Acrylic"
--"Auto" - the system chooses. In practice, this is the same as "Disable". Is default.
--"Disable" - disable backdrop effects.
--"Acrylic" - enable the Acrylic blur-behind-window effect. Available on Windows 10 and 11.
--"Mica" - enable the Mica effect, available on Windows 11 build 22621 and later.
--"Tabbed" - enable the Tabbed effect, available on Windows 11 build 22621 and later.

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- tabs
--config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- config.inactive_pane_hsb = {
-- 	saturation = 0.0,
-- 	brightness = 1.0,
-- }

config.window_frame = {
	font = wezterm.font({ family = font_name, weight = "Regular" }),
  --font_size = 15,
}

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
--config.window_decorations = "RESIZE" --"NONE | RESIZE"
--config.window_decorations = "TITLE | RESIZE"
config.default_prog = { "powershell.exe", "-NoLogo" }
config.initial_cols = 120

-- wezterm.on("gui-startup", function(cmd)
-- 	local args = {}
-- 	if cmd then
-- 		args = cmd.args
-- 	end
--
-- 	local tab, pane, window = mux.spawn_window(cmd or {})
-- 	-- window:gui_window():maximize()
-- 	-- window:gui_window():set_position(0, 0)
-- end)

-- keymaps
config.keys = {
	--[[{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},]]
	{
		key = "H",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = opacity
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- For example, changing the color scheme:
--[[
config.color_scheme = "Cloud (terminal.sexy)"
config.colors = {
	-- background = '#3b224c',
	-- background = "#181616", -- vague.nvim bg
	-- background = "#080808", -- almost black
	background = "#0c0b0f", -- dark purple
	-- background = "#020202", -- dark purple
	-- background = "#17151c", -- brighter purple
	-- background = "#16141a",
	-- background = "#0e0e12", -- bright washed lavendar
	-- background = 'rgba(59, 34, 76, 100%)',
	cursor_border = "#bea3c7",
	-- cursor_fg = "#281733",
	cursor_bg = "#bea3c7",
	-- selection_fg = '#281733',

	tab_bar = {
		background = "#0c0b0f",
		-- background = "rgba(0, 0, 0, 0%)",
		active_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#bea3c7",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#f8f2f5",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		new_tab = {
			-- bg_color = "rgba(59, 34, 76, 50%)",
			bg_color = "#0c0b0f",
			fg_color = "white",
		},
	},
}
]]

return config
