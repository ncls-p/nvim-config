return {
  -- Mini.animate for smooth animations
  {
    "echasnovski/mini.animate",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.animate").setup({
        cursor = {
          enable = true,
          timing = function(_, n)
            return 150 / n
          end,
        },
        scroll = {
          enable = true,
          timing = function(_, n)
            return 150 / n
          end,
        },
        resize = {
          enable = true,
          timing = function(_, n)
            return 150 / n
          end,
        },
        open = {
          enable = true,
          timing = function(_, n)
            return 150 / n
          end,
        },
        close = {
          enable = true,
          timing = function(_, n)
            return 150 / n
          end,
        },
      })
    end,
  },
}