return {
  -- Theme manager
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "tokyonight-night",
          "tokyonight-storm", 
          "tokyonight-day",
          "tokyonight-moon",
          "onenord",
          "oxocarbon",
          "default",
          "habamax",
        },
        livePreview = true, -- Apply theme while browsing
      })
    end,
    keys = {
      { "<leader>uT", "<cmd>Themery<cr>", desc = "🎨 Theme manager" },
    },
  },
}