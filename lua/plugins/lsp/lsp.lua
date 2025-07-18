-- Neovim 0.11 Native LSP Configuration
-- Using the official vim.lsp.enable() method with lsp/ folder configurations

return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Language servers (trending 2025)
        "lua-language-server",        -- Lua LSP
        "vtsls",                      -- TypeScript/JavaScript (Vue/TS Language Server)
        "basedpyright",               -- Python type checking
        "ruff",                       -- Python linting/formatting (Rust-based)
        "rust-analyzer",              -- Rust (standard)
        "clangd",                     -- C/C++ (Google, most maintained)
        "zls",                        -- Zig (only option)
        "gopls",                      -- Go (official, monopoly)
        "r-languageserver",           -- R (standard)
        "json-lsp",                   -- JSON
        "yaml-language-server",       -- YAML (Red Hat)
        "terraform-ls",               -- Terraform (HashiCorp official)
        "dockerfile-language-server", -- Docker
        "bash-language-server",       -- Bash/Shell
        "marksman",                   -- Markdown
        "taplo",                      -- TOML
        -- Formatters (best-in-class 2025)
        "stylua",                     -- Lua formatter
        "prettier",                   -- JS/TS/JSON/HTML/CSS/MD
        "clang-format",               -- C/C++
        "goimports",                  -- Go imports (includes gofmt)
        "shfmt",                      -- Shell scripts
        "yamlfmt",                    -- YAML
        -- Linters (trending)
        "eslint_d",                   -- JavaScript/TypeScript (daemon)
        "shellcheck",                 -- Shell scripts
        "hadolint",                   -- Dockerfile
        "markdownlint",               -- Markdown
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Native LSP Configuration
  {
    name = "native-lsp",
    dir = vim.fn.stdpath("config"),
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>cl",
        function()
          -- Commande native pour voir les clients LSP attachés
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
          else
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            vim.notify("LSP clients: " .. table.concat(names, ", "), vim.log.levels.INFO)
          end
        end,
        desc = "LSP Info"
      },
      { "]d",         vim.diagnostic.goto_next,  desc = "Next Diagnostic" },
      { "[d",         vim.diagnostic.goto_prev,  desc = "Previous Diagnostic" },
      { "<leader>cd", vim.diagnostic.open_float, desc = "Show Diagnostic" },
      { "<leader>cq", vim.diagnostic.setloclist, desc = "Diagnostic Quickfix" },
    },
    config = function()
      -- Configure diagnostics
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Configure LSP servers directly (simple approach)

      -- Lua Language Server
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', '.git' },
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              },
            },
            completion = { callSnippet = 'Replace' },
            telemetry = { enable = false },
          },
        },
      })

      -- TypeScript Language Server
      vim.lsp.config('ts_ls', {
        cmd = { 'vtsls', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
        single_file_support = true,
      })

      -- Python Language Server (Basedpyright) - Modern configuration
      vim.lsp.config('basedpyright', {
        cmd = { 'basedpyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
        single_file_support = true,
        on_new_config = function(config, root_dir)
          -- Simple venv detection - basedpyright handles most of this automatically
          local venv = vim.fn.finddir('.venv', root_dir .. ';')
          if venv ~= '' then
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = venv .. '/bin/python'
          end
        end,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
              autoImportCompletions = true,
              typeCheckingMode = "standard",
            },
          },
        },
      })

      -- Configuration Ruff (linting/formatting seulement)
      vim.lsp.config('ruff', {
        cmd = { 'ruff', 'server' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
        single_file_support = true,
        settings = {
          ruff = {
            lint = {
              enable = true,
            },
            format = {
              enable = true,
            },
          },
        },
      })

      -- Swift Language Server (SourceKit-LSP)
      vim.lsp.config('sourcekit', {
        cmd = { 'sourcekit-lsp' },
        filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
        root_markers = { 'Package.swift', '.git', 'compile_commands.json' },
        single_file_support = true,
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      })

      -- Rust Language Server (rust-analyzer)
      vim.lsp.config('rust_analyzer', {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json' },
        single_file_support = false,
        settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = {
              command = 'clippy',
            },
            procMacro = {
              enable = true,
            },
          },
        },
      })

      -- Marksman (Markdown LSP) configuration
      vim.lsp.config('marksman', {
        cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/marksman'), 'server' },
        filetypes = { 'markdown', 'markdown.mdx' },
        root_markers = { '.marksman.toml', '.git' },
        single_file_support = true,
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true
            }
          }
        }
      })

      -- JSON Language Server configuration
      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc', 'jsonl' },
        root_markers = { '.git', 'package.json' },
        single_file_support = true,
        init_options = {
          provideFormatter = true,
        },
        settings = {
          json = {
            validate = { enable = true },
            format = {
              enable = true,
            },
          },
        },
      })

      -- Enable LSP servers
      vim.lsp.enable({ 'lua_ls', 'ts_ls', 'basedpyright', 'ruff', 'sourcekit', 'rust_analyzer', 'marksman', 'jsonls' })

      -- Commande de diagnostic LSP
      vim.api.nvim_create_user_command('LspDebug', function()
        print("=== LSP DEBUG INFO ===")

        -- Configurations chargées
        print("Configurations LSP:")
        local configs = 0
        for name, config in pairs(vim.lsp.config) do
          if type(config) == "table" and config.cmd then
            print("  ✓ " .. name .. ": " .. table.concat(config.cmd or {}, " "))
            configs = configs + 1
          end
        end
        if configs == 0 then
          print("  ✗ Aucune configuration trouvée")
        end

        -- Clients actifs
        print("\nClients LSP actifs:")
        local clients = vim.lsp.get_clients()
        if #clients == 0 then
          print("  ✗ Aucun client actif")
        else
          for _, client in ipairs(clients) do
            print("  ✓ " .. client.name .. " (ID: " .. client.id .. ")")
          end
        end

        -- Clients pour le buffer actuel
        print("\nClients pour le buffer actuel:")
        local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
        if #buf_clients == 0 then
          print("  ✗ Aucun client attaché au buffer")
        else
          for _, client in ipairs(buf_clients) do
            print("  ✓ " .. client.name)
          end
        end

        print("=== FIN DEBUG ===")
      end, { desc = "Debug LSP configuration and clients" })

      -- Configuration pour éviter les conflits entre Ruff et Basedpyright
      vim.api.nvim_create_autocmd('LspAttach', {
        pattern = '*.py',
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            -- Ruff : seulement linting et formatting
            if client.name == 'ruff' then
              client.server_capabilities.hoverProvider = false
              client.server_capabilities.definitionProvider = false
              client.server_capabilities.referencesProvider = false
              client.server_capabilities.completionProvider = false
            end
            -- Basedpyright : seulement type checking et completion
            if client.name == 'basedpyright' then
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
          end
        end,
      })

      -- LspAttach autocommand for buffer-specific configuration
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          -- Set up LSP keybindings (buffer-specific)
          local opts = { buffer = bufnr, silent = true }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = "Go to Definition" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = "References" }))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
            vim.tbl_extend('force', opts, { desc = "Go to Declaration" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
            vim.tbl_extend('force', opts, { desc = "Go to Implementation" }))
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition,
            vim.tbl_extend('force', opts, { desc = "Go to Type Definition" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = "Hover" }))
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help,
            vim.tbl_extend('force', opts, { desc = "Signature Help" }))
          vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help,
            vim.tbl_extend('force', opts, { desc = "Signature Help" }))
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
            vim.tbl_extend('force', opts, { desc = "Code Action" }))
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = "Rename" }))
          vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = "Format" }))

          -- Enable completion if supported
          if client and client.supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
          end

          -- Auto-format on save if supported
          if client and client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                -- Use rustup for Rust formatting instead of Mason
                if vim.bo.filetype == 'rust' then
                  vim.cmd('silent! !rustup run stable rustfmt %')
                  vim.cmd('edit!')
                else
                  vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 1000 })
                end
              end,
            })
          end
        end,
      })

      -- Better handlers for hover and signature help
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
    end,
  },
}

