--- Custom citation picker for creating Obsidian-style literature notes from BibTeX files
--- Replicates the obsidian-citation-plugin functionality in Neovim

local M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Configuration
M.config = {
	bib_file = vim.fn.expand("~/personal/obsidian/zotero.bib"),
	note_folder = vim.fn.expand("~/personal/obsidian/main/References notes/Papers"),
	title_template = "@{{citekey}}",
	content_template = [[---
title: {{title}}
authors: {{authorString}}
year: {{year}}
doi: https://doi.org/{{DOI}}
aliases: {{title}}
---

# {{title}}

## Abstract
{{abstract}}

## Key takeaways
Remember to think about whether you can trust the methods and/or results:
- *What is your purpose/goal in reading this?*
- *What do the author(s) want to know (motivation)?*
- *What did they do (approach/methods)?*
- *Why was it done that way (context within the field)?*
- *What do the results show (figures and data tables)?*
- *How did the author(s) interpret the results (interpretation/discussion)?*
- *What should be done next/how can you use the results?*
- *Questions that arose due to this?*

## Notes
]],
}

-- Parse a single BibTeX entry
local function parse_bibtex_entry(entry_text)
	local entry = {}

	-- Extract entry type and citekey
	local entry_type, citekey = entry_text:match("@(%w+)%s*{%s*([^,]+)")
	if not citekey then
		return nil
	end

	entry.citekey = citekey:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
	entry.type = entry_type

	-- Extract fields - handle nested braces properly
	local pos = 1
	while pos <= #entry_text do
		-- Match field name and equals sign
		local field_start, field_end, field = entry_text:find("(%w+)%s*=%s*{", pos)
		if not field_start then
			break
		end

		-- Find matching closing brace (handle nested braces)
		local brace_count = 1
		local value_start = field_end + 1
		local i = value_start
		while i <= #entry_text and brace_count > 0 do
			local char = entry_text:sub(i, i)
			if char == "{" then
				brace_count = brace_count + 1
			elseif char == "}" then
				brace_count = brace_count - 1
			end
			i = i + 1
		end

		if brace_count == 0 then
			local value = entry_text:sub(value_start, i - 2)

			-- Clean up the value
			value = value:gsub("{{(.-)}}", "%1") -- Remove BibTeX case preservation {{Text}} -> Text
			value = value:gsub("\\%w+%s*", "") -- Remove LaTeX commands
			value = value:gsub("%s+", " ") -- Normalize whitespace
			value = value:gsub("^%s*(.-)%s*$", "%1") -- Trim

			entry[field:lower()] = value
		end

		pos = i
	end

	-- Handle authors - create authorString
	if entry.author then
		entry.authorString = entry.author
	else
		entry.authorString = ""
	end

	-- Handle year - extract from date field if year doesn't exist
	if not entry.year and entry.date then
		-- Extract year from date (format: YYYY-MM-DD or YYYY)
		entry.year = entry.date:match("^(%d%d%d%d)")
	end

	return entry
end

-- Read and parse BibTeX file
local function read_bib_file(filepath)
	local file = io.open(filepath, "r")
	if not file then
		vim.notify("Could not open bib file: " .. filepath, vim.log.levels.ERROR)
		return {}
	end

	local content = file:read("*all")
	file:close()

	local entries = {}
	-- Match each BibTeX entry (simple pattern - may need refinement)
	for entry_text in content:gmatch("(@%w+%s*{[^@]+)") do
		local entry = parse_bibtex_entry(entry_text)
		if entry then
			table.insert(entries, entry)
		end
	end

	return entries
end

-- Fill template with entry data
local function fill_template(template, entry)
	local result = template

	-- Replace all {{field}} placeholders
	result = result:gsub("{{(%w+)}}", function(field)
		return entry[field:lower()] or ""
	end)

	return result
end

-- Create a literature note from a BibTeX entry
local function create_literature_note(entry)
	-- Generate filename
	local filename = fill_template(M.config.title_template, entry) .. ".md"
	local filepath = M.config.note_folder .. "/" .. filename

	-- Check if note already exists
	local existing = io.open(filepath, "r")
	if existing then
		existing:close()
		vim.notify("Note already exists: " .. filename, vim.log.levels.WARN)
		-- Open the existing note
		vim.cmd("edit " .. filepath)
		return
	end

	-- Create directory if it doesn't exist
	vim.fn.mkdir(M.config.note_folder, "p")

	-- Generate content
	local content = fill_template(M.config.content_template, entry)

	-- Write file
	local file = io.open(filepath, "w")
	if not file then
		vim.notify("Could not create note: " .. filepath, vim.log.levels.ERROR)
		return
	end

	file:write(content)
	file:close()

	-- Open the new note
	vim.cmd("edit " .. filepath)
	vim.notify("Created literature note: " .. filename, vim.log.levels.INFO)
end

-- Create telescope picker
function M.pick_citation(opts)
	opts = opts or {}

	-- Read BibTeX entries
	local entries = read_bib_file(M.config.bib_file)
	if #entries == 0 then
		vim.notify("No entries found in bib file", vim.log.levels.WARN)
		return
	end

	pickers
		.new(opts, {
			prompt_title = "Citations",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					-- Create display string: title | @citekey | authors
					local display = string.format(
						"%s | @%s | %s",
						entry.title or "No title",
						entry.citekey or "unknown",
						entry.author or entry.authorString or "No author"
					)

					return {
						value = entry,
						display = display,
						ordinal = display,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						create_literature_note(selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

-- Setup function
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

return M
