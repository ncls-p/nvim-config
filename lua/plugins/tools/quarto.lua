return {
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "markdown", "ipynb" },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          chunks = "curly",
          languages = { "r", "python", "julia", "bash", "html" },
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" }
          },
          completion = {
            enabled = true
          }
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
          ft_runners = { 
            python = "molten"
          },
          never_run = { "yaml" }
        }
      })

      -- LSP keybindings for notebook cells
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Set up autocmd for quarto, markdown, and ipynb files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "quarto", "markdown", "ipynb" },
        callback = function()
          -- Delay activation for jupytext conversion to complete
          vim.defer_fn(function()
            -- Activate otter for embedded code blocks
            local otter = require("otter")
            otter.activate({"python", "r", "julia", "bash"})
          end, 100)
          
          -- Quarto-specific functions (using leader m to match molten)
          map("n", "<leader>mc", require("quarto.runner").run_cell, { desc = "Run cell" })
          map("n", "<leader>ma", require("quarto.runner").run_above, { desc = "Run above" })
          map("n", "<leader>mA", require("quarto.runner").run_all, { desc = "Run all" })
        end,
      })
    end,
  },
  {
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      lsp = {
        hover = {
          border = "rounded",
        },
      },
      buffers = {
        set_filetype = true,
        write_to_disk = false,
      },
      strip_wrapping_quote_characters = { "'", '"', "`" },
    },
  },
}