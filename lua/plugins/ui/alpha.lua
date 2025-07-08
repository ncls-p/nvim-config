return {
  -- Alpha dashboard (cool animated landing page)
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ASCII art logo
      dashboard.section.header.val = {
        [[                                                     ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        [[                                                     ]],
        [[              🚀 Ready for Development 🚀            ]],
      }

      -- Menu buttons
      dashboard.section.buttons.val = {
        dashboard.button("f", "🔍 Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "📄 New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "📚 Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "🔎 Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "⚙️  Configuration", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "💾 Sessions", ":Telescope session-lens search_session <CR>"),
        dashboard.button("l", "🔌 Lazy", ":Lazy<CR>"),
        dashboard.button("m", "🛠️  Mason", ":Mason<CR>"),
        dashboard.button("h", "❤️  Health", ":checkhealth<CR>"),
        dashboard.button("q", "❌ Quit", ":qa<CR>"),
      }

      -- Footer
      local function footer()
        local datetime = os.date("📅 %Y-%m-%d  🕒 %H:%M:%S")
        local version = vim.version()
        local nvim_version = "Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch
        return {
          "",
          "✨ " .. nvim_version .. " ✨",
          datetime,
          "🔥 Happy Coding! 🔥",
        }
      end

      dashboard.section.footer.val = footer()

      -- Header colors
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      -- Layout
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      -- Disable folding on alpha buffer
      dashboard.config.opts.noautocmd = true

      -- Setup alpha
      alpha.setup(dashboard.config)

      -- Custom highlights
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
          vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#bb9af7" })
          vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#565f89", italic = true })
        end,
      })

      -- Hide statusline and tabline on alpha buffer
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt.laststatus = 0
          vim.opt.showtabline = 0
        end,
      })

      vim.api.nvim_create_autocmd("BufUnload", {
        buffer = 0,
        callback = function()
          vim.opt.laststatus = 3
          vim.opt.showtabline = 2
        end,
      })
    end,
  },
}