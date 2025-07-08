# Minimalist Neovim Configuration

A clean, fast, and modern Neovim configuration focused on essential features for productive development.

## ✨ Features

### Core
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Modern plugin management
- **File Management**: [oil.nvim](https://github.com/stevearc/oil.nvim) - Edit directories like buffers
- **Fuzzy Finding**: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Extensible fuzzy finder
- **Syntax Highlighting**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Advanced syntax highlighting

### AI Integration
- **[Claude Code](https://github.com/greggh/claude-code.nvim)** - Claude AI integration (leader cc)
- **[CodeCompanion](https://github.com/olimorris/codecompanion.nvim)** - AI pair programming
- **[Minuet AI](https://github.com/milanglacier/minuet-ai.nvim)** - AI-powered code completion

### LSP & Completion
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - Native LSP configuration
- **[Mason](https://github.com/williamboman/mason.nvim)** - LSP server management
- **[blink.cmp](https://github.com/Saghen/blink.cmp)** - Fast completion engine

### UI
- **Theme Manager**: [themery.nvim](https://github.com/zaldih/themery.nvim) - Advanced theme switcher with persistence
- **Transparency**: [transparent.nvim](https://github.com/xiyaowong/transparent.nvim) - Transparent background support
- **Themes**: 
  - [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - Clean, modern colorscheme (4 variants)
  - [onenord.nvim](https://github.com/rmehri01/onenord.nvim) - Nord-inspired theme
  - [oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim) - Dark, IBM Carbon-inspired theme
- **Dashboard**: [alpha-nvim](https://github.com/goolord/alpha-nvim) - Beautiful animated landing page
- **Statusline**: [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Fast and customizable
- **Bufferline**: [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer tabs
- **Notifications**: [nvim-notify](https://github.com/rcarriga/nvim-notify) - Beautiful notifications

### Editor Enhancements
- **[mini.nvim](https://github.com/echasnovski/mini.nvim)** modules:
  - `mini.surround` - Surround actions
  - `mini.ai` - Extended text objects
  - `mini.pairs` - Auto pairs
  - `mini.comment` - Smart commenting
- **[multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim)** - Multiple cursors
- **[neoscroll.nvim](https://github.com/karb94/neoscroll.nvim)** - Smooth scrolling
- **[smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)** - Smooth cursor animations
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git integration

### Tools
- **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)** - Terminal management
- **[remote-ssh.nvim](https://github.com/inhesrom/remote-ssh.nvim)** - Remote file editing
- **[trouble.nvim](https://github.com/folke/trouble.nvim)** - Diagnostics list

## 📋 Requirements

- Neovim ≥ 0.10.0
- Git
- [ripgrep](https://github.com/BurntSushi/ripgrep) - For searching
- Node.js ≥ 18 - For LSP servers
- Python 3 - For Python development
- A [Nerd Font](https://www.nerdfonts.com/) - For icons

### Optional
- [fd](https://github.com/sharkdp/fd) - Better file finding
- [Claude Code CLI](https://claude.ai/download) - For AI features

## 🚀 Installation

### Quick Install

```bash
# Clone this config
git clone https://github.com/YOUR_USERNAME/nvim-config ~/.config/nvim

# Run the installer
cd ~/.config/nvim && ./install.sh
```

### Manual Installation

1. **Backup existing config**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/nvim-config ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```
   
   Plugins will install automatically on first launch.

## ⌨️ Key Mappings

### Leader Key
The leader key is set to `<Space>`.

### Essential Mappings

| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Browse buffers |
| `<leader>fh` | Help tags |
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |

### File Management
| Key | Description |
|-----|-------------|
| `<leader>o` | Open Oil file manager |
| `<leader>O` | Oil in floating window |
| `<leader>e` | Toggle Neo-tree |

### AI Features
| Key | Description |
|-----|-------------|
| `<leader>cc` | Claude Code |
| `<leader>cC` | Claude Code Continue |
| `<leader>ca` | Code Companion chat |

### Terminal
| Key | Description |
|-----|-------------|
| `<leader>tT` | Floating terminal (toggle) |
| `<leader>tt` | Terminal in buffer |
| `<C-\>` | Toggle terminal |

### UI
| Key | Description |
|-----|-------------|
| `<leader>uT` | Theme manager (Themery) |
| `<leader>ut` | Toggle transparency |
| `<leader>un` | Dismiss notifications |

### LSP
| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>cf` | Format buffer |
| `<leader>cd` | Line diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Git
| Key | Description |
|-----|-------------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line |

## 📁 Configuration Structure

```
~/.config/nvim/
├── init.lua                  # Main configuration entry
├── lua/
│   ├── config/              # Core configuration
│   │   ├── options.lua      # Neovim options
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── autocmds.lua     # Auto commands
│   │   └── ...
│   └── plugins/             # Plugin configurations
│       ├── core.lua         # Essential plugins
│       ├── completion/      # Completion plugins
│       ├── editor/          # Editor enhancements
│       ├── lsp/            # LSP configuration
│       ├── ui/             # UI plugins
│       └── tools/          # External tools
├── lazy-lock.json          # Plugin version lock
├── install.sh             # Installation script
└── README.md              # This file
```

## 🔧 Customization

### Adding Plugins

Create a new file in `lua/plugins/` or add to an existing category:

```lua
-- lua/plugins/my-plugin.lua
return {
  "username/plugin-name",
  event = "VeryLazy",  -- Lazy load
  opts = {
    -- Plugin options
  },
}
```

### Modifying Options

Edit `lua/config/options.lua` to change Neovim settings.

### Custom Keymaps

Add keymaps to `lua/config/keymaps.lua` or within plugin configurations.

## 🏃 Performance

This configuration is optimized for fast startup:
- Lazy loading of plugins
- Minimal UI overhead
- Efficient plugin selection
- Modern completion engine (blink.cmp)

To check startup time:
```vim
:Lazy profile
```

## 🐛 Troubleshooting

### Health Check
Run `:checkhealth` to diagnose issues.

### Common Issues

1. **Icons not displaying**: Install a [Nerd Font](https://www.nerdfonts.com/)
2. **LSP not working**: Run `:Mason` and install servers
3. **Slow completion**: Ensure you have Node.js ≥ 18

### Reset Configuration
```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

## 📄 License

This configuration is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🙏 Acknowledgments

This configuration is built on the excellent work of the Neovim community and plugin authors.