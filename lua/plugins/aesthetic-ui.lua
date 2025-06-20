return {
  -- 🎨 Noice.nvim - Revolutionary UI overhaul (2025 trending)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  -- ✨ Notify - Beautiful notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
      background_colour = "#000000",
      fps = 60,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = ""
      },
      level = 2,
      minimum_width = 50,
      render = "compact",
      stages = "fade_in_slide_out",
      time_formats = {
        notification = "%T",
        notification_history = "%FT%T"
      },
      top_down = true
    },
  },

  -- 🔮 Cellular Automaton - Mind-blowing animations
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
      {
        "<leader>fml",
        function()
          -- Enhanced buffer checks for tree-sitter compatibility
          local excluded_filetypes = {
            "", "dashboard", "alpha", "neo-tree", "NvimTree", "oil", 
            "trouble", "Trouble", "lazy", "mason", "notify", "toggleterm",
            "lazyterm", "help", "qf", "quickfix", "TelescopePrompt",
            "TelescopeResults", "which-key", "noice", "starter"
          }
          
          if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
            vim.notify("🌧️ Open a code file to see the rain animation!", vim.log.levels.INFO)
            return
          end
          
          vim.cmd("CellularAutomaton make_it_rain")
        end,
        desc = "Make it rain ☔"
      },
      {
        "<leader>gol",
        function()
          -- Enhanced buffer checks for tree-sitter compatibility
          local excluded_filetypes = {
            "", "dashboard", "alpha", "neo-tree", "NvimTree", "oil", 
            "trouble", "Trouble", "lazy", "mason", "notify", "toggleterm",
            "lazyterm", "help", "qf", "quickfix", "TelescopePrompt",
            "TelescopeResults", "which-key", "noice", "starter"
          }
          
          if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
            vim.notify("🧬 Open a code file to see the Game of Life!", vim.log.levels.INFO)
            return
          end
          
          vim.cmd("CellularAutomaton game_of_life")
        end,
        desc = "Game of Life 🧬"
      },
    },
  },

  -- 🌊 Smooth scrolling with modern aesthetics
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require('neoscroll').setup({
        mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                    '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "quadratic",
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end
  },

  -- 💫 Rainbow delimiters for beautiful bracket matching
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

  -- 🎭 Indent blankline with beautiful aesthetics
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },

  -- 🌟 Mini.animate for subtle animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },

  -- 🎨 Highlight colors in code
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = false,
        AARRGGBB = true,
        rgb_fn = false,
        hsl_fn = false,
        css = false,
        css_fn = false,
        mode = "background",
        tailwind = false,
        sass = { enable = false, parsers = { "css" }, },
        virtualtext = "■",
        always_update = false
      },
      buftypes = {},
    }
  },

  -- 💎 Beautiful startup screen
  {
    "folke/drop.nvim",
    event = "VimEnter",
    config = function()
      require("drop").setup({
        theme = "auto",
        max = 40,
        interval = 150,
        screensaver = 1000 * 60 * 5,
        filetypes = { "dashboard", "alpha", "starter" },
      })
    end,
  },

  -- 🔥 Simple fidget for LSP progress
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
}