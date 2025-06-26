# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment

This is a modern Neovim configuration (2025) located at `~/.config/nvim/`. The configuration uses lazy.nvim as the plugin manager with lazy loading for optimal startup performance.

### Key Commands

**Plugin Management:**
- `:Lazy` - Open lazy.nvim plugin manager
- `:Mason` - Open Mason LSP server manager
- `:LspInfo` - Show LSP server information

**Claude Code Integration:**
- `<C-,>` - Toggle Claude Code terminal (default keymap)
- `<leader>cC` - Continue conversation (default keymap)
- `<leader>cV` - Verbose mode (default keymap)
- Commands: `:ClaudeCode`, `:ClaudeCodeContinue`, `:ClaudeCodeVerbose`
- Claude Code path: `/opt/homebrew/bin/claude`

**Development Tools:**
- `:Telescope` - Access fuzzy finder functionality
- `:ConformInfo` - Show code formatting information
- `<leader>cf` - Format code using conform.nvim
- `<leader>gg` - Open Lazygit

**Terminal Management:**
- `<Ctrl+\>` - Toggle floating terminal
- `<leader>tf` - Toggle floating terminal
- `<leader>th` - Toggle horizontal terminal
- `<leader>tv` - Toggle vertical terminal

## Architecture Overview

### Core Structure
- **Entry Point**: `init.lua` - Bootstraps lazy.nvim and loads core configuration
- **Configuration**: `lua/config/` - Core Neovim settings, keymaps, autocmds, utilities
- **Plugins**: `lua/plugins/` - Modular plugin specifications organized by function

### Plugin Architecture
The configuration uses a modular approach with plugins organized into logical groups:

- **LSP & Completion**: Native LSP with Mason, blink.cmp for completion
- **Editor**: Telescope (fuzzy finder), Neo-tree (file explorer), Oil.nvim (buffer-based file ops)
- **UI**: Lualine (status line), Bufferline (buffer tabs), Dashboard, Noice (enhanced UI)
- **Terminal**: ToggleTerm with predefined terminal instances
- **Git**: Gitsigns, Diffview, Git-conflict for merge resolution
- **Themes**: colorbox.nvim for automatic theme collection and management
- **Navigation**: Flash.nvim for quick jumping
- **AI Integration**: Custom Claude Code plugin for terminal integration

### LSP Configuration
- **Server Management**: Mason auto-installs and manages LSP servers
- **Essential Servers**: lua_ls, ts_ls, pyright, jsonls, html, cssls
- **Capabilities**: Integrated with blink.cmp for completion
- **Formatting**: Uses conform.nvim with LSP fallback
- **Border Style**: Rounded borders configured globally for all floating windows

### Theme System
- **Theme Manager**: colorbox.nvim automatically downloads and manages 800+ themes
- **Pre-configured**: 10 premium themes (Tokyo Night, Catppuccin, Kanagawa, etc.)
- **Quality Filter**: Only includes themes with 800+ GitHub stars
- **Theme Switching**: `<leader>uc` to shuffle, `<leader>uC` to select from list

### Terminal Integration
- **Claude Code**: Custom plugin with file change detection and auto-refresh
- **ToggleTerm**: Multiple terminal instances (floating, horizontal, vertical)
- **Special Terminals**: Lazygit, Node REPL, Python REPL, Claude Code variants
- **Navigation**: Seamless window navigation from terminal mode

### Configuration Management
- **Leader Key**: Space (`<Space>`)
- **Lazy Loading**: Plugins load on demand for fast startup
- **Performance**: Disabled unnecessary built-in plugins
- **Auto-commands**: Smart file handling, highlight on yank, auto-directory creation
- **Utilities**: Extensive utility functions in `lua/config/util.lua`

## Key Files

- `init.lua` - Entry point with lazy.nvim bootstrap
- `lua/config/options.lua` - Neovim options and UI settings
- `lua/config/keymaps.lua` - Global keybindings
- `lua/config/util.lua` - Utility functions for LSP, formatting, UI helpers
- `lua/plugins/lsp.lua` - LSP configuration with Mason integration
- `lua/plugins/claude-code.lua` - Claude Code CLI integration
- `lua/plugins/terminal.lua` - Terminal management with ToggleTerm
- `lua/plugins/editor.lua` - Core editing plugins (Telescope, Neo-tree, etc.)

## Configuration Patterns

### Plugin Specification
Plugins follow lazy.nvim spec with:
- Lazy loading using `event`, `cmd`, `keys`, or `ft`
- Dependencies explicitly listed
- Configuration in `config` function or `opts` table
- Keymaps defined in `keys` table for automatic lazy loading

### LSP Setup
- Servers defined in `opts.servers` table
- Mason automatically installs servers
- Capabilities merged with completion engine
- Custom setup functions supported per server

### Keymap Organization
- Core keymaps in `lua/config/keymaps.lua`
- Plugin-specific keymaps in plugin specs
- Consistent `<leader>` prefix organization
- Which-key integration for keymap discovery

### Theme Integration
- colorbox.nvim handles theme discovery and installation
- Themes filtered by quality (star count)
- Automatic fallback to built-in themes
- Theme persistence across restarts