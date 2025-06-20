# Modern Neovim Configuration (2025)

A modern, well-structured Neovim configuration based on the latest trends and best practices for 2025.

## ✨ Features

### 🔧 Core
- **Plugin Manager**: lazy.nvim (fast startup with lazy loading)
- **LSP**: Native LSP with Mason for automatic server management  
- **Completion**: blink.cmp (fast, modern completion engine)
- **Syntax**: Treesitter for modern syntax highlighting
- **UI**: Modern rounded borders throughout interface
- **Scrolling**: Smooth scrolling with cinnamon.nvim

### 🎯 Essential Plugins
- **Telescope**: Fuzzy finder for files, grep, and more
- **Neo-tree**: Modern file explorer
- **Oil.nvim**: Buffer-based file operations
- **Bufferline**: Modern buffer/tab management with visual indicators
- **ToggleTerm**: Advanced terminal management with floating windows
- **Which-key**: Interactive keybinding help
- **Gitsigns**: Git integration with signs and hunks
- **Lualine**: Beautiful status line
- **Noice**: Enhanced UI for messages and popups


### ⚡ Enhanced Navigation & Editing
- **Flash.nvim**: Lightning-fast code navigation with labels
- **Git-conflict**: Visual merge conflict resolution
- **Diffview**: Advanced git diff and merge tool
- **nvim-bqf**: Enhanced quickfix list
- **Align.nvim**: Smart text alignment

### 🤖 AI Integration
- **Claude Code CLI**: Terminal integration for Claude Code CLI tool in Neovim

### 🎨 Theme Management
- **colorbox.nvim** - Automatic theme collection and management (800+ high-quality themes)
- **10 Pre-configured Premium Themes**: Tokyo Night, Catppuccin, Kanagawa, Nightfox, Rose Pine, Onedark, Oxocarbon, Everforest, Gruvbox, Nord
- **Smart filtering** - Only includes themes with 800+ GitHub stars
- **Theme shuffling** - Quickly try new themes with a keypress

## ⌨️ Key Bindings

### Leader Key: `<Space>`

#### File Operations
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fr` - Recent files
- `<leader>fb` - Open buffers
- `<leader>e` - Toggle file explorer (Neo-tree)
- `<leader>o` - Open Oil (buffer-based file manager)
- `<leader>O` - Open Oil in float

#### LSP & Code
- `gd` - Go to definition
- `<leader>lr` - Go to references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format code
- `<leader>cl` - LSP info

#### Git
- `]h` / `[h` - Next/prev git hunk
- `<leader>ghs` - Stage hunk
- `<leader>ghr` - Reset hunk
- `<leader>ghp` - Preview hunk
- `<leader>gd` - Open Diffview
- `<leader>gh` - File history
- `<leader>gco` / `<leader>gct` - Choose ours/theirs (conflicts)
- `]x` / `[x` - Next/prev conflict

#### Terminal Management
- `<Ctrl+\>` - Toggle floating terminal
- `<leader>tf` - Toggle floating terminal
- `<leader>th` - Toggle horizontal terminal
- `<leader>tv` - Toggle vertical terminal
- `<leader>tt` - Toggle terminal in new tab
- `<leader>ta` - Toggle all terminals
- `<leader>tk` - Kill all terminals

#### Claude Code & Development Tools
- `<leader>cc` - Open Claude Code in floating terminal
- `<leader>cC` - Open Claude Code with --continue flag
- `<leader>gg` - Toggle Lazygit
- `<leader>tn` - Toggle Node.js REPL
- `<leader>tp` - Toggle Python REPL

#### Terminal Navigation (in terminal mode)
- `<Esc>` or `jk` - Exit terminal mode
- `<Ctrl+h/j/k/l>` - Navigate between windows from terminal


#### Enhanced Navigation
- `s` - Flash jump (any character)
- `S` - Flash treesitter jump
- `aa` - Align to character (visual mode)
- `as` - Align to string (visual mode)

#### Buffer Management
- `<Tab>` / `<S-Tab>` - Next/previous buffer (bufferline)
- `<leader>fb` - Find buffers (Telescope)
- `<leader>bd` - Delete buffer
- `<leader>bb` - Switch to other buffer
- `<leader>bp` - Toggle pin buffer
- `<leader>bo` - Close other buffers
- `<leader>br` / `<leader>bl` - Close buffers to right/left
- `<leader>b1-5` - Go to buffer 1-5 directly

#### Clipboard Operations (Enhanced)
- `<Cmd+Y>` / `<Ctrl+Y>` - Copy to system clipboard
- `<leader>y` - Yank to system clipboard
- `<leader>Y` - Yank to end of line (system clipboard)
- `<leader>p` / `<leader>P` - Paste from system clipboard
- `<leader>d` - Delete without yanking (preserve clipboard)

#### Window Management
- `<C-h/j/k/l>` - Navigate between windows
- `<leader>w-` - Split horizontally
- `<leader>w|` - Split vertically

#### Theme Management
- `<leader>uc` - Shuffle to random theme
- `<leader>uC` - Select theme from list

## 🚀 Installation

The configuration is already set up in `~/.config/nvim/`. When you first start Neovim, it will:

1. Automatically bootstrap lazy.nvim
2. Install all plugins
3. Set up LSP servers via Mason
4. Configure syntax highlighting with Treesitter

## 📁 Structure

```
~/.config/nvim/
├── init.lua                    # Entry point with lazy.nvim bootstrap
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # Auto commands
│   │   ├── keymaps.lua         # Key mappings  
│   │   ├── options.lua         # Vim options
│   │   └── util.lua            # Utility functions
│   └── plugins/
│       ├── blink-cmp.lua       # Modern completion engine
│       ├── bufferline.lua      # Modern buffer/tab management
│       ├── claude-code.lua     # AI coding assistant
│       ├── coding.lua          # Snippets, text objects, etc.
│       ├── colorscheme.lua     # Themes (Tokyo Night, Catppuccin)
│       ├── editor.lua          # File management, search, which-key
│       ├── enhanced-editing.lua # Advanced editing tools
│       ├── lsp.lua             # LSP configuration with Mason
│       ├── mini.lua            # Mini.icons for modern icons
│       ├── smooth-scroll.lua   # Smooth scrolling with cinnamon.nvim
│       ├── terminal.lua        # Terminal management with toggleterm.nvim
│       ├── theme-manager.lua   # Modern theme management with colorbox.nvim
│       ├── treesitter.lua      # Syntax highlighting
│       └── ui.lua              # Status line, notifications, dashboard
└── README.md                   # This documentation
```

## 🔧 Customization

### Setting up Claude Code CLI Integration
1. Ensure you have the Claude Code CLI installed and available in your PATH
2. The plugin will automatically open Claude Code in a terminal window
3. File changes made by Claude Code are automatically detected and reloaded

### Adding LSP Servers
Edit `lua/plugins/lsp.lua` and add servers to the `ensure_installed` list in Mason configuration.

### Managing Themes
- Run `<leader>uc` to shuffle through high-quality themes
- Run `<leader>uC` to select from a list
- colorbox.nvim automatically downloads and manages 800+ themes
- To update theme collection: `:lua require("colorbox").update()`

### Adding Plugins
Create new plugin specifications in the appropriate file under `lua/plugins/` or create new plugin files.

## 🎯 Performance

This configuration is optimized for fast startup times through:
- Lazy loading of plugins
- Minimal core configuration
- Efficient plugin selection
- Disabled unused built-in plugins

First startup may take longer due to plugin installation, but subsequent starts should be very fast.

## 📖 Learning

- Use `<leader>fh` to search help tags
- `<leader>fk` to browse keymaps
- `:Lazy` to manage plugins
- `:Mason` to manage LSP servers
- Press `<leader>` and wait to see available bindings

Enjoy your modern Neovim setup! 🎉
