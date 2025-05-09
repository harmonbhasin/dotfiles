local function tokens(num)
	return num * 1024
end

return require("avante").setup({
	provider = "openai",
	openai = {
		endpoint = "https://api.openai.com/v1",
		model = "gpt-4.1-mini", -- your desired model (or use gpt-4o, etc.)
		timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
		temperature = 0,
		max_completion_tokens = tokens(32), -- Increase this to include reasoning tokens (for reasoning models)
		--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
	},
	gemini = {
		-- @see https://ai.google.dev/gemini-api/docs/models/gemini
		model = "gemini-2.5-pro-exp-03-25",
		temperature = 0,
		max_tokens = tokens(32),
	},
	claude = {
		endpoint = "https://api.anthropic.com",
		model = "claude-3-5-sonnet-20241022",
		temperature = 0,
		max_tokens = tokens(32),
	},
	vendors = {
		["claude:3.7"] = {
			__inherited_from = "claude",
			model = "claude-3-7-sonnet-20250219",
			max_tokens = tokens(32),
		},
		["openai:gpt-4.1-nano"] = {
			__inherited_from = "openai",
			model = "gpt-4.1-nano",
			max_tokens = tokens(32),
		},
		["openai:gpt-4.1"] = {
			__inherited_from = "openai",
			model = "gpt-4.1",
			max_tokens = tokens(32),
		},
		["openai:o3"] = {
			__inherited_from = "openai",
			model = "o3",
			max_tokens = tokens(32),
		},
		["openai:o4-mini"] = {
			__inherited_from = "openai",
			model = "o4-mini",
			max_tokens = tokens(32),
		},
		["gemini:2.0-flash"] = {
			__inherited_from = "gemini",
			model = "gemini-2.0-flash",
			max_tokens = tokens(32),
		},
		["gemini:2.5-flash-preview"] = {
			__inherited_from = "gemini",
			model = "gemini-2.5-flash-preview-04-17",
			max_tokens = tokens(32),
		},
	},
	behaviour = {
		auto_suggestions = false, -- Experimental stage
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = false,
		minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
		enable_token_counting = true, -- Whether to enable token counting. Default to true.
		enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
		enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
	},
	hints = { enabled = true },
	windows = {
		---@type "right" | "left" | "top" | "bottom"
		position = "right", -- the position of the sidebar
		wrap = true, -- similar to vim.o.wrap
		width = 30, -- default % based on available width
		sidebar_header = {
			enabled = true, -- true, false to enable/disable the header
			align = "center", -- left, center, right for title
			rounded = true,
		},
		input = {
			prefix = "> ",
			height = 8, -- Height of the input window in vertical layout
		},
		edit = {
			border = "rounded",
			start_insert = true, -- Start insert mode when opening the edit window
		},
		ask = {
			floating = false, -- Open the 'AvanteAsk' prompt in a floating window
			start_insert = true, -- Start insert mode when opening the ask window
			border = "rounded",
			---@type "ours" | "theirs"
			focus_on_apply = "ours", -- which diff to focus after applying
		},
	},
	highlights = {
		---@type AvanteConflictHighlights
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},
	--- @class AvanteConflictUserConfig
	diff = {
		autojump = true,
		---@type string | fun(): any
		list_opener = "copen",
		--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
		--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
		--- Disable by setting to -1.
		override_timeoutlen = 500,
	},
	suggestion = {
		debounce = 600,
		throttle = 600,
	},
})
