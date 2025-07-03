# Modern Neovim Configuration (2025)

An **ultra-modern** Neovim setup powered by **lazy.nvim** for lightning-fast startup, a complete IDE experience (native LSP, AI, sleek UI) and productive workflows in every language.

---

## ✨ Features

### 🔧 Core
- **Plugin manager:** `lazy.nvim` (aggressive *lazy-loading*)
- **Native LSP** with Neovim 0.11+ API (15+ languages supported)
- **LSP servers:** Auto-installed via `mason.nvim` with trending 2025 tools
- **Completion:** `blink.cmp` (fast, modern)
- **Syntax tree:** `nvim-treesitter`
- **UI:** rounded floating windows & filtered notifications (`nvim-notify`)
- **Smooth scrolling:** `neoscroll.nvim`

### 🎯 Essential Plugins
| Category | Key plugins |
|----------|-------------|
| Fuzzy finder | **fzf-lua** |
| File explorers | **neo-tree**, **oil.nvim** |
| Buffers/Tabs | **bufferline.nvim** |
| Integrated terminal | **toggleterm.nvim** |
| Help | **which-key.nvim** |
| Git | **gitsigns.nvim**, **diffview.nvim**, **git-conflict.nvim** |
| Status line | **lualine.nvim** |
| UI messages | **noice.nvim** |
| Quickfix + preview | **nvim-bqf** |
| Scrolling | **neoscroll.nvim** |

### ⚡ Navigation & Editing
- **Align.nvim** (smart column alignment)
- **Flash.nvim** (super-fast jumps)
- … plus many other modern utilities

### 🤖 AI Integration
| Use-case | Plugin | Shortcuts |
|----------|--------|-----------|
| Chat & AI actions | **codecompanion.nvim** | `<leader>ai`, `<leader>aa` |
| Command-line | **Claude Code CLI** | `<leader>cc`, `<leader>cC` |

### 🎨 Theme Management
- **themery.nvim**: pick / save themes with live preview
- **Pre-configured premium themes:** Tokyo Night, Catppuccin, Kanagawa, Nightfox, Rose-Pine, OneDark, Oxocarbon, Everforest, Gruvbox, Nord
- Shuffle (`<leader>uc`) & theme picker (`<leader>uC`)

---

## ⌨️ Keybindings (Leader = `<Space>`)

> Press **which-key** (`<leader>` then pause) to discover them all.

### Files & Search
- `<leader>ff`  →  find file
- `<leader>fg`  →  live grep
- `<leader>fr`  →  recent files
- `<leader>fb`  →  buffers
- `<leader>e`   →  toggle **neo-tree**
- `<leader>o / O` →  **oil.nvim** (normal / float)

### LSP & Code
- `gd`  →  go to definition
- `<leader>lr` →  references
- `K`   →  hover docs
- `<leader>ca` →  code actions
- `<leader>cr` →  rename symbol
- `<leader>cf` →  format buffer
- `<leader>cl` →  LSP info

### Git
- `]h / [h` →  next / previous hunk  
- `<leader>ghs / ghr / ghp` →  stage / reset / preview hunk  
- `<leader>gd` →  **diffview**
- `<leader>gh` →  file history
- `<leader>gco / gct` →  resolve conflicts (ours / theirs)

### Terminals
- `<C-\>` →  toggle floating terminal  
- `<leader>tf / th / tv / tt` →  float / horizontal / vertical / tab  
- `<leader>ta / tk` →  all terminals / kill

### AI
- `<leader>ai` →  AI chat
- `<leader>aa` →  AI actions
- `<leader>cc / cC` →  **Claude Code**

### Navigation
- `s / S` →  **flash** jump
- `aa / as` (visual) →  align

### Buffers
- `<Tab> / <S-Tab>` →  next / previous
- `<leader>bd` →  close buffer
- `<leader>bp` →  pin
- `<leader>bo` →  close others

### Clipboard (system)
- `<leader>y / Y / p / P / d` →  yank / paste / delete to system clipboard
- `<Cmd+Y>` / `<C-Y>` →  quick copy

### Windows
- `<C-h/j/k/l>` →  move
- `<leader>w- / w\|` →  splits

### Themes
- `<leader>uc` →  random theme
- `<leader>uC` →  choose theme

---

## 🚀 Installation

### Automated Install (Recommended)
```bash
# Download and run the cross-platform installer
curl -fsSL https://raw.githubusercontent.com/ncls-p/nvim-config/main/install.sh | bash
```

### Manual Install
```bash
# Backup old config
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)

# Clone
git clone https://github.com/ncls-p/nvim-config ~/.config/nvim

# Start Neovim
nvim
```

### Requirements
- **Neovim** ≥ 0.10 (0.11+ recommended for full LSP features)
- **Git**, **ripgrep** (search)
- **Node.js** ≥ 16, **Python 3** (LSP servers)
- **fd** (optional but recommended), **Nerd Font**

First launch: bootstrap `lazy.nvim`, install plugins, LSP servers via Mason & Treesitter parsers.

### Supported Languages & LSP Servers (2025 Trending)
| Language | LSP Server | Formatter | Linter |
|----------|------------|-----------|--------|
| **Python** | `basedpyright` | `ruff` | `ruff` |
| **TypeScript/JS** | `vtsls` | `prettier` | `eslint` |
| **Rust** | `rust-analyzer` | `rustfmt` | built-in |
| **Go** | `gopls` | `gofmt` | `golangci-lint` |
| **C/C++** | `clangd` | `clang-format` | `clang-tidy` |
| **Zig** | `zls` | `zig fmt` | built-in |
| **R** | `languageserver` | `styler` | `lintr` |
| **Lua** | `lua-ls` | `stylua` | `selene` |
| **JSON** | `jsonls` | `prettier` | built-in |
| **YAML** | `yamlls` | `prettier` | built-in |
| **Terraform** | `terraformls` | `terraform fmt` | `tflint` |
| **Docker** | `dockerls` | built-in | `hadolint` |
| **Bash** | `bashls` | `shfmt` | `shellcheck` |
| **Markdown** | `marksman` | `prettier` | `markdownlint` |
| **TOML** | `taplo` | built-in | built-in |

### OS-specific Manual Setup
<details><summary>macOS</summary>

```bash
# Homebrew installation
brew install neovim ripgrep fd node python@3.12 git
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Global tools
npm install -g @vtsls/language-server prettier eslint
pip3 install ruff basedpyright
```
</details>

<details><summary>Ubuntu / Debian</summary>

```bash
# Package installation
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim ripgrep fd-find nodejs npm python3 python3-pip git

# Fix fd symlink
sudo ln -sf /usr/bin/fdfind /usr/bin/fd

# Global tools  
npm install -g @vtsls/language-server prettier eslint
pip3 install --user ruff basedpyright
```
</details>

<details><summary>Arch Linux</summary>

```bash
# Package installation
sudo pacman -S neovim ripgrep fd nodejs npm python python-pip git
yay -S ttf-jetbrains-mono-nerd

# Global tools
npm install -g @vtsls/language-server prettier eslint  
pip install --user ruff basedpyright
```
</details>

<details><summary>Windows</summary>

```powershell
# Using Scoop (recommended)
scoop install neovim ripgrep fd nodejs python git
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF

# Or using winget
winget install Neovim.Neovim BurntSushi.ripgrep sharkdp.fd OpenJS.NodeJS Python.Python.3 Git.Git

# Global tools
npm install -g @vtsls/language-server prettier eslint
pip install ruff basedpyright
```
</details>

---

## 📁 Structure

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/          # options, keymaps, autocmds
│   ├── plugins/         # ≈23 modules (LSP, UI, etc.)
│   │   ├── lsp.lua      # Mason + LSP configurations
│   │   ├── blink-cmp.lua
│   │   ├── aesthetic-ui.lua
│   │   ├── codecompanion.lua
│   │   ├── devops.lua
│   │   ├── enhanced-editing.lua
│   │   ├── fzf.lua
│   │   ├── mini.lua
│   │   ├── theme-manager.lua
│   │   ├── ultra-dashboard.lua
│   │   └── …
│   └── lsp-direct.lua   # Native LSP configuration (15+ languages)
├── install.sh           # Cross-platform installer
└── README.md
```

---

## 🔧 Customisation

### CodeCompanion
```bash
export HELIXMIND_API_KEY="your_key"
```
Shortcuts: `<leader>ai` (chat) / `<leader>aa` (actions)

### Add LSP servers
- `:Mason` → install new servers
- Add to `ensure_installed` in `lua/plugins/lsp.lua`
- Configure in `lua/lsp-direct.lua` for native LSP support

### Themes
- `<leader>uc` → random
- `<leader>uC` → choose  
State file: `~/.local/share/nvim/themery/state.json`

---

## 🎯 Performance

- **Startup:** 50-100 ms
- Aggressive lazy-loading
- Unused built-ins disabled

Profiling: `:Lazy profile`, `:checkhealth`

---

## 🆘 Troubleshooting

| Issue | Fix |
|-------|-----|
| Missing icons | Install a Nerd Font |
| LSP inactive | `<leader>cl` (LSP status), `:Mason`, `:checkhealth lsp` |
| Plugins missing | `:Lazy sync`, `:Lazy clean`, `:Lazy restore` |
| Formatter not working | Check global tools: `npm list -g`, `pip list` |
| Slowness | `:Lazy profile`, `:checkhealth` |
| Install script fails | Check OS compatibility, run with `-x` for debug |

---

## 🤝 Contributing

Issues, forks and PRs are welcome.  
**Code with passion; share with joy.** 🚀
