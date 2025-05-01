require("codecompanion").setup({
	adapters = {
		openai = function()
			return require("codecompanion.adapters").extend("openai", {
				name = "openai",
				schema = {
					model = {
						default = "o4-mini",
						choices = {
							"gpt-4.1-mini",
							"gpt-4.1-nano",
							"gpt-4.1",
							"gpt-4.5-preview",
							["o4-mini"] = { opt = { can_reason = true } },
							["o1"] = { opt = { can_reason = true } },
						},
					},
					max_completion_tokens = {
						default = 200000,
						optional = true,
					},
				},
			})
		end,
		gemini = function()
			return require("codecompanion.adapters").extend("gemini", {
				name = "gemini",
				schema = {
					model = {
						default = "gemini-2.5-pro-exp-03-25",
						choices = {
							["gemini-2.5-flash-preview-04-17"] = { opt = { can_reason = true } },
							"gemini-2.5-pro-exp-03-25",
							"gemini-2.0-flash",
						},
					},
					max_completion_tokens = {
						default = 500000,
						optional = true,
					},
				},
			})
		end,
	},
	strategies = {
		chat = {
			adapter = "gemini",
		},
		inline = {
			adapter = "gemini",
			keymaps = {
				accept_change = {
					modes = { n = "ga" },
					description = "Accept the suggested change",
				},
				reject_change = {
					modes = { n = "gr" },
					description = "Reject the suggested change",
				},
			},
		},
		cmd = {
			adapter = "openai",
		},
	},
	display = {
		action_palette = {
			width = 95,
			height = 10,
			prompt = "Prompt ", -- Prompt used for interactive LLM calls
			provider = "default", -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
			opts = {
				show_default_actions = true, -- Show the default actions in the action palette?
				show_default_prompt_library = true, -- Show the default prompt library in the action palette?
			},
		},
	},
})
