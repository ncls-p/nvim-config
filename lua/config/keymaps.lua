-- Keymaps are automatically loaded on the VeryLazy event

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  if opts.remap and not vim.g.vscode then
    opts.remap = nil
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- clipboard diagnostic
map("n", "<leader>hc", "<cmd>checkhealth clipboard<cr>", { desc = "Check clipboard health" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- location list
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    local count = next and 1 or -1
    local sev = severity and vim.diagnostic.severity[severity] or nil

    -- Check if there are any diagnostics before jumping
    local diagnostics = vim.diagnostic.get(0, sev and { severity = sev } or nil)
    if #diagnostics == 0 then
      vim.notify("No diagnostics found", vim.log.levels.INFO)
      return
    end

    -- Use pcall to handle any errors gracefully
    local ok, err = pcall(vim.diagnostic.jump, {
      count = count,
      severity = sev
    })

    if not ok then
      vim.notify("No more diagnostics in that direction", vim.log.levels.INFO)
    end
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- ⚙️ Enhanced toggle options
map("n", "<leader>uf", function()
  require("config.util").format.toggle()
end, { desc = "📝 Toggle auto format (global)" })
map("n", "<leader>uF", function()
  require("config.util").format.toggle(true)
end, { desc = "📝 Toggle auto format (buffer)" })
map("n", "<leader>us", function()
  require("config.util").toggle("spell")
end, { desc = "✨ Toggle Spelling" })
map("n", "<leader>uw", function()
  require("config.util").toggle("wrap")
end, { desc = "🔄 Toggle Word Wrap" })
map("n", "<leader>uL", function()
  require("config.util").toggle("relativenumber")
end, { desc = "🔢 Toggle Relative Line Numbers" })
map("n", "<leader>ul", function()
  require("config.util").toggle_number()
end, { desc = "🔢 Toggle Line Numbers" })
map("n", "<leader>ud", function()
  require("config.util").toggle_diagnostics()
end, { desc = "🛠️ Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
  require("config.util").toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  map("n", "<leader>uh", function()
    require("config.util").toggle_inlay_hints()
  end, { desc = "Toggle Inlay Hints" })
end
map("n", "<leader>uT", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
end, { desc = "Toggle Treesitter Highlight" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- 🎨 Enhanced clipboard operations (2025 best practices)
-- System clipboard integration with Cmd/Ctrl + Y
map({ "n", "v" }, "<D-y>", '"+y', { desc = "Copy to system clipboard (macOS)" })
map({ "n", "v" }, "<C-y>", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+y$', { desc = "Yank to end of line (system clipboard)" })

-- Paste from system clipboard
map({ "n", "v" }, "<D-p>", '"+p', { desc = "Paste from system clipboard (macOS)" })
map({ "n", "v" }, "<C-S-v>", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste after cursor (system clipboard)" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before cursor (system clipboard)" })

-- Delete without yanking (preserve clipboard)
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
map("v", "<leader>p", '"_dP', { desc = "Replace without yanking" })

-- ✨ Modern aesthetic keymaps
-- Note: <leader>fml and <leader>gol animations are handled by cellular-automaton plugin with safety checks
map("n", "<leader>uz", "<cmd>ZenMode<cr>", { desc = "🧘 Zen Mode" })
map("n", "<leader>ut", "<cmd>Twilight<cr>", { desc = "🌅 Twilight" })
-- 🎨 Theme picker with fallback
map("n", "<leader>uT", function()
  -- Try Themery first, fallback to Telescope
  local ok = pcall(vim.cmd, "Themery")
  if not ok then
    require("telescope.builtin").colorscheme({ enable_preview = true })
  end
end, { desc = "🎨 Theme picker with live preview" })

-- 🔄 Quick theme toggle disabled - using Themery persistence instead
-- Use <leader>ut for Themery theme picker

-- 🔍 Telescope colorscheme picker (always available)
map("n", "<leader>uc", function()
  local ok, _ = pcall(function()
    require("telescope.builtin").colorscheme({
      enable_preview = true,
      ignore_builtins = true,
    })
  end)
  if not ok then
    -- Fallback without preview if there are issues
    require("telescope.builtin").colorscheme({ enable_preview = false })
  end
end, { desc = "🔍 Telescope theme picker" })

map("n", "<leader>uw", function() require('window-picker').pick_window() end, { desc = "🧺 Pick window" })

