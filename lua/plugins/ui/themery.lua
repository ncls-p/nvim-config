return {
  -- Theme manager
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "default",
          "habamax",
          "oldworld",
          "scholar",
          "mellifluous",
          "zenbones",
          "kanso",
          "onenord",
          "oxocarbon",
          "tokyonight-day",
          "tokyonight-moon",
          "tokyonight-night",
          "tokyonight-storm",
        },
        livePreview = true, -- Apply theme while browsing
      })
    end,
    keys = {
      { "<leader>uT", "<cmd>Themery<cr>", desc = "🎨 Theme manager" },
    },
  },
}
