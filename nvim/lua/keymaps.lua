-- ABOUTME: Keymaps and autocommands configuration
-- ABOUTME: Contains all vim.keymap.set calls and vim.api.nvim_create_autocmd calls

vim.keymap.set({ 'n', 'v' }, '<C-b>', '<C-a>', { desc = 'Increment number' })

---- Nextflow
-- give highlighting for nf-test files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.nf.test",         -- This is the pattern for files ending in .nf.test
  callback = function()
    vim.bo.filetype = "nextflow" -- Set the filetype to 'nextflow'
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "nextflow",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- Set spell checker for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto" },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = en_us
    vim.opt.spellcapcheck = "none"
  end,
})

-- Disable Codeium for certain file types
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  pattern = { "*.md", "*.txt", ".git-credentials", ".env", ".env.*" },
  command = "CodeiumDisable",
})

-- Oil
vim.keymap.set("n", "<leader>-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- Diffview
vim.api.nvim_set_keymap("n", "<leader>gdd", ":DiffviewOpen<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gdf", ":DiffviewFileHistory %<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gdq", ":DiffviewClose<CR>", { noremap = true, silent = true })

-- Harpoon
vim.keymap.set("n", "<leader>m", function()
  require("harpoon"):list():add()
end)
vim.keymap.set("n", "<leader>e", function()
  require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end)

vim.keymap.set("n", "<leader>h", function()
  require("harpoon"):list():select(1)
end)
vim.keymap.set("n", "<leader>j", function()
  require("harpoon"):list():select(2)
end)
vim.keymap.set("n", "<leader>k", function()
  require("harpoon"):list():select(3)
end)
vim.keymap.set("n", "<leader>l", function()
  require("harpoon"):list():select(4)
end)

-- Buffer list
vim.keymap.set("n", "<C-P>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<C-N>", ":bnext<CR>", { desc = "Next buffer" })

-- Quicker
vim.keymap.set("n", "<leader>q", function()
  require("quicker").toggle()
end, {
  desc = "Toggle quickfix",
})
vim.keymap.set("n", "<leader>w", function()
  require("quicker").toggle({ loclist = true })
end, {
  desc = "Toggle loclist",
})

-- CodeCompanion
vim.keymap.set({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Code Companion Chat" })
vim.keymap.set({ "n", "v" }, "<leader>an", "<cmd>CodeCompanionChat<cr>", { desc = "Open New Code Companion Chat" })
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "Open Code Companion Actions" })

-- Terminal
vim.api.nvim_set_keymap("t", "<Esc><Esc>", [[<C-\><C-n>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>t", ":terminal<CR>", { noremap = true, silent = true })

-- New tab
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabnew<CR>", { noremap = true, silent = true })

-- Obsidian keymaps (only if obsidian is available)
local home = os.getenv("HOME")
local obsidian_path = home .. "/personal/obsidian/main"
local function path_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  else
    return false
  end
end

if path_exists(obsidian_path) then
  vim.keymap.set("n", "<Leader>n/", ":ObsidianSearch<CR>", { desc = "Obsidian Search" })
  vim.keymap.set("n", "<Leader>nff", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian Quick Switch" })
  vim.keymap.set("n", "<Leader>nd", ":ObsidianToday<CR>", { desc = "Obsidian Today" })
  vim.keymap.set("n", "<Leader>ny", ":ObsidianYesterday<CR>", { desc = "Obsidian Yesterday" })
  vim.keymap.set("n", "<Leader>nfl", ":ObsidianFollowLink<CR>", { desc = "Obsidian Follow Link" })
  vim.keymap.set("n", "<Leader>nt", ":ObsidianTOC<CR>", { desc = "Show note table of contents" })
  vim.keymap.set("n", "<leader>nc", function()
    -- Prompt the user for the note title
    local title = vim.fn.input("Enter note title: ")

    -- Check if the user entered a title (didn't press Cancel or leave empty)
    if title and title ~= "" then
      -- Execute the ObsidianNewFromTemplate command with the provided title
      vim.cmd("ObsidianNewFromTemplate " .. title)
    else
      -- Optionally, provide feedback if no title was entered
      print("No title entered, note creation cancelled.")
    end
  end, { desc = "Create new Obsidian note from template with title" })
end

-- Codeium keymaps
vim.keymap.set("i", "<M-Space>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true, silent = true })
vim.keymap.set("i", "<c-;>", function()
  return vim.fn["codeium#CycleCompletions"](1)
end, { expr = true, silent = true })
vim.keymap.set("i", "<c-,>", function()
  return vim.fn["codeium#CycleCompletions"](-1)
end, { expr = true, silent = true })
vim.keymap.set("i", "<c-x>", function()
  return vim.fn["codeium#Clear"]()
end, { expr = true, silent = true })

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>/", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set("n", "<leader>o", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fc", function()
  builtin.lsp_document_symbols({ symbols = { "class", "function", "method" } })
end, { desc = "Find classes and functions in document" })

-- R code block insertion
vim.keymap.set("n", "<leader>rn", function()
  local lines = { "```{r}", "", "```" }
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
  vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
  vim.cmd("startinsert")
end, { desc = "Insert R code block" })

-- bash code block insertion
vim.keymap.set("n", "<leader>bn", function()
  local lines = { "```bash", "", "```" }
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
  vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
  vim.cmd("startinsert")
end, { desc = "Insert bash code block" })

-- Date navigation for YYYY-MM-DD markdown files
local function navigate_date_files(direction)
  -- Get all markdown files in current buffer's directory that match YYYY-MM-DD pattern
  local date_pattern = "%d%d%d%d%-%d%d%-%d%d"
  local files = {}

  -- Always use the directory of the current buffer
  local current_dir = vim.fn.expand("%:p:h")

  -- Use vim.fn.glob to get files instead of shell command
  local glob_pattern = current_dir .. "/*.md"
  local found_files = vim.fn.glob(glob_pattern, false, true)

  -- Filter for date pattern and sort
  for _, file_path in ipairs(found_files) do
    local file_name = vim.fn.fnamemodify(file_path, ":t:r") -- get filename without extension
    if string.match(file_name, date_pattern) then
      table.insert(files, file_path)
    end
  end

  -- Sort the files
  table.sort(files)

  if #files == 0 then
    print("No date-formatted markdown files found")
    return
  end

  -- Find current file index
  local current_file = vim.fn.expand("%:p")
  local current_index = nil
  for i, file in ipairs(files) do
    if file == current_file then
      current_index = i
      break
    end
  end

  if not current_index then
    -- If current file is not a date file, go to first or last based on direction
    if direction == "next" then
      current_index = 0
    else
      current_index = #files + 1
    end
  end

  -- Calculate target index
  local target_index
  if direction == "next" then
    target_index = current_index + 1
    if target_index > #files then
      print("Already at the latest date")
      return
    end
  else -- previous
    target_index = current_index - 1
    if target_index < 1 then
      print("Already at the earliest date")
      return
    end
  end

  -- Open target file
  local target_file = files[target_index]
  vim.cmd("edit " .. target_file)
  print("Navigated to: " .. vim.fn.fnamemodify(target_file, ":t"))
end

vim.keymap.set("n", "<leader>dn", function()
  navigate_date_files("next")
end, { desc = "Next date file" })
vim.keymap.set("n", "<leader>dp", function()
  navigate_date_files("previous")
end, { desc = "Previous date file" })

-- LSP diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })
