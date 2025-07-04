# Modern Neovim Configuration (2025)

A **comprehensive**, **ultra-modern** Neovim setup featuring 80+ plugins, extensive AI integration, 15+ color schemes, and full DevOps tooling. Built for professional development workflows with lightning-fast startup and beautiful UI.

---

## ✨ Features

### 🔧 Core Architecture
- **Plugin Manager**: `lazy.nvim` with aggressive lazy-loading
- **Native LSP**: Neovim 0.11+ API with 15+ language servers
- **Completion**: `blink.cmp` (modern, fast alternative to nvim-cmp)
- **AI Integration**: 3 AI tools (Minuet, CodeCompanion, Aider)
- **Terminal Integration**: Claude Code, OpenCode, lazygit
- **Syntax Highlighting**: `nvim-treesitter` with context support

### 🎨 Visual Excellence
- **15+ Premium Themes**: Tokyo Night, Catppuccin, Kanagawa, Rose Pine, Nightfox, OneDark, Gruvbox, Nord, Everforest, Oxocarbon, Cyberdream, and more
- **Theme Management**: Live preview theme picker with persistence
- **Modern UI**: Rounded borders, floating windows, animated notifications
- **Visual Effects**: Smooth scrolling, cursor animations, startup animations
- **Status Components**: Beautiful lualine, modern bufferline, enhanced notifications

### 🚀 Development Tools
- **Multi-cursor Editing**: Advanced multi-cursor support
- **Search & Replace**: Powerful find/replace interface
- **Git Integration**: Signs, conflicts, diffview, blame
- **Terminal Management**: Multiple terminals, floating/split modes
- **Task Runner**: Build, run, test commands with Overseer
- **Diagnostic Tools**: Enhanced trouble list, inline diagnostics

### 🌐 DevOps & Cloud Native
- **Kubernetes**: kubectl integration, YAML schema validation
- **Terraform**: Full OpenTofu/Terraform support
- **Docker**: Dockerfile support with hadolint
- **Helm**: Chart development support
- **Container Tools**: Enhanced YAML navigation

---

## 🎯 Plugin Overview (80+ Plugins)

### 🎨 **UI & Aesthetics (25+ plugins)**
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **zaldih/themery.nvim** | Theme management | Live preview, persistence |
| **nvim-lualine/lualine.nvim** | Status line | Git, LSP, diagnostics, time |
| **akinsho/bufferline.nvim** | Buffer tabs | Pinning, sorting, diagnostics |
| **nvimdev/dashboard-nvim** | Start screen | ASCII art, quick actions |
| **folke/noice.nvim** | UI overhaul | Floating cmdline, messages |
| **rcarriga/nvim-notify** | Notifications | Animations, filtering |
| **lukas-reineke/indent-blankline.nvim** | Indent guides | Visual indentation |
| **NvChad/nvim-colorizer.lua** | Color preview | Hex/RGB color highlighting |
| **karb94/neoscroll.nvim** | Smooth scrolling | Animated scrolling |
| **eandrju/cellular-automaton.nvim** | Fun animations | Matrix rain, Game of Life |
| **folke/zen-mode.nvim** | Focus mode | Distraction-free editing |
| **15+ Color Schemes** | Themes | Tokyo Night, Catppuccin, Kanagawa, etc. |

### 🧭 **Navigation & File Management**
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **nvim-neo-tree/neo-tree.nvim** | File explorer | Git integration, multi-source |
| **stevearc/oil.nvim** | Buffer-based files | Direct file operations |
| **nvim-telescope/telescope.nvim** | Fuzzy finder | Universal search interface |
| **ibhagwan/fzf-lua** | Fast finder | High-performance alternative |
| **folke/flash.nvim** | Enhanced navigation | Quick jumps, treesitter |

### 🔧 **LSP & Development**
| Plugin | Purpose | Languages Supported |
|--------|---------|-------------------|
| **williamboman/mason.nvim** | LSP management | Auto-install servers |
| **Native LSP** | Language servers | Lua, TS/JS, Python, Rust, Go, C/C++, Zig, R, JSON, YAML, Terraform, Docker, Bash, Markdown, TOML |
| **saghen/blink.cmp** | Completion | Modern, fast completion |
| **L3MON4D3/LuaSnip** | Snippets | Snippet engine |
| **milanglacier/minuet-ai.nvim** | AI completion | Codestral integration |
| **olimorris/codecompanion.nvim** | AI assistant | Chat-based AI |
| **scalameta/nvim-metals** | Scala LSP | Metals integration |

### 📝 **Editing Enhancements**
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **jake-stewart/multicursor.nvim** | Multi-cursor | Multiple cursor editing |
| **echasnovski/mini.surround** | Text objects | Surround operations |
| **echasnovski/mini.pairs** | Auto-pairs | Bracket/quote pairing |
| **MagicDuck/grug-far.nvim** | Search/replace | Advanced find/replace |
| **Vonr/align.nvim** | Text alignment | Align to patterns |
| **folke/trouble.nvim** | Diagnostics | Enhanced problem lists |
| **folke/todo-comments.nvim** | TODO tracking | Highlight and navigate |

### 🔄 **Version Control**
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **lewis6991/gitsigns.nvim** | Git signs | Hunk operations, blame |
| **akinsho/git-conflict.nvim** | Conflict resolution | Visual conflict handling |
| **sindrets/diffview.nvim** | Diff viewer | Advanced git diff |

### 🌐 **DevOps & Infrastructure**
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **Ramilito/kubectl.nvim** | Kubernetes | Cluster management |
| **hashivim/vim-terraform** | Terraform | OpenTofu/Terraform support |
| **someone-stole-my-name/yaml-companion.nvim** | YAML schemas | K8s/Helm validation |
| **towolf/vim-helm** | Helm charts | Template development |
| **cuducos/yaml.nvim** | YAML navigation | Path extraction |

### 🖥️ **Terminal & External Tools**
| Plugin | Purpose | Key Features |
|--------|---------|--------------|
| **akinsho/toggleterm.nvim** | Terminal management | Multiple terminals, lazygit |
| **GeorgesAlkhouri/nvim-aider** | Aider integration | AI coding assistant |
| **stevearc/overseer.nvim** | Task runner | Build/run/test commands |

---

## ⌨️ Keybindings (Leader = `<Space>`)

> Press **which-key** (`<leader>` + pause) to discover all keybindings dynamically.

### 🗂️ **Files & Search**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find files | Telescope file finder |
| `<leader>fg` | Live grep | Search in files |
| `<leader>fr` | Recent files | Recently opened files |
| `<leader>fb` | Buffers | Buffer list |
| `<leader>e` | Toggle neo-tree | File explorer |
| `<leader>o` | Oil normal | Buffer-based file editing |
| `<leader>O` | Oil float | Floating file editor |

### 🔧 **LSP & Code**
| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to definition | Jump to symbol definition |
| `gr` | References | Find symbol references |
| `gi` | Go to implementation | Jump to implementation |
| `K` | Hover docs | Show documentation |
| `<leader>ca` | Code actions | Available code actions |
| `<leader>cr` | Rename | Rename symbol |
| `<leader>cf` | Format | Format current buffer |
| `<leader>cl` | LSP info | Show LSP client status |
| `]d / [d` | Next/prev diagnostic | Navigate diagnostics |

### 🎨 **Multi-cursor & Editing**
| Key | Action | Description |
|-----|--------|-------------|
| `<C-n>` | Add cursor to next match | Multi-cursor: next match |
| `<C-p>` | Add cursor to prev match | Multi-cursor: prev match |
| `<C-j>` | Add cursor down | Multi-cursor: line down |
| `<C-k>` | Add cursor up | Multi-cursor: line up |
| `<leader>A` | Add all cursors | Multi-cursor: all matches |
| `<C-LeftMouse>` | Add cursor | Multi-cursor: mouse click |
| `<leader>sr` | Search & replace | Advanced find/replace |
| `aa` (visual) | Align | Align text to character |

### 🔄 **Git Operations**
| Key | Action | Description |
|-----|--------|-------------|
| `]h / [h` | Next/prev hunk | Navigate git hunks |
| `<leader>ghs` | Stage hunk | Stage current hunk |
| `<leader>ghr` | Reset hunk | Reset current hunk |
| `<leader>ghp` | Preview hunk | Preview hunk changes |
| `<leader>gd` | Diffview | Open git diffview |
| `<leader>gco` | Choose ours | Resolve conflict (ours) |
| `<leader>gct` | Choose theirs | Resolve conflict (theirs) |
| `<leader>gg` | Lazygit | Open lazygit |

### 🤖 **AI Integration**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ai` | AI chat | Open AI chat interface |
| `<leader>aa` | AI actions | AI action menu |
| `<leader>cc` | Claude Code | Claude Code terminal |
| `<leader>cC` | Claude Code tab | Claude Code in tab |
| `<leader>cA` | Aider | Aider command menu |
| `<A-y>` | Accept AI suggestion | Accept AI completion |
| `<A-n>/<A-p>` | Navigate AI suggestions | Cycle through AI completions |

### 🖥️ **Terminal & Tasks**
| Key | Action | Description |
|-----|--------|-------------|
| `<C-\>` | Toggle terminal | Floating terminal |
| `<leader>tf` | Terminal float | Floating terminal |
| `<leader>th` | Terminal horizontal | Horizontal split terminal |
| `<leader>tv` | Terminal vertical | Vertical split terminal |
| `<leader>tt` | Terminal tab | Terminal in new tab |
| `<leader>ta` | All terminals | Show all terminals |
| `<F5>` | Run task | Execute run task |
| `<F6>` | Build task | Execute build task |
| `<F7>` | Test task | Execute test task |
| `<leader>ot` | Toggle Overseer | Task runner interface |

### 🌐 **DevOps & Infrastructure**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>k` | Kubectl | Kubernetes interface |
| `<leader>cy` | YAML schema | Select YAML schema |
| `<leader>yp` | YAML path | Show YAML path |
| `<leader>yk` | YAML key | Show YAML key |

### 🎨 **Themes & UI**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ut` | Theme picker | Open theme selector |
| `<leader>uc` | Random theme | Shuffle to random theme |
| `<leader>zz` | Zen mode | Toggle distraction-free mode |
| `<leader>fml` | Matrix rain | Cellular automaton: rain |
| `<leader>gol` | Game of Life | Cellular automaton: life |

### 📋 **Buffers & Navigation**
| Key | Action | Description |
|-----|--------|-------------|
| `<Tab>/<S-Tab>` | Next/prev buffer | Buffer navigation |
| `<leader>bd` | Delete buffer | Close current buffer |
| `<leader>bp` | Pin buffer | Pin/unpin buffer |
| `<leader>bo` | Close others | Close other buffers |
| `s / S` | Flash jump | Quick jump navigation |
| `<C-h/j/k/l>` | Window navigation | Move between windows |

### 🔍 **Search & Diagnostics**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>xx` | Toggle diagnostics | Open diagnostic list |
| `<leader>st` | Search todos | Find TODO comments |
| `]t / [t` | Next/prev todo | Navigate TODO comments |
| `<leader>mp` | Markdown preview | Toggle markdown preview |

---

## 🚀 Installation

### **Automated Install (Recommended)**
```bash
# Cross-platform installer
curl -fsSL https://raw.githubusercontent.com/ncls-p/nvim-config/main/install.sh | bash
```

### **Manual Install**
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)

# Clone configuration
git clone https://github.com/ncls-p/nvim-config ~/.config/nvim

# Start Neovim (first launch will bootstrap everything)
nvim
```

### **Requirements**
- **Neovim** ≥ 0.10 (0.11+ recommended for native LSP)
- **Git**, **ripgrep**, **fd** (search tools)
- **Node.js** ≥ 16, **Python 3.8+** (LSP servers)
- **Nerd Font** (for icons)

**First Launch**: Automatically bootstraps `lazy.nvim`, installs 80+ plugins, LSP servers via Mason, and Treesitter parsers.

---

## 🌍 Language Support

### **Full LSP Support (15+ Languages)**
| Language | LSP Server | Formatter | Linter | Status |
|----------|------------|-----------|--------|--------|
| **Python** | `basedpyright` + `ruff` | `ruff` | `ruff` | ✅ |
| **TypeScript/JavaScript** | `vtsls` | `prettier` | `eslint_d` | ✅ |
| **Rust** | `rust-analyzer` | `rustfmt` | built-in | ✅ |
| **Go** | `gopls` | `gofmt` + `goimports` | built-in | ✅ |
| **C/C++** | `clangd` | `clang-format` | built-in | ✅ |
| **Zig** | `zls` | `zig fmt` | built-in | ✅ |
| **R** | `r-languageserver` | `styler` | `lintr` | ✅ |
| **Lua** | `lua-language-server` | `stylua` | built-in | ✅ |
| **JSON** | `json-lsp` | `prettier` | built-in | ✅ |
| **YAML** | `yaml-language-server` | `prettier` | built-in | ✅ |
| **Terraform** | `terraform-ls` | `terraform-fmt` | built-in | ✅ |
| **Docker** | `dockerfile-language-server` | built-in | `hadolint` | ✅ |
| **Bash** | `bash-language-server` | `shfmt` | `shellcheck` | ✅ |
| **Markdown** | `marksman` | `prettier` | `markdownlint` | ✅ |
| **TOML** | `taplo` | built-in | built-in | ✅ |
| **Scala** | `metals` | `scalafmt` | built-in | ✅ |

### **AI Integration**
| Tool | Purpose | API Required |
|------|---------|--------------|
| **Minuet AI** | Code completion | Codestral API |
| **CodeCompanion** | AI chat assistant | OpenAI/Claude API |
| **Aider** | AI pair programming | OpenAI/Claude API |

---

## 🔧 OS-Specific Setup

<details><summary><strong>🍎 macOS</strong></summary>

```bash
# Homebrew installation
brew install neovim ripgrep fd node python@3.12 git
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Global development tools
npm install -g vtsls prettier eslint_d
pip3 install ruff basedpyright
```
</details>

<details><summary><strong>🐧 Ubuntu/Debian</strong></summary>

```bash
# Package installation
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim ripgrep fd-find nodejs npm python3 python3-pip git

# Fix fd symlink
sudo ln -sf /usr/bin/fdfind /usr/bin/fd

# Global tools
npm install -g vtsls prettier eslint_d
pip3 install --user ruff basedpyright
```
</details>

<details><summary><strong>🏗️ Arch Linux</strong></summary>

```bash
# Package installation
sudo pacman -S neovim ripgrep fd nodejs npm python python-pip git
yay -S ttf-jetbrains-mono-nerd

# Global tools
npm install -g vtsls prettier eslint_d
pip install --user ruff basedpyright
```
</details>

<details><summary><strong>🪟 Windows</strong></summary>

```powershell
# Using Scoop (recommended)
scoop install neovim ripgrep fd nodejs python git
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF

# Using winget
winget install Neovim.Neovim BurntSushi.ripgrep sharkdp.fd OpenJS.NodeJS Python.Python.3 Git.Git

# Global tools
npm install -g vtsls prettier eslint_d
pip install ruff basedpyright
```
</details>

---

## 📁 Configuration Structure

```
~/.config/nvim/
├── init.lua                          # Entry point
├── install.sh                        # Cross-platform installer
├── README.md                         # This file
├── lua/
│   ├── config/                       # Core configuration
│   │   ├── options.lua               # Vim options
│   │   ├── keymaps.lua              # Global keymaps
│   │   ├── autocmds.lua             # Auto commands
│   │   └── util.lua                 # Utility functions
│   └── plugins/                      # Plugin configurations (25+ files)
│       ├── lsp.lua                   # LSP + Mason setup
│       ├── blink-cmp.lua            # Completion engine
│       ├── multicursor.lua          # Multi-cursor editing
│       ├── aesthetic-ui.lua         # UI enhancements
│       ├── theme-manager.lua        # Theme management
│       ├── codecompanion.lua        # AI assistant
│       ├── devops.lua               # Kubernetes/Terraform
│       ├── terminal.lua             # Terminal integration
│       ├── enhanced-editing.lua     # Editing tools
│       ├── ultra-dashboard.lua      # Startup screen
│       └── [20+ more plugin files]
└── lsp/                             # LSP server configs
    ├── lua_ls.lua                   # Lua LSP
    ├── ts_ls.lua                    # TypeScript LSP
    ├── basedpyright.lua             # Python LSP
    └── [more LSP configs]
```

---

## 🎛️ Customization

### **Environment Variables**
```bash
# AI Integration
export OPENAI_API_KEY="your_openai_key"
export ANTHROPIC_API_KEY="your_claude_key"
export CODESTRAL_API_KEY="your_codestral_key"

# Claude Code integration
export CLAUDE_API_KEY="your_claude_key"
```

### **Add New LSP Servers**
1. **Install via Mason**: `:Mason` → select server → `i` to install
2. **Add to auto-install**: Edit `lua/plugins/lsp.lua` → `ensure_installed` array
3. **Configure**: Add config in `lua/plugins/lsp.lua` → `config` function

### **Theme Customization**
- **Switch themes**: `<leader>ut` (theme picker) or `<leader>uc` (random)
- **Add themes**: Edit `lua/plugins/theme-manager.lua`
- **Theme state**: Stored in `~/.local/share/nvim/themery/state.json`

### **Keybinding Customization**
- **Global keymaps**: `lua/config/keymaps.lua`
- **Plugin keymaps**: Individual plugin files in `lua/plugins/`
- **Which-key groups**: Defined in `lua/plugins/editor.lua`

---

## ⚡ Performance

### **Metrics**
- **Startup Time**: 50-100ms (with 80+ plugins)
- **Memory Usage**: ~50MB baseline
- **Plugin Load**: Aggressive lazy-loading

### **Optimizations**
- **Lazy loading**: All plugins load on-demand
- **Disabled features**: Unused built-ins disabled
- **Treesitter**: Incremental parsing
- **LSP**: Native 0.11+ API for better performance

### **Profiling Tools**
```vim
:Lazy profile          " Plugin load times
:checkhealth           " Health diagnostics
:LspDebug             " LSP diagnostic info
```

---

## 🔧 Advanced Features

### **AI-Powered Development**
- **Code completion**: Codestral via Minuet AI
- **Chat assistant**: OpenAI/Claude via CodeCompanion
- **Pair programming**: Aider integration
- **Claude Code**: Direct CLI integration

### **DevOps Integration**
- **Kubernetes**: kubectl interface, YAML validation
- **Terraform**: Full OpenTofu support
- **Docker**: Dockerfile support with linting
- **Helm**: Chart development tools

### **Multi-cursor Editing**
- **Smart selection**: Add cursors to matching text
- **Line-based**: Add cursors up/down
- **Mouse support**: Ctrl+click to add cursors
- **Pattern matching**: Select all occurrences

### **Advanced Search & Replace**
- **Fuzzy finding**: Multiple finder backends
- **Live grep**: Search across entire project
- **Find & replace**: Visual interface with preview
- **TODO tracking**: Highlight and navigate comments

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| **Missing icons** | Install a Nerd Font (JetBrains Mono recommended) |
| **LSP not working** | Check `:LspDebug`, `:Mason`, `:checkhealth lsp` |
| **Slow startup** | Run `:Lazy profile` to identify slow plugins |
| **Plugins missing** | `:Lazy sync` → `:Lazy clean` → `:Lazy restore` |
| **Themes not loading** | Check `~/.local/share/nvim/themery/state.json` |
| **AI not working** | Set API keys in environment variables |
| **Terminal issues** | Check shell integration, verify toggleterm config |
| **Mason failures** | Check network, Node.js/Python installation |
| **Git features broken** | Verify git installation, check repo status |
| **Multicursor not working** | Verify jake-stewart/multicursor.nvim is loaded |

### **Debug Commands**
```vim
:checkhealth           " Overall health check
:LspDebug             " LSP status and configuration
:Lazy                 " Plugin management interface
:Mason                " LSP server management
:Telescope builtin    " Available Telescope pickers
:WhichKey             " Show all keybindings
```

---

## 📈 Configuration Stats

- **🔌 Total Plugins**: 80+ active plugins
- **🎨 Themes**: 15+ premium color schemes
- **🤖 AI Tools**: 3 AI integrations (Minuet, CodeCompanion, Aider)
- **🌍 Languages**: 15+ fully supported languages
- **🔧 LSP Servers**: Auto-managed via Mason
- **🖥️ Terminal**: 4 integrated terminal tools
- **☁️ DevOps**: Full Kubernetes/Terraform support
- **⚡ Performance**: <100ms startup with aggressive lazy-loading

---

## 🤝 Contributing

**Issues, forks, and pull requests are welcome!**

This configuration represents a modern, professional Neovim setup optimized for 2025 development workflows. It combines cutting-edge AI tools, comprehensive language support, beautiful aesthetics, and powerful DevOps integration.

**Code with passion; share with joy.** 🚀

---

## 📜 License

MIT License - Feel free to use, modify, and distribute.

---

*Last Updated: 2025-07-04*
*Configuration Version: 2025.1*
*Total Plugins: 80+*
*Supported Languages: 15+*