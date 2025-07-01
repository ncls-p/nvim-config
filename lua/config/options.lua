-- General
vim.opt.mouse = "a"               -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- macOS clipboard fix
if vim.fn.has("mac") == 1 then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
end

vim.opt.swapfile = false -- Disable swap files
vim.opt.completeopt = "menuone,noinsert,noselect"

-- 🎨 Ultra Modern UI
vim.opt.number = true               -- Show line numbers
vim.opt.relativenumber = false      -- Disable relative line numbers (use classic)
vim.opt.cursorline = true           -- Highlight current line
vim.opt.cursorcolumn = false        -- Don't highlight current column
vim.opt.termguicolors = true        -- True color support
vim.opt.background = "dark"         -- Dark background
vim.opt.signcolumn = "yes"          -- Always show sign column
vim.opt.cmdheight = 0               -- Hide command line when not used
vim.opt.scrolloff = 4               -- Keep 4 lines above/below cursor (better for Ctrl+D/U)
vim.opt.sidescrolloff = 8           -- Keep 8 columns left/right of cursor
vim.opt.smoothscroll = false        -- Disable smooth scrolling for consistent Ctrl+D/U
vim.opt.mousescroll = "ver:1,hor:3" -- Slower, more controlled mouse scroll
vim.opt.pumheight = 15              -- Maximum items in popup menu
vim.opt.pumblend = 10               -- Popup menu transparency
vim.opt.winblend = 0                -- Window transparency

-- ✨ LSP handlers are now configured in lsp.lua - keeping this clean

-- 💫 Better completion menu
vim.opt.completeopt = "menu,menuone,noselect,preview"
vim.opt.shortmess:append("c")

-- Editing
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.shiftwidth = 2     -- Size of an indent
vim.opt.tabstop = 2        -- Number of spaces tabs count for
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.wrap = false       -- Disable line wrap
vim.opt.breakindent = true -- Enable break indent
vim.opt.linebreak = true   -- Wrap on word boundary

-- Search
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true  -- Don't ignore case with capitals
vim.opt.hlsearch = false  -- Don't highlight on search
vim.opt.incsearch = true  -- Incremental search

-- Splits
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitbelow = true -- Put new windows below current

-- ⚡ Enhanced Performance
vim.opt.updatetime = 250   -- Faster completion
vim.opt.timeoutlen = 300   -- Faster which-key popup
vim.opt.undofile = true    -- Persistent undo
vim.opt.undolevels = 10000 -- More undo levels
vim.opt.undoreload = 10000 -- Save more lines for undo
vim.opt.history = 1000     -- More command history
vim.opt.synmaxcol = 300    -- Don't syntax highlight long lines
vim.opt.lazyredraw = false -- Don't redraw during macros
vim.opt.ttyfast = true     -- Fast terminal
vim.opt.regexpengine = 1   -- Use old regex engine

-- Folding (for nvim-ufo)
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Spelling
vim.opt.spelllang = { "en" }

-- 🚀 Disable builtin plugins for faster startup
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_spec = 1

-- 🎭 Enhanced visual settings
vim.opt.conceallevel = 0     -- Don't hide characters
vim.opt.concealcursor = ""   -- Don't hide in cursor line
vim.opt.laststatus = 3       -- Global statusline
vim.opt.showtabline = 2      -- Always show tabline
vim.opt.display = "lastline" -- Show as much as possible
vim.opt.showmode = false     -- Don't show mode in command line
vim.opt.ruler = false        -- Don't show ruler
vim.opt.showcmd = false      -- Don't show command
vim.opt.confirm = true       -- Confirm before closing unsaved

-- 🌈 Color and theme settings
vim.opt.guifont = "JetBrainsMonoNL Nerd Font:h14"
if vim.g.neovide then
  vim.g.neovide_opacity = 0.95
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.3
end

