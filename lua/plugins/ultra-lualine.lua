return {
  -- 🚀 Ultra Modern Lualine with Beautiful Components
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/noice.nvim",
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "
      else
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      -- Beautiful icons
      local icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = "󰌶 ",
          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        misc = {
          dots = "󰇘",
        },
      }

      -- Custom components
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      -- LSP clients component
      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return "󰅞 No LSP"
        end

        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        return "󰒋 " .. table.concat(client_names, " ")
      end

      -- Macro recording component
      local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
          return ""
        else
          return "Recording @" .. recording_register
        end
      end

      -- Weather component (if you want to add it)
      local function weather()
        return "🌤️ 22°C"
      end

      -- Current time
      local function current_time()
        return " " .. os.date("%H:%M")
      end

      -- File size
      local function file_size()
        local size = vim.fn.getfsize(vim.fn.expand("%"))
        if size < 0 then return "" end
        local suffixes = { "B", "KB", "MB", "GB" }
        local i = 1
        while size > 1024 and i < #suffixes do
          size = size / 1024
          i = i + 1
        end
        return string.format("%.1f%s", size, suffixes[i])
      end

      -- Python virtual env
      local function python_venv()
        local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV
        if venv then
          return "🐍 " .. vim.fn.fnamemodify(venv, ":t")
        end
        return ""
      end

      -- Cool separators
      local separators = {
        left = "",
        right = "",
      }

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" },
          },
          section_separators = separators,
          component_separators = { left = "", right = "" },
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return str:sub(1, 1) -- Show only first character
              end,
              separator = separators,
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "",
              color = { fg = "#BB9AF7", gui = "bold" },
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = diff_source,
              colored = true,
            },
          },
          lualine_c = {
            {
              function()
                local root = vim.fn.getcwd()
                return "📁 " .. vim.fn.fnamemodify(root, ":t")
              end,
              color = { fg = "#7DCFFF", gui = "bold" },
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
            },
            {
              "filename",
              path = 1,
              symbols = {
                modified = "  ",
                readonly = " 󰌾 ",
                unnamed = " 󰈙 ",
                newfile = " 󰝒 ",
              },
              color = { gui = "bold" },
            },
            {
              file_size,
              color = { fg = "#9ECE6A" },
              cond = function()
                return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
              end,
            },
          },
          lualine_x = {
            {
              show_macro_recording,
              color = { fg = "#FF9E64", gui = "bold" },
            },
            {
              python_venv,
              color = { fg = "#F7768E" },
              cond = function()
                return vim.bo.filetype == "python"
              end,
            },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = { fg = "#BB9AF7" },
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = { fg = "#7AA2F7" },
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = { fg = "#F7768E" },
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = "#E0AF68" },
            },
            {
              lsp_clients,
              color = { fg = "#9ECE6A" },
              cond = function()
                return #vim.lsp.get_clients({ bufnr = 0 }) > 0
              end,
            },
          },
          lualine_y = {
            {
              "filetype",
              colored = true,
              icon_only = false,
              icon = { align = "right" },
              padding = { left = 1, right = 0 },
            },
            {
              "encoding",
              color = { fg = "#7DCFFF" },
              cond = function()
                return vim.bo.fileencoding ~= "utf-8"
              end,
            },
            {
              "fileformat",
              symbols = {
                unix = "󰌽",
                dos = "󰍲",
                mac = "󰀵",
              },
              color = { fg = "#7DCFFF" },
            },
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 0 },
              color = { fg = "#BB9AF7" },
            },
            {
              "location",
              padding = { left = 0, right = 1 },
              color = { fg = "#BB9AF7", gui = "bold" },
            },
          },
          lualine_z = {
            {
              current_time,
              color = { fg = "#F7768E", gui = "bold" },
              separator = separators,
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          "neo-tree",
          "lazy",
          "toggleterm",
          "mason",
          "trouble",
          "quickfix",
        },
      }
    end,
  },

  -- 🎵 Lualine theme sync
  {
    "linrongbin16/lsp-progress.nvim",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lsp-progress").setup({
        client_format = function(client_name, spinner, series_messages)
          if #series_messages == 0 then
            return nil
          end
          return {
            name = client_name,
            body = spinner .. " " .. table.concat(series_messages, ", "),
          }
        end,
        format = function(client_messages)
          --- @param name string
          --- @param msg string?
          --- @return string
          local function stringify(name, msg)
            return msg and string.format("%s %s", name, msg) or name
          end

          local sign = "🚀" -- nf-fa-gear \uf013
          local lsp_clients = vim.lsp.get_clients()
          local messages_map = {}
          for _, climsg in ipairs(client_messages) do
            messages_map[climsg.name] = climsg.body
          end

          if #lsp_clients > 0 then
            table.sort(lsp_clients, function(a, b)
              return a.name < b.name
            end)
            local builder = {}
            for _, cli in ipairs(lsp_clients) do
              if type(cli) == "table" and type(cli.name) == "string" and string.len(cli.name) > 0 then
                if messages_map[cli.name] then
                  table.insert(builder, stringify(cli.name, messages_map[cli.name]))
                else
                  table.insert(builder, stringify(cli.name))
                end
              end
            end
            if #builder > 0 then
              return sign .. " " .. table.concat(builder, ", ")
            end
          end
          return ""
        end,
      })
    end,
  },
}

