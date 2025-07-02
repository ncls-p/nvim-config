# Modern Neovim Configuration (2025)

An **ultra-modern** Neovim setup powered by **lazy.nvim** for lightning-fast startup, a complete IDE experience (native LSP, AI, sleek UI) and productive workflows in every language.

---

## ✨ Features

### 🔧 Core
- **Plugin manager:** `lazy.nvim` (aggressive *lazy-loading*)
- **Native LSP** via `mason.nvim` (auto-installs servers)
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

### Requirements
- **Neovim** ≥ 0.10
- **Git**, **ripgrep**
- **Node.js** ≥ 16, **Python 3**
- **fd** (optional), **Nerd Font**

### Quick install
```bash
# Backup old config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone
git clone https://github.com/ncls-p/nvim-config ~/.config/nvim

# Start Neovim
nvim
```
First launch: bootstrap `lazy.nvim`, install plugins, LSP (Mason) & Treesitter parsers.

### OS-specific guides
<details><summary>macOS</summary>

```bash
brew install neovim ripgrep fd node python@3.12
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```
</details>

<details><summary>Ubuntu / Debian</summary>

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim ripgrep fd-find nodejs npm python3 python3-pip
```
</details>

<details><summary>Arch Linux</summary>

```bash
sudo pacman -S neovim ripgrep fd nodejs npm python python-pip
yay -S ttf-jetbrains-mono-nerd
```
</details>

---

## 📁 Structure

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/          # options, keymaps …
│   └── plugins/         # ≈23 modules (LSP, UI, etc.)
│       ├── lsp.lua
│       ├── blink-cmp.lua
│       ├── aesthetic-ui.lua
│       ├── codecompanion.lua
│       ├── devops.lua
│       ├── enhanced-editing.lua
│       ├── fzf.lua
│       ├── mini.lua
│       ├── theme-manager.lua
│       ├── ultra-dashboard.lua
│       └── …
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
- `:Mason` → install  
- or edit `lua/plugins/lsp.lua`

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
| LSP inactive | `:LspInfo`, `:LspLog`, check Mason |
| Plugins missing | `:Lazy sync`, `:Lazy clean` |
| Slowness | `:Lazy profile`, `:checkhealth` |

---

## 🤝 Contributing

Issues, forks and PRs are welcome.  
**Code with passion; share with joy.** 🚀
