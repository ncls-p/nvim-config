# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment

This is a modern Neovim configuration (2025) located at `~/.config/nvim/`. The configuration uses lazy.nvim as the plugin manager with lazy loading for optimal startup performance.

### Key Commands

**Plugin Management:**
- `:Lazy` - Open lazy.nvim plugin manager (install/update/sync plugins)
- `:Lazy sync` - Sync all plugins to match lazy-lock.json
- `:Mason` - Open Mason LSP server manager
- `:LspInfo` - Show LSP server information for current buffer
- `:LspLog` - View LSP log for debugging

**Code Actions & Formatting:**
- `<leader>cf` - Format code using conform.nvim
- `<leader>ca` - Code actions (LSP)
- `<leader>cr` - Rename symbol
- `:ConformInfo` - Show active formatters for current buffer

**Navigation & Search:**
- `:Telescope` - Main telescope command
- `<leader>ff` - Find files
- `<leader>fg` - Live grep in project
- `<leader>fb` - Search buffers
- `<leader>fh` - Search help tags
- `<leader>fs` - Search symbols (LSP)

**Terminal & Tools:**
- `<Ctrl+\>` - Toggle floating terminal
- `<leader>gg` - Open Lazygit
- `:ClaudeCode` - Open Claude Code terminal
- Claude Code path: `/opt/homebrew/bin/claude`

## Architecture Overview

### Directory Structure
```
~/.config/nvim/
├── init.lua                 # Entry point, bootstraps lazy.nvim
├── lazy-lock.json          # Plugin version lock file
└── lua/
    ├── config/             # Core configuration
    │   ├── autocmds.lua   # Auto commands
    │   ├── keymaps.lua    # Global keybindings
    │   ├── options.lua    # Neovim options
    │   ├── theme-init.lua # Theme initialization
    │   └── util.lua       # Utility functions (LSP, UI, etc.)
    └── plugins/           # Plugin specifications (23 modules)
        ├── lsp.lua        # LSP + Mason configuration
        ├── blink-cmp.lua  # Completion engine
        ├── editor.lua     # File management (Telescope, Neo-tree, Oil)
        ├── terminal.lua   # Terminal integration
        └── ...            # Other plugin groups
```

### Core Components

**LSP Setup (`lua/plugins/lsp.lua`):**
- Mason auto-installs LSP servers defined in `opts.servers`
- Servers: lua_ls, ts_ls, pyright, jsonls, html, cssls, and more
- Custom per-server configurations supported
- Integrated with blink.cmp for completion
- Conform.nvim handles formatting with LSP fallback

**Plugin Loading Strategy:**
- Lazy loading via events: `BufReadPre`, `BufNewFile`, `VeryLazy`
- Command-based loading for tools like Telescope, Mason
- Key-based loading for mapped functionalities
- Minimal plugins loaded at startup for performance

**Theme System (`lua/plugins/theme-manager.lua`):**
- colorbox.nvim manages 800+ themes
- Quality filter: only themes with 800+ GitHub stars
- Theme commands: `<leader>uc` (shuffle), `<leader>uC` (select)
- Pre-configured premium themes in `lua/plugins/themes.lua`

## Configuration Patterns

### Adding New Plugins
Create a new file in `lua/plugins/` or add to existing category:
```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",  -- or specific events/commands
    dependencies = { "dep/name" },
    opts = {
      -- plugin options
    },
    config = function(_, opts)
      -- setup code
    end,
    keys = {
      { "<leader>xx", "<cmd>PluginCommand<cr>", desc = "Description" },
    },
  },
}
```

### LSP Server Addition
Add to `lua/plugins/lsp.lua` in the servers table:
```lua
opts.servers.new_server = {
  settings = {
    -- server-specific settings
  },
}
```

### Keymap Conventions
- Leader key: `<Space>`
- Local leader: `\`
- Plugin keymaps in plugin spec `keys` table
- Global keymaps in `lua/config/keymaps.lua`
- Consistent prefixes: `<leader>f` (find), `<leader>g` (git), `<leader>c` (code), `<leader>u` (UI)

### Utility Functions
Available in `lua/config/util.lua`:
- `get_lsp_config()` - LSP configuration helpers
- `format_toggle()` - Toggle auto-formatting
- `diagnostics_toggle()` - Toggle diagnostics
- UI helpers for borders, icons, and highlighting

## Development Workflow

1. **Adding Features**: Create new plugin specs in `lua/plugins/`
2. **Modifying Options**: Edit `lua/config/options.lua`
3. **Custom Commands**: Add to `lua/config/autocmds.lua`
4. **Debugging**: Check `:messages`, `:LspLog`, `:Lazy log`
5. **Performance**: Use `:Lazy profile` to check startup times

## Important Notes

- The configuration auto-installs missing plugins and LSP servers on first run
- lazy-lock.json ensures consistent plugin versions across installations
- Rounded borders are configured globally for unified UI
- File operations use Oil.nvim for buffer-based editing
- Terminal mode navigation uses `<C-h/j/k/l>` for consistency