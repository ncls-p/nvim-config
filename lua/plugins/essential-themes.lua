return {
  -- Essential themes only - lightweight and popular
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        styles = {
          sidebars = "dark",
          floats = "dark",
        },
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        telescope = true,
        which_key = true,
        treesitter = true,
        mason = true,
      },
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      dark_variant = "main",
      disable_background = false,
      disable_float_background = false,
    },
  },

  -- Simple theme manager (keep only one)
  {
    "zaldih/themery.nvim",
    cmd = "Themery",
    opts = {
      themes = {
        "tokyonight-night",
        "tokyonight-moon", 
        "catppuccin-mocha",
        "rose-pine",
        "rose-pine-moon",
      },
      livePreview = true,
    },
  },
}