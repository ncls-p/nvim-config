return {
  -- Mini.statusline
  {
    "echasnovski/mini.statusline",
    version = false,
    event = "VeryLazy",
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 75 })
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local location = statusline.section_location({ trunc_width = 75 })
            local search = statusline.section_searchcount({ trunc_width = 75 })
            
            -- Custom time section
            local time = function()
              return os.date("%H:%M")
            end
            
            return statusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
              { hl = 'MiniStatuslineModeOther', strings = { time() } },
            })
          end,
          inactive = function()
            return statusline.combine_groups({
              { hl = 'MiniStatuslineInactive', strings = { statusline.section_filename() } },
            })
          end,
        },
        use_icons = true,
        set_vim_settings = true,
      })
    end,
  },

  -- Mini.notify for notifications
  {
    "echasnovski/mini.notify",
    version = false,
    keys = {
      {
        "<leader>un",
        function()
          require("mini.notify").clear()
        end,
        desc = "Clear all notifications",
      },
    },
    config = function()
      require("mini.notify").setup({
        content = {
          format = function(notif)
            return notif.msg
          end,
        },
        window = {
          config = {
            border = "rounded",
          },
          max_width_share = 0.382,
          winblend = 25,
        },
        lsp_progress = {
          enable = true,
          duration_last = 1000,
        },
      })
      vim.notify = require("mini.notify").make_notify()
    end,
  },

  -- UI components (keep minimal dependencies)
  { "MunifTanjim/nui.nvim", lazy = true },
}