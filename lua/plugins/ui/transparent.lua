return {
  -- Transparent background
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        groups = { -- default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorColumn', 'CursorLine', 'TabLine', 'TabLineFill',
          'StatusLine', 'StatusLineNC', 'EndOfBuffer',
        },
        extra_groups = {
          -- Additional groups for better transparency
          "NormalFloat", -- floating windows
          "FloatBorder", -- floating window borders
          "TelescopeNormal", -- telescope
          "TelescopeBorder",
          "NeoTreeNormal", -- neo-tree
          "NeoTreeNormalNC",
        },
        exclude_groups = {}, -- groups to exclude from transparency
        on_clear = function() end, -- callback after clearing
      })
    end,
    keys = {
      { "<leader>ut", "<cmd>TransparentToggle<cr>", desc = "🔍 Toggle transparency" },
    },
  },
}