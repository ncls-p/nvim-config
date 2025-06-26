# Modern Neovim Configuration (2025)

A highly optimized, feature-rich Neovim configuration built with lazy.nvim for blazing-fast startup times and modern development workflows. This configuration provides a complete IDE experience with LSP support, AI integration, and over 800 curated themes.

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

### Prerequisites

- **Neovim**: v0.10.0 or higher
- **Git**: For plugin management
- **Node.js**: v16+ (for many LSP servers and tools)
- **Python 3**: For Python development and some tools
- **ripgrep**: For fast searching (required)
- **fd**: For file finding (optional but recommended)
- **A Nerd Font**: For icons and symbols (recommended: JetBrainsMono Nerd Font)

### Quick Install

1. **Backup your existing configuration** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone https://github.com/ncls-p/nvim-config ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

   On first launch, the configuration will:
   - Bootstrap lazy.nvim plugin manager
   - Install all plugins automatically
   - Install LSP servers via Mason
   - Download and configure Treesitter parsers
   - Set up the theme collection

### Platform-Specific Instructions

#### macOS
```bash
# Install prerequisites
brew install neovim ripgrep fd node python@3.12

# Install a Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

#### Ubuntu/Debian
```bash
# Add Neovim PPA for latest version
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

# Install prerequisites
sudo apt install neovim ripgrep fd-find nodejs npm python3 python3-pip

# Install a Nerd Font manually from:
# https://www.nerdfonts.com/font-downloads
```

#### Arch Linux
```bash
# Install prerequisites
sudo pacman -S neovim ripgrep fd nodejs npm python python-pip

# Install a Nerd Font
yay -S ttf-jetbrains-mono-nerd
```

### Post-Installation

1. **Check health**:
   ```vim
   :checkhealth
   ```

2. **Install additional tools** (optional):
   ```bash
   # Lazygit for git integration
   brew install lazygit  # macOS
   # or see: https://github.com/jesseduffield/lazygit#installation
   
   # Claude Code CLI for AI assistance
   # See: https://docs.anthropic.com/en/docs/claude-code
   ```

3. **Sync plugins** (if needed):
   ```vim
   :Lazy sync
   ```

## 📁 Structure

```
~/.config/nvim/
├── init.lua                    # Entry point with lazy.nvim bootstrap
├── lazy-lock.json              # Plugin version lock file
├── CLAUDE.md                   # Instructions for Claude Code AI
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── autocmds.lua        # Auto commands
│   │   ├── keymaps.lua         # Global key mappings  
│   │   ├── options.lua         # Neovim options
│   │   ├── theme-init.lua      # Theme initialization
│   │   └── util.lua            # Utility functions
│   └── plugins/                # Plugin specifications (23 modules)
│       ├── lsp.lua             # LSP configuration with Mason
│       ├── blink-cmp.lua       # Modern completion engine
│       ├── editor.lua          # Telescope, Neo-tree, Oil.nvim
│       ├── terminal.lua        # Terminal management
│       ├── ui.lua              # UI enhancements
│       ├── git.lua             # Git integration
│       ├── treesitter.lua      # Syntax highlighting
│       ├── theme-manager.lua   # 800+ theme collection
│       ├── claude-code.lua     # Claude Code integration
│       └── ...                 # Other specialized modules
└── README.md                   # This documentation
```

## 🔧 Customization

### Claude Code CLI Integration

1. **Install Claude Code CLI**:
   ```bash
   # Visit: https://docs.anthropic.com/en/docs/claude-code
   # Follow installation instructions for your platform
   ```

2. **Verify installation**:
   ```bash
   claude --version
   ```

3. **Usage in Neovim**:
   - `<leader>cc` - Open Claude Code in floating terminal
   - `<leader>cC` - Continue previous conversation
   - `<leader>cV` - Verbose mode
   - File changes are automatically detected and buffers refreshed

### Adding LSP Servers

1. **Via Mason UI** (recommended):
   ```vim
   :Mason
   ```
   Then press `i` on any server to install.

2. **Via configuration**:
   Edit `lua/plugins/lsp.lua` and add to the `servers` table:
   ```lua
   opts.servers.rust_analyzer = {
     settings = {
       ["rust-analyzer"] = {
         -- server-specific settings
       }
     }
   }
   ```

### Managing Themes
- Run `<leader>uc` to shuffle through high-quality themes
- Run `<leader>uC` to select from a list
- colorbox.nvim automatically downloads and manages 800+ themes
- To update theme collection: `:lua require("colorbox").update()`

### Adding Plugins
Create new plugin specifications in the appropriate file under `lua/plugins/` or create new plugin files.

## 🎯 Performance

This configuration is optimized for fast startup times:

- **Startup time**: ~50-100ms (after initial setup)
- **Lazy loading**: Plugins load only when needed
- **Minimal core**: Only essential plugins at startup
- **Disabled builtins**: Unnecessary Neovim plugins disabled

### Performance Tips

1. **Profile startup**:
   ```vim
   :Lazy profile
   ```

2. **Check loaded plugins**:
   ```vim
   :Lazy
   ```

3. **Debug slow operations**:
   ```vim
   :lua vim.cmd('profile start profile.log')
   :lua vim.cmd('profile func *')
   :lua vim.cmd('profile file *')
   " Do some operations
   :lua vim.cmd('profile stop')
   ```

## 🆘 Troubleshooting

### Common Issues

1. **Icons not displaying**:
   - Install a Nerd Font and configure your terminal to use it

2. **LSP not working**:
   ```vim
   :LspInfo
   :LspLog
   :Mason
   ```

3. **Plugins not loading**:
   ```vim
   :Lazy sync
   :Lazy clean
   ```

4. **Performance issues**:
   ```vim
   :checkhealth
   :Lazy profile
   ```

### Getting Help

- **Built-in help**: `<leader>fh` to search help tags
- **Keybindings**: `<leader>fk` to browse all keymaps
- **Which-key**: Press `<leader>` and wait for hints
- **Plugin info**: `:Lazy` to see all plugins
- **LSP status**: `:LspInfo` for current buffer

## 📖 Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim Guide](https://github.com/folke/lazy.nvim)
- [Mason LSP Registry](https://mason-registry.dev/registry/list)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

---

Enjoy your modern Neovim setup! 🚀
