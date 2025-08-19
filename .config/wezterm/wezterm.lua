--if true then return {} end

local wezterm = require("wezterm")
local act = wezterm.action
-- local mux = wezterm.mux

local is_windows = wezterm.target_triple:find("windows")

local config = wezterm.config_builder()

config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.colors = {
  cursor_border = "white",
  cursor_bg = "white",
  cursor_fg = "black",
}

config.adjust_window_size_when_changing_font_size = false

-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
config.front_end = "OpenGL"
--config.front_end = "Software"
--config.front_end = "WebGpu"
config.prefer_egl = true -- prefer opengl gpu api
config.max_fps = 60
config.term = "xterm-256color" -- Set the terminal type
config.harfbuzz_features = { 'calt=0' } -- disable font ligatures
local font_size = 15.0
config.font_size = font_size
--config.font = wezterm.font(font_name)
local font_name = ""
if is_windows then
  font_name = "Iosevka Fixed"
else
  font_name = "Iosevka Nerd Font"
end
config.font = wezterm.font_with_fallback({
  { family = font_name, weight = 400 },
  { family = "Consolas" },
  { family = "Ubuntu" },
})
config.font_rules = {
  {
    intensity = "Bold", font = wezterm.font_with_fallback({
      { family = font_name, weight = 900 },
      { family = "Consolas" },
      { family = "Ubuntu" },
    })
  },
}
--config.cell_width = 0.9

if is_windows then
  local opacity = 0.5
  config.window_background_opacity = opacity
  config.win32_system_backdrop = "Acrylic"
  --"Auto" - the system chooses. In practice, this is the same as "Disable". Is default.
  --"Disable" - disable backdrop effects.
  --"Acrylic" - enable the Acrylic blur-behind-window effect. Available on Windows 10 and 11.
  --"Mica" - enable the Mica effect, available on Windows 11 build 22621 and later.
  --"Tabbed" - enable the Tabbed effect, available on Windows 11 build 22621 and later.
end

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- tabs
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

config.inactive_pane_hsb = {
  saturation = 0.0,
  brightness = 0.5,
}

config.window_frame = {
  font = wezterm.font({ family = font_name, weight = 900 }),
  font_size = font_size,
}

config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
--config.window_decorations = "RESIZE" --"NONE | RESIZE"
--config.window_decorations = "TITLE | RESIZE"
if is_windows then
  config.default_prog = { "pwsh.exe", "-NoLogo" }
else
  config.default_prog = { "/bin/bash" }
end
config.initial_cols = 120

-- wezterm.on("gui-startup", function(cmd)
-- local args = {}
-- if cmd then
--   args = cmd.args
-- end
--
--  local tab, pane, window = mux.spawn_window(cmd or {})
--  -- window:gui_window():maximize()
--  -- window:gui_window():set_position(0, 0)
-- end)

-- keymaps
config.keys = {
  { key = "L", mods = "SHIFT|ALT", action = act.ShowDebugOverlay },

  --[[{
    key = "E",
    mods = "SHIFT|ALT",
    action = wezterm.action.EmitEvent("toggle-colorscheme"),
  },]]
  {
    key = "s",
    mods = "ALT",
    action = wezterm.action.SplitPane({
      direction = "Right",
    }),
  },
  {
    key = "S",
    mods = "SHIFT|ALT",
    action = wezterm.action.SplitPane({
      direction = "Left",
    }),
  },
  {
    key = "v",
    mods = "ALT",
    action = wezterm.action.SplitPane({
      direction = "Down",
      size = { Percent = 50 },
    }),
  },
  {
    key = "V",
    mods = "SHIFT|ALT",
    action = wezterm.action.SplitPane({
      direction = "Up",
      size = { Percent = 50 },
    }),
  },
  {
    key = 't',
    mods = 'ALT',
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = 'q',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
  { key = "p", mods = "ALT", action = act.PaneSelect },

  {
    key = "LeftArrow",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Left", 1 }),
  },
  {
    key = "DownArrow",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Down", 1 }),
  },
  {
    key = "UpArrow",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Up", 1 }),
  },
  {
    key = "RightArrow",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Right", 1 }),
  },

  -- Make Page up/down work
  { key = 'PageUp', action = wezterm.action.ScrollByPage(-1) },
  { key = 'PageDown', action = wezterm.action.ScrollByPage(1) },

  -- Switch between tabs
  {
    key = 'n',
    mods = 'ALT',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'p',
    mods = 'ALT',
    action = wezterm.action.ActivateTabRelative(-1),
  },

  -- Switch between panes
  {
    key = 'h',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Left'),
  },
  {
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Right'),
  },
  {
    key = 'j',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Down'),
  },
  {
    key = 'k',
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection('Up'),
  },

  -- Case-insensitive search
  {
    key = 'F',
    mods = 'SHIFT|ALT',
    action = wezterm.action.Search({ CaseInSensitiveString = '' }),
  },

  -- Rename tab title
  {
    key = 'r',
    mods = 'ALT',
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
    mods = "ALT",
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

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "ALT",
    action = wezterm.action.ActivateTab(i - 1),
  })
end

table.insert(config.keys, {
  key = "0",
  mods = "ALT",
  action = wezterm.action.ActivateTab(-1),
})

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "SHIFT|ALT",
    action = wezterm.action.MoveTab(i - 1),
  })
end

table.insert(config.keys, {
  key = "0",
  mods = "SHIFT|ALT",
  action = wezterm.action.MoveTab(999),
})

--[[
local function current_dir(tab)
  if not tab.active_pane then
    return ""
  end
  local cwd_uri = tab.active_pane.current_working_dir.file_path or "" 
  if not cwd_uri or cwd_uri == "" then
    return ""
  end
  if cwd_uri == "/" then
    return cwd_uri
  end
  -- extract stem from folder path
  local stop_index = -1
  local end_index = #cwd_uri
  local cur_char = string.sub(cwd_uri, end_index, end_index)
  if cur_char == "\\" or cur_char == "/" then
    end_index = end_index - 1
  end
  for i=end_index,1,-1 do
    cur_char = string.sub(cwd_uri, i, i)
    if cur_char == "\\" or cur_char == "/" then
      stop_index = i + 1
      break
    end
  end
  if stop_index == -1 then
    return cwd_uri
  end
  return string.sub(cwd_uri, stop_index, #cwd_uri)
  --local cwd = string.match(cwd_uri, "(?:.*[/\\])*(.*[/\\]?)$")
end

-- Set tab title to the one that was set via `tab:set_title()`
-- or fall back to the current working directory as a title
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local index = tonumber(tab.tab_index) + 1
  local custom_title = tab.tab_title
  local title = ""
  if custom_title and #custom_title > 0 then
    title = custom_title
  else
    title = current_dir(tab)
  end
  return string.format('%s:%s ', index, title)
end)

-- Set window title to the current working directory
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  return current_dir(tab)
end)

wezterm.on('gui-startup', function(cmd)
  local active_screen = wezterm.gui.screens()["active"]
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  -- place on the right half of the screen
  window:gui_window():set_position(active_screen.width / 2, 0)
  window:gui_window():set_inner_size(active_screen.width / 2, active_screen.height)
end)
]]

return config
