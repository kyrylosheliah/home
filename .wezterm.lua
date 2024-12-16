--if true then return {} end

local wezterm = require("wezterm")
local act = wezterm.action
-- local mux = wezterm.mux
local config = wezterm.config_builder()

config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.colors = {
  cursor_border = "white",
  cursor_bg = "white",
  cursor_fg = "black",
}

-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
--config.front_end = "OpenGL"
config.front_end = "Software"
--config.front_end = "WebGpu"
config.prefer_egl = true -- prefer opengl gpu api
config.max_fps = 60
config.term = "xterm-256color" -- Set the terminal type
config.harfbuzz_features = { 'calt=0' } -- disable font ligatures
local font_size = 15.0
config.font_size = font_size
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
  font_size = font_size,
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
		key = "h",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
		}),
	},
	{
		key = "H",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Left",
		}),
	},
	{
		key = "v",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "V",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Up",
			size = { Percent = 50 },
		}),
	},
	{
		key = 't',
		mods = 'CTRL|ALT',
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = 'q',
		mods = 'CTRL|ALT',
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },

	{
		key = "LeftArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Left", 1 }),
	},
	{
		key = "DownArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Down", 1 }),
	},
	{
		key = "UpArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "RightArrow",
		mods = "CTRL|ALT",
		action = act.AdjustPaneSize({ "Right", 1 }),
	},

  -- Make Page up/down work
	{ key = 'PageUp', action = wezterm.action.ScrollByPage(-1) },
	{ key = 'PageDown', action = wezterm.action.ScrollByPage(1) },

	-- Switch between tabs
	{
		key = 'p',
		mods = 'CTRL|ALT',
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = 'n',
		mods = 'CTRL|ALT',
		action = wezterm.action.ActivateTabRelative(1),
	},

	-- Switch between panes
	{
		key = 'h',
		mods = 'CTRL|ALT',
		action = wezterm.action.ActivatePaneDirection('Left'),
	},
	{
		key = 'l',
		mods = 'CTRL|ALT',
		action = wezterm.action.ActivatePaneDirection('Right'),
	},
	{
		key = 'j',
		mods = 'CTRL|ALT',
		action = wezterm.action.ActivatePaneDirection('Down'),
	},
	{
		key = 'k',
		mods = 'CTRL|ALT',
		action = wezterm.action.ActivatePaneDirection('Up'),
	},

	-- Case-insensitive search
	{
		key = 'F',
		mods = 'CTRL|SHIFT|ALT',
		action = wezterm.action.Search({ CaseInSensitiveString = '' }),
	},

	-- Rename tab title
	{
		key = 'r',
		mods = 'CTRL|ALT',
		action = wezterm.action.PromptInputLine {
			description = 'Enter new name for tab',
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		},
	},

	{
		key = "o",
		mods = "CMD|ALT",
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

--[[
local function get_current_working_dir(tab)
	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = '' }
	local HOME_DIR = string.format('file://%s', os.getenv('HOME'))

	return current_dir == HOME_DIR and '.'
	or string.gsub(current_dir.file_path, '(.*[/\\])(.*)', '%2')
end

-- Set tab title to the one that was set via `tab:set_title()`
-- or fall back to the current working directory as a title
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
	local index = tonumber(tab.tab_index) + 1
	local custom_title = tab.tab_title
	local title = get_current_working_dir(tab)

	if custom_title and #custom_title > 0 then
		title = custom_title
	end

	return string.format('  %s•%s  ', index, title)
end)

-- Set window title to the current working directory
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
	return get_current_working_dir(tab)
end)

-- Set the correct window size at the startup
wezterm.on('gui-startup', function(cmd)
	local active_screen = wezterm.gui.screens()["active"]
	local _, _, window = wezterm.mux.spawn_window(cmd or {})

	-- MacBook Pro 14" 2023
	if active_screen.width <= 3024 then
		-- Laptop: open full screen
		window:gui_window():maximize()
	else
		-- Desktop: place on the right half of the screen
		window:gui_window():set_position(active_screen.width / 2, 0)
		window:gui_window():set_inner_size(active_screen.width / 2, active_screen.height)
	end
end)
]]

return config
