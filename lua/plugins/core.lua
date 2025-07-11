return {
  -- Mini.pick for fuzzy finding
  {
    "echasnovski/mini.pick",
    version = false,
    keys = {
      { "<leader>ff", function() require("mini.pick").builtin.files() end,                                      desc = "Find Files" },
      { "<leader>fg", function() require("mini.pick").builtin.grep_live() end,                                  desc = "Live Grep" },
      { "<leader>fb", function() require("mini.pick").builtin.buffers() end,                                    desc = "Buffers" },
      { "<leader>fh", function() require("mini.pick").builtin.help() end,                                       desc = "Help Tags" },
      { "<leader>fr", function() require("mini.pick").builtin.resume() end,                                     desc = "Resume Last" },
      { "<leader>fs", function() require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, desc = "Grep String" },
      { "<leader>fd", function() require("mini.pick").builtin.diagnostic() end,                                 desc = "Diagnostics" },
    },
    config = function()
      local get_git_status = function(path)
        if vim.fn.executable("git") == 1 then
          local git_status = vim.fn.system("git status --porcelain " .. vim.fn.shellescape(path)):gsub("\n", "")
          if git_status ~= "" then
            local first_char = git_status:sub(1, 1)
            local second_char = git_status:sub(2, 2)
            if first_char == "M" or second_char == "M" then
              return "~ "
            elseif first_char == "A" or second_char == "A" then
              return "+ "
            elseif first_char == "D" or second_char == "D" then
              return "- "
            elseif first_char == "?" then
              return "? "
            end
          end
        end
        return ""
      end
      
      local get_lsp_status = function(path)
        local bufnr = vim.fn.bufnr(path)
        if bufnr ~= -1 then
          local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
          if #diagnostics > 0 then
            return " "
          end
        end
        return ""
      end
      
      require("mini.pick").setup({
        options = {
          use_cache = true,
        },
        mappings = {
          move_down = "<C-j>",
          move_up = "<C-k>",
          choose_in_split = "<C-s>",
          choose_in_vsplit = "<C-v>",
          choose_in_tabpage = "<C-t>",
        },
        window = {
          config = {
            border = "rounded",
            width = math.floor(0.8 * vim.o.columns),
            height = math.floor(0.8 * vim.o.lines),
          },
        },
        source = {
          show = function(buf_id, items, query)
            -- Custom display for file items
            for i, item in ipairs(items) do
              if item.path then
                local git_status = get_git_status(item.path)
                local lsp_status = get_lsp_status(item.path)
                local prefix = git_status .. lsp_status
                
                -- Update the display text
                if prefix ~= "" then
                  item.text = prefix .. item.text
                end
              end
            end
            
            -- Use default show function
            return require("mini.pick").default_show(buf_id, items, query)
          end,
        },
      })
    end,
  },

  -- Mini.files for file exploration
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      { "<leader>e", function() require("mini.files").open() end,                             desc = "Open File Explorer" },
      { "<leader>E", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "Open File Explorer (current file)" },
    },
    config = function()
      require("mini.files").setup({
        content = {
          filter = function(entry)
            return entry.name ~= '.DS_Store' and entry.name ~= '.git'
          end,
          prefix = function(fs_entry)
            local path = fs_entry.path
            local name = fs_entry.name
            local prefix = ""
            
            -- Add git status indicators
            if vim.fn.executable("git") == 1 then
              local git_status = vim.fn.system("git status --porcelain " .. vim.fn.shellescape(path)):gsub("\n", "")
              if git_status ~= "" then
                local first_char = git_status:sub(1, 1)
                local second_char = git_status:sub(2, 2)
                if first_char == "M" or second_char == "M" then
                  prefix = prefix .. "~ "
                elseif first_char == "A" or second_char == "A" then
                  prefix = prefix .. "+ "
                elseif first_char == "D" or second_char == "D" then
                  prefix = prefix .. "- "
                elseif first_char == "?" then
                  prefix = prefix .. "? "
                end
              end
            end
            
            -- Add LSP diagnostic indicators for files
            if fs_entry.fs_type == "file" then
              local bufnr = vim.fn.bufnr(path)
              if bufnr ~= -1 then
                local diagnostics = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
                if #diagnostics > 0 then
                  prefix = prefix .. " "
                end
              end
            end
            
            return prefix
          end,
        },
        windows = {
          preview = true,
          width_focus = 35,
          width_preview = 50,
        },
        options = {
          permanent_delete = true,
        },
      })

      -- Auto-close when opening file
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          vim.schedule(function()
            require("mini.files").close()
          end)
        end,
      })
    end,
  },

  -- Mini.clue for key hints
  {
    "echasnovski/mini.clue",
    version = false,
    event = "VeryLazy",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "n", keys = "<C-r>" },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },
          { mode = "n", keys = "<C-w>" },
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        clues = {
          { mode = "n", keys = "<Leader>c",  desc = "+Code" },
          { mode = "n", keys = "<Leader>cc", desc = "+Claude" },
          { mode = "n", keys = "<Leader>f",  desc = "+File/Find" },
          { mode = "n", keys = "<Leader>g",  desc = "+Git" },
          { mode = "n", keys = "<Leader>t",  desc = "+Terminal" },
          { mode = "n", keys = "<Leader>u",  desc = "+UI" },
          { mode = "n", keys = "<Leader>b",  desc = "+Buffer" },
          { mode = "n", keys = "<Leader>x",  desc = "+Trouble" },
          { mode = "n", keys = "<Leader>m",  desc = "+Multicursor" },
          { mode = "n", keys = "<Leader>a",  desc = "+AI" },
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          delay = 250,
          config = {
            border = "rounded",
            width = "auto",
          },
        },
      })
    end,
  },


  -- Better vim.ui with rounded borders
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      input = {
        -- Modern rounded border
        border = "rounded",
        title_pos = "left",
        insert_only = true,
        start_in_insert = true,
        winblend = 10,
      },
      select = {
        -- Use mini.pick for selections
        backend = { "builtin", "nui" },
        nui = {
          border = {
            style = "rounded",
          },
          winblend = 10,
        },
        builtin = {
          border = "rounded",
          winblend = 10,
        },
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },


  -- Better diagnostics list and others
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
    opts = {
      focus = true,
      modes = {
        preview_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = { width = 0.8, height = 0.6 },
            zindex = 200,
          },
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },


}
