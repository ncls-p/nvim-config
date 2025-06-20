return {
  -- Modern theme manager with automatic colorscheme collection
  {
    "linrongbin16/colorbox.nvim",
    lazy = false,
    priority = 1000,
    build = function()
      require("colorbox").update()
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- For icon support
    },
    config = function()
      -- Wait for plugin to load
      local ok, colorbox = pcall(require, "colorbox")
      if not ok then
        vim.notify("Colorbox not loaded, using default theme", vim.log.levels.WARN)
        vim.cmd.colorscheme("tokyonight")
        return
      end
      
      -- Simple setup first
      colorbox.setup({
        -- Start with minimal config
        timing = "startup",
        policy = "shuffle",
      })
      
      -- Set initial colorscheme
      vim.schedule(function()
        local colors = { "tokyonight", "kanagawa", "catppuccin", "nightfox" }
        local color = colors[math.random(#colors)]
        pcall(vim.cmd.colorscheme, color)
      end)
    end,
    keys = {
      {
        "<leader>uc",
        function()
          local ok, colorbox = pcall(require, "colorbox")
          if ok and colorbox.shuffle then
            colorbox.shuffle()
            vim.notify("Colorscheme: " .. (vim.g.colors_name or "unknown"), vim.log.levels.INFO)
          else
            -- Fallback to manual shuffle
            local colors = { "tokyonight", "kanagawa", "catppuccin", "nightfox", "rose-pine", "onedark" }
            local color = colors[math.random(#colors)]
            pcall(vim.cmd.colorscheme, color)
            vim.notify("Colorscheme: " .. color, vim.log.levels.INFO)
          end
        end,
        desc = "Shuffle colorscheme",
      },
      {
        "<leader>uC",
        function()
          -- Simple colorscheme picker
          local colors = { "tokyonight", "kanagawa", "catppuccin", "nightfox", "rose-pine", "onedark", "gruvbox", "nord" }
          
          vim.ui.select(colors, {
            prompt = "Select colorscheme:",
          }, function(choice)
            if choice then
              pcall(vim.cmd.colorscheme, choice)
              vim.notify("Colorscheme: " .. choice, vim.log.levels.INFO)
            end
          end)
        end,
        desc = "Select colorscheme",
      },
    },
  },
  
  -- Alternative lightweight theme switcher with live preview
  {
    "zaldih/themery.nvim",
    enabled = false, -- Disabled by default, enable if you prefer this over colorbox
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "tokyonight",
          "tokyonight-moon",
          "tokyonight-day",
          "catppuccin",
          "catppuccin-latte",
          "catppuccin-frappe",
          "catppuccin-macchiato",
          "catppuccin-mocha",
          "kanagawa",
          "kanagawa-wave",
          "kanagawa-dragon",
          "kanagawa-lotus",
        },
        livePreview = true, -- Apply theme while picking
      })
    end,
    keys = {
      { "<leader>ut", "<cmd>Themery<cr>", desc = "Theme picker" },
    },
  },
}