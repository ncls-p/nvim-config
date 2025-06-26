-- 🎨 Ultra Modern Theme Initialization (2025)

-- Set default colorscheme with fallback
local function set_colorscheme()
  local colorschemes = {
    "tokyonight-night",
    "rose-pine",
    "kanagawa-wave",
    "catppuccin-mocha",
    "nightfox",
    "gruvbox-material",
    "oxocarbon",
    "habamax",
    "default"
  }

  for _, scheme in ipairs(colorschemes) do
    local ok = pcall(vim.cmd.colorscheme, scheme)
    if ok then
      print("🎨 Applied colorscheme: " .. scheme)
      break
    end
  end
end

-- Apply theme after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    set_colorscheme()

    -- Additional aesthetic enhancements
    if vim.fn.has("termguicolors") == 1 then
      vim.opt.termguicolors = true
    end

    -- Set up some beautiful highlights
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- Make floating windows more beautiful
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7aa2f7", bg = "none" })
        vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#bb9af7", bg = "none", bold = true })

        -- Better telescope highlights
        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#7aa2f7", bg = "none" })
        vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = "#bb9af7", bg = "none", bold = true })

        -- Enhanced cursor line
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a1b26" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#7aa2f7", bold = true })

        -- Better visual selection
        vim.api.nvim_set_hl(0, "Visual", { bg = "#364a82" })

        -- Enhanced search
        vim.api.nvim_set_hl(0, "Search", { fg = "#1a1b26", bg = "#e0af68", bold = true })
        vim.api.nvim_set_hl(0, "IncSearch", { fg = "#1a1b26", bg = "#f7768e", bold = true })

        -- Beautiful git signs
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ece6a" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e0af68" })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f7768e" })

        -- Better diagnostics
        vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#f7768e" })
        vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#e0af68" })
        vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#7dcfff" })
        vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#1abc9c" })

        -- SmoothCursor colors
        vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "SmoothCursorRed", { fg = "#f7768e" })
        vim.api.nvim_set_hl(0, "SmoothCursorOrange", { fg = "#ff9e64" })
        vim.api.nvim_set_hl(0, "SmoothCursorYellow", { fg = "#e0af68" })
        vim.api.nvim_set_hl(0, "SmoothCursorGreen", { fg = "#9ece6a" })
        vim.api.nvim_set_hl(0, "SmoothCursorAqua", { fg = "#73daca" })
        vim.api.nvim_set_hl(0, "SmoothCursorBlue", { fg = "#7dcfff" })
        vim.api.nvim_set_hl(0, "SmoothCursorPurple", { fg = "#bb9af7" })
      end,
    })
  end,
})

-- Welcome message with style
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        print("🚀 Welcome to your Ultra Modern Neovim setup! ✨")
      end, 1000)
    end
  end,
})

