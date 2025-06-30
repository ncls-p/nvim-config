return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        signs = {
          left = "",
          right = "",
          diag = "●",
          arrow = "    ",
          up_arrow = "    ",
          vertical = " │",
          vertical_end = " └",
        },
        hi = {
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
          arrow = "NonText",
          background = "CursorLine",
          mixing_color = "None",
        },
        blend = {
          factor = 0.27,
        },
        options = {
          show_source = false,
          throttle = 35,
          softwrap = 15,
          multilines = false,
          overflow = {
            mode = "wrap",
          },
          format = nil,
          break_line = {
            enabled = false,
            after = 30,
          },
          virt_texts = {
            priority = 2048,
          },
        },
      })
    end,
  },
}