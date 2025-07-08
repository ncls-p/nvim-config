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

  -- Configuration TypeScript Language Server
  vim.lsp.config('vtsls', {
    cmd = { 'vtsls', '--stdio' },
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    single_file_support = true,
  })

  -- Configuration Python Language Server
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

  -- Configuration JSON Language Server
  vim.lsp.config('jsonls', {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { 'package.json', '.git' },
    single_file_support = true,
  })

  -- Configuration Markdown Language Server
  vim.lsp.config('marksman', {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'md' },
    root_markers = { '.marksman.toml', '.git' },
    single_file_support = true,
  })

  -- Activation des serveurs
  vim.lsp.enable({
    'lua_ls',
    'vtsls',
    'basedpyright',
    'ruff',
    'jsonls',
    'marksman',
  })

  -- Keymaps
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' })
  vim.keymap.set('n', '<leader>cf', function()
    vim.lsp.buf.format({ async = true })
  end, { desc = 'Format' })

  -- Diagnostics keymaps
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show Diagnostic' })
  vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Diagnostic Quickfix' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })

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

  -- Auto-format on save for supported languages
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = {
      '*.js', '*.jsx', '*.ts', '*.tsx', '*.json', '*.md',
      '*.py',
      '*.lua',
    },
    callback = function()
      vim.lsp.buf.format({ timeout_ms = 1000 })
    end,
  })
end

return M

