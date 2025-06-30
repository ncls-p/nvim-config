return {
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 900, -- Load after themes but before UI
    dependencies = {
      {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
          style = "night",
          transparent = false,
          terminal_colors = true,
        },
      },
      {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
          flavour = "mocha",
          transparent_background = false,
          term_colors = true,
        },
      },
      {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {
          compile = false,
          transparent = false,
          terminalColors = true,
        },
      },
      {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        opts = {
          variant = "auto",
          dark_variant = "main",
        },
      },
      {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
          options = {
            transparent = false,
            terminal_colors = true,
          },
        },
      },
      {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        opts = {
          style = "dark",
          transparent = false,
          term_colors = true,
        },
      },
      {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        opts = {
          transparent = false,
          italic_comments = true,
          terminal_colors = true,
        },
      },
      {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
          terminal_colors = true,
          transparent_mode = false,
        },
      },
      {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
          vim.g.nord_contrast = true
          vim.g.nord_borders = true
          vim.g.nord_italic = true
        end,
      },
      {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
          vim.g.everforest_background = 'hard'
          vim.g.everforest_better_performance = 1
          vim.g.everforest_enable_italic = 1
        end,
      },
      {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = false,
        priority = 1000,
      },
    },
    config = function()
      require("themery").setup({
        themes = {
          "tokyonight",
          "tokyonight-moon",
          "tokyonight-day",
          "tokyonight-storm",
          "catppuccin",
          "catppuccin-latte", 
          "catppuccin-frappe",
          "catppuccin-macchiato",
          "catppuccin-mocha",
          "kanagawa",
          "kanagawa-wave",
          "kanagawa-dragon",
          "kanagawa-lotus",
          "rose-pine",
          "rose-pine-moon", 
          "rose-pine-dawn",
          "nightfox",
          "carbonfox",
          "dawnfox",
          "dayfox",
          "duskfox",
          "nordfox",
          "terafox",
          "onedark",
          "cyberdream",
          "gruvbox",
          "nord",
          "everforest",
          "oxocarbon",
        },
        livePreview = true,
      })
      
      -- Fallback mechanism if Themery's bootstrap fails
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            if not vim.g.colors_name or vim.g.colors_name == "default" then
              -- Try to load saved theme manually
              local state_file = vim.fn.stdpath("data") .. "/themery/state.json"
              if vim.fn.filereadable(state_file) == 1 then
                local ok, data = pcall(function()
                  local content = vim.fn.readfile(state_file)[1]
                  return vim.json.decode(content)
                end)
                if ok and data.colorscheme then
                  pcall(vim.cmd.colorscheme, data.colorscheme)
                end
              end
            end
          end, 100) -- Small delay to let other plugins finish
        end,
        once = true,
      })
    end,
    keys = {
      { "<leader>ut", "<cmd>Themery<cr>", desc = "Theme picker" },
    },
  },
}

