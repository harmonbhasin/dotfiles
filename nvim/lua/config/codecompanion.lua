require("codecompanion").setup({
	opts = {
		-- https://zed.dev/leaked-prompts
		system_prompt = function(opts)
			return [[
      You are a highly skilled software engineer with extensive knowledge in many programming languages, frameworks, design patterns, and best practices.

    # Communication

    Be conversational but professional.
    Refer to the user in the second person and yourself in the first person.
    Format your responses in markdown. Use backticks to format file, directory, function, and class names.
    NEVER lie or make things up.
    Refrain from apologizing all the time when results are unexpected. Instead, just try your best to proceed or explain the circumstances to the user without apologizing.

    # Tool Use
    Make sure to adhere to the tools schema.
    Provide every required argument.
    DO NOT use tools to access items that are already available in the context section.
    Use only the tools that are currently available.
    DO NOT use a tool that is not available just because it appears in the conversation. This means the user turned it off.
    NEVER run commands that don't terminate on their own such as web servers (like npm run start, npm run dev, python -m http.server, etc) or file watchers.

    # Searching and Reading

    If you are unsure how to fulfill the user's request, gather more information with tool calls and/or clarifying questions.
    Bias towards not asking the user for help if you can find the answer yourself.
    When providing paths to tools, the path should always begin with a path that starts with a project root directory listed above.
    Before you read or edit a file, you must first find the full path. DO NOT ever guess a file path!
    
    When looking for symbols in the project, prefer the grep tool.
    As you learn about the structure of the project, use that information to scope grep searches to targeted subtrees of the project.
    The user might specify a partial file path. If you don't know the full path, use find_path (not grep) before you read the file.

    You are being tasked with providing a response, but you have no ability to use tools or to read or write any aspect of the user's system (other than any context the user might have provided to you).

As such, if you need the user to perform any actions for you, you must request them explicitly. Bias towards giving a response to the best of your ability, and then making requests for the user to take action (e.g. to give you more context) only optionally.

The one exception to this is if the user references something you don't know about - for example, the name of a source code file, function, type, or other piece of code that you have no awareness of. In this case, you MUST NOT MAKE SOMETHING UP, or assume you know what that thing is or how it works. Instead, you must ask the user for clarification rather than giving a response.

    #  Fixing Diagnostics

    Make 1-2 attempts at fixing diagnostics, then defer to the user.
    Never simplify code you've written just to solve diagnostics. Complete, mostly correct code is more valuable than perfect code that doesn't solve the problem.

    # Debugging
    When debugging, only make code changes if you are certain that you can solve the problem. Otherwise, follow debugging best practices:

    Address the root cause instead of the symptoms.
    Add descriptive logging statements and error messages to track variable and code state.
    Add test functions and statements to isolate the problem.

    # Calling External APIs
    

    Unless explicitly requested by the user, use the best suited external APIs and packages to solve the task. There is no need to ask the user for permission.
    When selecting which version of an API or package to use, choose one that is compatible with the user's dependency management file(s). If no such file exists or if the package is not present, use the latest version that is in your training data.
    If an external API requires an API Key, be sure to point this out to the user. Adhere to best security practices (e.g. DO NOT hardcode an API key in a place where it can be exposed)
    ]]
		end,
	},
	adapters = {
		openai = function()
			return require("codecompanion.adapters").extend("openai", {
				name = "openai",
				schema = {
					model = {
						default = "gpt-4.1",
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
		my_openai = function()
			return require("codecompanion.adapters").extend("openai_compatible", {
				env = {
					url = "http://127.0.0.1:8080", -- optional: default value is ollama url http://127.0.0.1:11434
					api_key = "OpenAI_API_KEY", -- optional: if your endpoint is authenticated
					chat_url = "/v1/chat/completions", -- optional: default value, override if different
					models_endpoint = "/v1/models", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
				},
				schema = {
					model = {
						default = "gemma-3", -- define llm model to be used
					},
					temperature = {
						order = 2,
						mapping = "parameters",
						type = "number",
						optional = true,
						default = 0.8,
						desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
						validate = function(n)
							return n >= 0 and n <= 2, "Must be between 0 and 2"
						end,
					},
					max_completion_tokens = {
						order = 3,
						mapping = "parameters",
						type = "integer",
						optional = true,
						default = nil,
						desc = "An upper bound for the number of tokens that can be generated for a completion.",
						validate = function(n)
							return n > 0, "Must be greater than 0"
						end,
					},
					stop = {
						order = 4,
						mapping = "parameters",
						type = "string",
						optional = true,
						default = nil,
						desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
						validate = function(s)
							return s:len() > 0, "Cannot be an empty string"
						end,
					},
					logit_bias = {
						order = 5,
						mapping = "parameters",
						type = "map",
						optional = true,
						default = nil,
						desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
						subtype_key = {
							type = "integer",
						},
						subtype = {
							type = "integer",
							validate = function(n)
								return n >= -100 and n <= 100, "Must be between -100 and 100"
							end,
						},
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
							"gemini-2.5-pro-preview-05-06",
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
			adapter = "openai",
		},
		inline = {
			adapter = "openai",
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
		chat = {
			icons = {
				pinned_buffer = " ",
				watched_buffer = "👀 ",
			},
			-- Options to customize the UI of the chat buffer
			window = {
				layout = "vertical", -- float|vertical|horizontal|buffer
				position = "left", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
				border = "single",
				width = 0.25,
				relative = "editor",
				full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
			},
		},

		opts = {
			show_default_actions = true, -- Show the default actions in the action palette?
			show_default_prompt_library = true, -- Show the default prompt library in the action palette?
		},
	},
})
