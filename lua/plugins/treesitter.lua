return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          if require("config.util").is_loaded("nvim-treesitter") then
            local opts = require("config.util").opts("nvim-treesitter")
            require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
          end

          local move = require("nvim-treesitter.textobjects.move")
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name]
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "scala",
        "swift",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ii"] = "@conditional.inner",
            ["ai"] = "@conditional.outer",
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
            ["at"] = "@comment.outer",
          },
        },
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
}

