return {
  -- Remote SSH editing
  {
    "inhesrom/remote-ssh.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim", 
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require('remote-ssh').setup({
        -- LSP configuration
        on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          
          -- Note: LSP keymaps are already defined in lsp.lua
          -- This plugin will use the global LSP keymaps
        end,

        -- LSP capabilities
        capabilities = vim.lsp.protocol.make_client_capabilities(),

        -- Map file types to LSP servers
        filetype_to_server = {
          python = "basedpyright",
          lua = "lua_ls",
          typescript = "vtsls",
          javascript = "vtsls",
          go = "gopls",
          rust = "rust_analyzer",
          c = "clangd",
          cpp = "clangd",
        },

        -- Custom server configurations
        server_configs = {
          clangd = {
            filetypes = { "c", "cpp" },
            root_patterns = { ".git", "compile_commands.json" }
          },
          basedpyright = {
            filetypes = { "python" },
            root_patterns = { ".git", "pyproject.toml", "setup.py" }
          },
          lua_ls = {
            filetypes = { "lua" },
            root_patterns = { ".git", ".luarc.json" }
          }
        },

        -- Async write settings
        async_write_opts = {
          timeout = 30,
          debug = false,
          log_level = vim.log.levels.INFO
        }
      })
    end,
  },
}