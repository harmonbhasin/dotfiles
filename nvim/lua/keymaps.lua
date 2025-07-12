-- ABOUTME: Keymaps and autocommands configuration
-- ABOUTME: Contains all vim.keymap.set calls and vim.api.nvim_create_autocmd calls

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
  end
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

-- Debug keybindings
vim.keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Continue Debugging" })
vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle Debug UI" })
vim.keymap.set("n", "<leader>ds", function()
  require("dap").step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dt", function()
  require("dap").terminate()
end, { desc = "Terminate Debug" })

-- Codeium keymaps
vim.keymap.set("i", "<C-g>", function()
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

-- R code block insertion
vim.keymap.set("n", "<leader>rn", function()
  local lines = { "```{r}", "", "```" }
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, lines)
  vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
  vim.cmd("startinsert")
end, { desc = "Insert R code block" })

-- LSP diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })