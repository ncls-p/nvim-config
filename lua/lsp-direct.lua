-- Configuration LSP directe sans plugin
local M = {}

function M.setup()
  -- Configuration des diagnostics
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Configuration Lua Language Server
  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.git', '.luarc.json' },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })

  -- Configuration VTSLS (TypeScript Language Server) - Simple
  vim.lsp.config('vtsls', {
    cmd = { 'vtsls', '--stdio' },
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    single_file_support = true,
    settings = {
      typescript = {
        preferences = {
          -- Disable VTSLS formatting in favor of Prettier
          disableFormatting = true,
        },
      },
      javascript = {
        preferences = {
          -- Disable VTSLS formatting in favor of Prettier
          disableFormatting = true,
        },
      },
    },
  })

  -- Configuration Basedpyright
  vim.lsp.config('basedpyright', {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', '.git' },
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  })

  -- Configuration Ruff
  vim.lsp.config('ruff', {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', '.git' },
  })

  -- Configuration Rust Language Server
  vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    settings = {
      ['rust-analyzer'] = {
        cargo = { buildScripts = { enable = true } },
        procMacro = { enable = true },
        checkOnSave = { command = 'clippy' },
      },
    },
  })

  -- Configuration C/C++ Language Server (clangd)
  vim.lsp.config('clangd', {
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', '.clangd', '.git' },
    single_file_support = true,
  })

  -- Configuration Zig Language Server
  vim.lsp.config('zls', {
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir' },
    root_markers = { 'zls.json', 'build.zig', '.git' },
    single_file_support = true,
  })

  -- Configuration Go Language Server
  vim.lsp.config('gopls', {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.work', 'go.mod', '.git' },
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
        semanticTokens = true,
      },
    },
  })

  -- Configuration R Language Server
  vim.lsp.config('r_language_server', {
    cmd = { 'R', '--slave', '-e', 'languageserver::run()' },
    filetypes = { 'r', 'rmd' },
    root_markers = { '.Rprofile', 'renv.lock', '.git' },
    single_file_support = true,
  })

  -- Configuration JSON Language Server
  vim.lsp.config('jsonls', {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { 'package.json', '.git' },
    single_file_support = true,
    settings = {
      json = {
        schemas = (function()
          local ok, schemastore = pcall(require, "schemastore")
          return ok and schemastore.json.schemas() or {}
        end)(),
        validate = { enable = true },
      },
    },
  })

  -- Configuration YAML Language Server
  vim.lsp.config('yamlls', {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yml' },
    root_markers = { '.git' },
    settings = {
      yaml = {
        schemas = {
          ['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*',
          ['https://json.schemastore.org/kustomization.json'] = 'kustomization.yaml',
          ['https://json.schemastore.org/chart.json'] = 'Chart.yaml',
        },
        validate = true,
        hover = true,
        completion = true,
      },
    },
  })

  -- Configuration Terraform Language Server
  vim.lsp.config('terraformls', {
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'tf', 'terraform-vars' },
    root_markers = { '.terraform', '.git' },
  })

  -- Configuration Dockerfile Language Server
  vim.lsp.config('dockerls', {
    cmd = { 'dockerfile-language-server-nodejs', '--stdio' },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile', 'dockerfile', '.git' },
    single_file_support = true,
  })

  -- Configuration Bash Language Server
  vim.lsp.config('bashls', {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash' },
    root_markers = { '.git' },
    single_file_support = true,
  })

  -- Configuration Markdown Language Server
  vim.lsp.config('marksman', {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'md' },
    root_markers = { '.marksman.toml', '.git' },
    single_file_support = true,
  })

  -- Configuration TOML Language Server
  vim.lsp.config('taplo', {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    root_markers = { '*.toml', '.git' },
    single_file_support = true,
  })

  -- Activation des serveurs
  vim.lsp.enable({
    'lua_ls',
    'vtsls',
    'basedpyright',
    'ruff',
    'rust_analyzer',
    'clangd',
    'zls',
    'gopls',
    'r_language_server',
    'jsonls',
    'yamlls',
    'terraformls',
    'dockerls',
    'bashls',
    'marksman',
    'taplo',
  })

  -- Keymaps
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' })
  -- Smart formatting for all languages
  vim.keymap.set('n', '<leader>cf', function()
    local filetype = vim.bo.filetype
    local filename = vim.api.nvim_buf_get_name(0)
    
    -- External formatter mappings
    local formatters = {
      -- Web languages - Prettier
      javascript = { 'prettier', '--stdin-filepath', filename },
      typescript = { 'prettier', '--stdin-filepath', filename },
      javascriptreact = { 'prettier', '--stdin-filepath', filename },
      typescriptreact = { 'prettier', '--stdin-filepath', filename },
      json = { 'prettier', '--stdin-filepath', filename },
      html = { 'prettier', '--stdin-filepath', filename },
      css = { 'prettier', '--stdin-filepath', filename },
      markdown = { 'prettier', '--stdin-filepath', filename },
      
      -- Systems languages
      rust = { 'rustfmt', '--emit=stdout' },
      c = { 'clang-format', '--style=file' },
      cpp = { 'clang-format', '--style=file' },
      go = { 'gofmt' },
      
      -- Scripts and configs
      sh = { 'shfmt', '-i', '2' },
      bash = { 'shfmt', '-i', '2' },
      yaml = { 'yamlfmt', '-' },
      yml = { 'yamlfmt', '-' },
      terraform = { 'terraform', 'fmt', '-' },
      tf = { 'terraform', 'fmt', '-' },
      
      -- Language-specific
      lua = { 'stylua', '-' },
    }
    
    local cmd = formatters[filetype]
    if cmd then
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local input = table.concat(lines, '\n')
      
      vim.fn.jobstart(cmd, {
        input = input,
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and #data > 0 and data[1] ~= '' then
            local formatted_lines = {}
            for _, line in ipairs(data) do
              if line ~= '' then
                table.insert(formatted_lines, line)
              end
            end
            if #formatted_lines > 0 then
              vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
              vim.notify('Formatted with ' .. cmd[1], vim.log.levels.INFO)
            end
          end
        end,
        on_stderr = function(_, data)
          if data and #data > 0 and data[1] ~= '' then
            vim.notify(cmd[1] .. ' error: ' .. table.concat(data, ' '), vim.log.levels.ERROR)
          end
        end,
      })
    else
      -- Use LSP formatting for languages without external formatter
      vim.lsp.buf.format({ async = true })
    end
  end, { desc = 'Smart Format' })

  -- VTSLS specific keymaps (via code actions)
  vim.keymap.set('n', '<leader>co', function()
    vim.lsp.buf.code_action({
      apply = true,
      filter = function(action)
        return action.title:match("Organize imports")
      end
    })
  end, { desc = 'Organize Imports (VTSLS)' })

  -- Diagnostics keymaps
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show Diagnostic' })
  vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Diagnostic Quickfix' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
  
  -- Force refresh diagnostics
  vim.keymap.set('n', '<leader>cR', function()
    vim.diagnostic.reset()
    vim.cmd('LspRestart')
    vim.notify('LSP restarted and diagnostics refreshed', vim.log.levels.INFO)
  end, { desc = 'Restart LSP and Refresh Diagnostics' })

  -- Commande debug
  vim.api.nvim_create_user_command('LspStatus', function()
    print("=== LSP STATUS ===")
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
      print("Aucun client LSP attaché")
    else
      for _, client in ipairs(clients) do
        print("Client: " .. client.name)
      end
    end
  end, {})

  -- LspAttach
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      end
    end,
  })

  -- Auto-format on save for all supported languages
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { 
      '*.js', '*.jsx', '*.ts', '*.tsx', '*.json', '*.html', '*.css', '*.md',  -- Web
      '*.rs',                                                                -- Rust
      '*.c', '*.cpp', '*.h', '*.hpp',                                       -- C/C++
      '*.go',                                                               -- Go
      '*.sh', '*.bash',                                                     -- Shell
      '*.yaml', '*.yml',                                                    -- YAML
      '*.tf', '*.tfvars',                                                   -- Terraform
      '*.lua',                                                              -- Lua
    },
    callback = function()
      -- Trigger the smart format function
      vim.cmd('silent! lua vim.keymap.set("n", "<leader>cf", function() end)() end')
      -- Actually just call LSP format for now to avoid complexity
      vim.lsp.buf.format({ timeout_ms = 1000 })
    end,
  })

end

return M