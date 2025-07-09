return {
  "abreujp/scholar.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("scholar").setup({
      contrast = "", -- "", "soft", "hard"
    })
  end,
}
