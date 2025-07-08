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
          
          -- Mappings
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
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