-- Simple theme initialization for tokyonight
-- This is just a fallback in case the theme plugin doesn't load properly

local function set_colorscheme()
  -- Don't override if a colorscheme is already set
  if vim.g.colors_name then
    return
  end

  -- Fallback to default themes (theme persistence is handled in tokyonight plugin now)
  local colorschemes = {
    "tokyonight-night",
    "tokyonight",
    "habamax",
    "default"
  }

  for _, scheme in ipairs(colorschemes) do
    local success = pcall(vim.cmd.colorscheme, scheme)
    if success then
      break
    end
  end
end

-- Apply theme after plugins are loaded (only as fallback)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Enable termguicolors first
    if vim.fn.has("termguicolors") == 1 then
      vim.opt.termguicolors = true
    end

    -- Theme persistence is handled in tokyonight plugin now
    -- This is just a fallback in case the plugin doesn't load
    set_colorscheme()

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
      end,
    })
  end,
})

