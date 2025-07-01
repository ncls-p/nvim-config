return {
  -- Smooth scrolling plugin for modern feel
  {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    opts = {
      -- Modern cinnamon.nvim configuration (updated API)
      keymaps = {
        basic = true,
        extra = true,
      },
      options = {
        mode = "cursor", -- Use cursor mode for smoother scrolling
        max_delta = {
          line = 100,    -- Back to original
          column = 100,
          time = 1000,   -- Back to original
        },
        delay = 7,       -- Back to original
      },
    },
    config = function(_, opts)
      require("cinnamon").setup(opts)

      -- Custom smooth scroll mappings
      local cinnamon = require("cinnamon")

      -- Mouse scroll improvements
      vim.keymap.set({ "n", "x" }, "<ScrollWheelUp>", function()
        cinnamon.scroll("<C-u><C-u><C-u>")
      end, { silent = true })

      vim.keymap.set({ "n", "x" }, "<ScrollWheelDown>", function()
        cinnamon.scroll("<C-d><C-d><C-d>")
      end, { silent = true })

      -- Regular page scrolling disabled - using default Vim behavior
    end,
  },
}

