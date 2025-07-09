return {
  "ramojus/mellifluous.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("mellifluous").setup({
      colorset = "mellifluous", -- "mellifluous", "alduin", "mountain", "tender", "kanagawa_dragon"
    })
  end,
}
