return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "neo-tree", "Trouble" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      on_colors = function(colors) end,
      on_highlights = function(highlights, colors) end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      
      -- Try to load saved theme after tokyonight is set up
      vim.schedule(function()
        local ok, theme_persistence = pcall(require, "config.theme-persistence")
        if ok then
          local saved_theme = theme_persistence.load_theme()
          if not saved_theme then
            -- Set default theme if no saved theme
            vim.cmd.colorscheme("tokyonight-night")
          end
        else
          vim.cmd.colorscheme("tokyonight-night")
        end
      end)
    end,
  },
}