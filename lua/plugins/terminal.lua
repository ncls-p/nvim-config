return {
  -- Terminal management with toggleterm.nvim
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]], -- Toggle terminal with Ctrl+\
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "rounded", -- Rounded borders to match your theme
        winblend = 10, -- Transparency
        highlights = {
          border = "Normal",
          background = "Normal",
        },
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- Create specific terminal instances
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "rounded",
          width = function()
            return math.floor(vim.o.columns * 0.9)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.9)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })
      
      -- Claude Code terminal instances
      local claude_default = Terminal:new({
        cmd = "/Users/ncls/.claude/local/claude",
        direction = "float",
        float_opts = {
          border = "rounded",
          width = function()
            return math.floor(vim.o.columns * 0.85)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.85)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })
      
      local claude_continue = Terminal:new({
        cmd = "/Users/ncls/.claude/local/claude --continue",
        direction = "float",
        float_opts = {
          border = "rounded",
          width = function()
            return math.floor(vim.o.columns * 0.85)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.85)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })
      
      -- Node.js REPL
      local node = Terminal:new({
        cmd = "node",
        direction = "horizontal",
      })
      
      -- Python REPL
      local python = Terminal:new({
        cmd = "python3",
        direction = "horizontal",
      })
      
      -- Create functions to toggle terminals
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end
      
      function _CLAUDE_DEFAULT_TOGGLE()
        claude_default:toggle()
      end
      
      function _CLAUDE_CONTINUE_TOGGLE()
        claude_continue:toggle()
      end
      
      function _NODE_TOGGLE()
        node:toggle()
      end
      
      function _PYTHON_TOGGLE()
        python:toggle()
      end
      
      -- Terminal navigation improvements
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end
      
      -- Apply terminal keymaps when entering terminal
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
    keys = {
      -- Basic terminal toggles
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle floating terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle vertical terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Toggle terminal in new tab" },
      
      -- Specific terminal instances
      { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Toggle Lazygit" },
      { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", desc = "Toggle Node REPL" },
      { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", desc = "Toggle Python REPL" },
      
      -- Claude Code terminals
      { "<leader>cc", "<cmd>lua _CLAUDE_DEFAULT_TOGGLE()<CR>", desc = "Toggle Claude Code" },
      { "<leader>cC", "<cmd>lua _CLAUDE_CONTINUE_TOGGLE()<CR>", desc = "Toggle Claude Code (Continue)" },
      
      -- Terminal management
      { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", desc = "Toggle all terminals" },
      { "<leader>tk", "<cmd>ToggleTermKillAll<cr>", desc = "Kill all terminals" },
    },
  },
  
  -- Enhanced terminal buffer management
  {
    "willothy/flatten.nvim",
    config = true,
    lazy = false,
    priority = 1001,
    opts = {
      window = {
        open = "alternate",
      },
    },
  },
}