local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.audible_bell = "Disabled"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = "0.5cell",
}

local function font_exists(name)
	local h = io.popen('fc-list "' .. name .. '" 2>/dev/null')
	if h then
		local result = h:read("*a")
		h:close()
		return result ~= "" and result ~= nil
	end
	return false
end

if font_exists("Hack Nerd Font Mono") then
	config.font = wezterm.font("Hack Nerd Font Mono")
end
config.font_size = 11
config.enable_tab_bar = false
config.colors = {
	foreground = "#f6f3e8",
	background = "#000000",

	cursor_bg = "#ffa560",
	cursor_fg = "#000000",
	cursor_border = "#ffa560",

	selection_bg = "#1D1E2C",
	selection_fg = "#f6f3e8",

	ansi = {
		"#4E4E4E",
		"#FF6C60",
		"#A8FF60",
		"#FFFFB6",
		"#96CBFE",
		"#FF73FD",
		"#C6C5FE",
		"#EEEEEE",
	},
	brights = {
		"#7C7C7C",
		"#FFB6B0",
		"#CEFFAB",
		"#FFFFCB",
		"#B5DCFE",
		"#FF9CFE",
		"#DFDFFE",
		"#FFFFFF",
	},
}

return config
