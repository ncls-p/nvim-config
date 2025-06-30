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

## Swift Development Setup

### Prerequisites
Swift development requires additional tools beyond the LSP server:

1. **SourceKit-LSP**: Comes bundled with Xcode, provides language server functionality
2. **swiftformat**: Install via Homebrew for code formatting
   ```bash
   brew install swiftformat
   ```
3. **xcode-build-server** (for iOS/macOS projects): Bridges Xcode projects with LSP
   ```bash
   brew install xcode-build-server
   ```

### Configuration Details
- **LSP Server**: `sourcekit` is configured in `lua/plugins/lsp.lua:101-111` (manual setup since it's not available via Mason)
- **Formatting**: swiftformat is configured in conform.nvim
- **File Settings**: Swift files use 4-space indentation (Apple standard)
- **Comment String**: `// %s` for proper commenting support

### iOS/macOS Project Setup
For Xcode-based projects, after installing xcode-build-server:

1. Build your project in Xcode first
2. In your project root, run:
   ```bash
   xcode-build-server config -workspace YourApp.xcworkspace -scheme YourScheme
   ```
3. This creates `buildServer.json` that allows sourcekit-lsp to understand your project structure
4. Open Swift files and verify LSP is attached with `:LspInfo`

### Troubleshooting
- If LSP doesn't recognize iOS/UIKit symbols, ensure xcode-build-server is configured
- Rebuild in Xcode and regenerate buildServer.json if dependencies change
- Check `:LspLog` for sourcekit-lsp error messages

## XML Development Setup

### Overview
XML support is provided through lemminx LSP server with advanced features:
- Schema-aware validation and completion
- Auto-closing tags
- Symbol navigation
- Code actions for quick fixes
- Formatting with xmllint or LSP

### Configuration Details
- **LSP Server**: `lemminx` configured in `lua/plugins/lsp.lua:99-129`
- **Formatting**: xmllint (system tool) or lemminx LSP formatting
- **File Settings**: 2-space indentation, indent-based folding
- **Auto-close tags**: Type `>` to auto-close XML tags
- **Supported filetypes**: xml, xsd, xsl, xslt, svg

### Features
1. **Schema Validation**: Automatic validation against DTD/XSD schemas
2. **Smart Completion**: Context-aware tag and attribute completion
3. **Folding**: Indent-based folding enabled by default
4. **Formatting**: Use `<leader>cf` to format with xmllint

### Prerequisites
```bash
# xmllint comes with libxml2
brew install libxml2  # macOS
sudo apt-get install libxml2-utils  # Ubuntu/Debian
```

### Cache Management
Lemminx stores cache in `~/.cache/lemminx` following XDG standards

## Important Notes

- The configuration auto-installs missing plugins and LSP servers on first run
- lazy-lock.json ensures consistent plugin versions across installations
- Rounded borders are configured globally for unified UI
- File operations use Oil.nvim for buffer-based editing
- Terminal mode navigation uses `<C-h/j/k/l>` for consistency

## Security Configuration

### API Key Management

For AI features (CodeCompanion), API keys are read from environment variables for security:

```bash
# Add to your shell profile (~/.zshrc, ~/.bashrc, etc.)
export HELIXMIND_API_KEY="your-actual-api-key-here"

# Or create a .env file in your config directory (not tracked by git)
echo "HELIXMIND_API_KEY=your-actual-api-key-here" >> ~/.config/nvim/.env
```

**Important**: Never commit API keys to version control. Use environment variables or excluded files.