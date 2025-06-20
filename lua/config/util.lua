local M = {}

M.format = {
  enabled = true,
}

M.icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
}

function M.format.register(formatter)
  if not M.format.formatters then
    M.format.formatters = {}
  end
  table.insert(M.format.formatters, formatter)
end

function M.format.toggle(buf)
  local buf_local = buf and true or false
  if buf_local then
    if vim.b.autoformat == nil then
      vim.b.autoformat = M.format.enabled
    end
    vim.b.autoformat = not vim.b.autoformat
  else
    M.format.enabled = not M.format.enabled
  end
  vim.notify(
    string.format("Auto format %s %s", M.format.enabled and "enabled" or "disabled", buf_local and "(buffer)" or "(global)")
  )
end

function M.get_format_enabled(buf)
  if vim.b[buf].autoformat ~= nil then
    return vim.b[buf].autoformat
  end
  return M.format.enabled
end

function M.toggle(option, silent, values)
  if values then
    if type(values) == "boolean" then
      values = { true, false }
    end
    local value = vim.opt_local[option]:get()
    local idx = vim.tbl_indexof(values, value)
    if idx then
      value = values[idx % #values + 1]
    else
      value = values[1]
    end
    vim.opt_local[option] = value
  else
    vim.opt_local[option] = not vim.opt_local[option]:get()
  end
  if not silent then
    vim.notify(string.format("Set %s to %s", option, vim.opt_local[option]:get()))
  end
end

function M.toggle_number()
  if vim.opt_local.number:get() then
    vim.opt_local.number = false
  else
    vim.opt_local.number = true
  end
  vim.notify(string.format("Line numbers %s", vim.opt_local.number:get() and "enabled" or "disabled"))
end

function M.toggle_diagnostics()
  local enabled = vim.diagnostic.is_disabled()
  if enabled then
    vim.diagnostic.enable()
    vim.notify("Diagnostics enabled")
  else
    vim.diagnostic.disable()
    vim.notify("Diagnostics disabled")
  end
end

function M.toggle_inlay_hints()
  local buf = vim.api.nvim_get_current_buf()
  if vim.lsp.inlay_hint then
    if vim.lsp.inlay_hint.is_enabled(buf) then
      vim.lsp.inlay_hint.enable(buf, false)
      vim.notify("Inlay hints disabled")
    else
      vim.lsp.inlay_hint.enable(buf, true)
      vim.notify("Inlay hints enabled")
    end
  elseif vim.lsp.buf.inlay_hint then
    if vim.b[buf].inlay_hints_enabled then
      vim.lsp.buf.inlay_hint(buf, false)
      vim.b[buf].inlay_hints_enabled = false
      vim.notify("Inlay hints disabled")
    else
      vim.lsp.buf.inlay_hint(buf, true)
      vim.b[buf].inlay_hints_enabled = true
      vim.notify("Inlay hints enabled")
    end
  end
end

function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

-- LSP utilities
M.lsp = {}

function M.lsp.formatter()
  return {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      vim.lsp.buf.format({ bufnr = buf })
    end,
    sources = function(buf)
      local clients = vim.lsp.get_clients({ bufnr = buf })
      local ret = {}
      for _, client in ipairs(clients) do
        if client.supports_method("textDocument/formatting") then
          table.insert(ret, client.name)
        end
      end
      return ret
    end,
  }
end

function M.lsp.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.lsp.setup()
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
  })
end

function M.lsp.on_dynamic_capability(fn)
  -- Implementation for dynamic capability registration
end

function M.lsp.get_config(server)
  local configs = require("lspconfig.configs")
  return rawget(configs, server)
end

function M.lsp.disable(server, cond)
  local util = require("lspconfig.util")
  local def = M.lsp.get_config(server)
  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

function M.lsp.on_rename(from, to)
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", {
        files = {
          {
            oldUri = vim.uri_from_fname(from),
            newUri = vim.uri_from_fname(to),
          },
        },
      }, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
end

-- LSP keymaps
M.lsp.keymaps = {}

function M.lsp.keymaps.on_attach(client, buffer)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = buffer
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- LSP keymaps
  map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
  map("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
  map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  map("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
  map("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto T[y]pe Definition" })
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

  -- Conditional keymaps based on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format Document" })
  end
end

-- LSP words
M.lsp.words = {}

function M.lsp.words.setup()
  -- Implementation for document highlighting
end

-- LSP inlay hints
M.lsp.inlay_hints = {}

function M.lsp.inlay_hints.setup()
  -- Implementation for inlay hints
end

-- LSP codelens
M.lsp.codelens = {}

function M.lsp.codelens.setup()
  -- Implementation for codelens
end

-- UI utilities
M.ui = {}

function M.ui.fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  return hl and hl.fg and { fg = string.format("#%06x", hl.fg) }
end

-- Lualine utilities
M.lualine = {}

function M.lualine.root_dir()
  return {
    function()
      local root = vim.fn.getcwd()
      return vim.fn.fnamemodify(root, ":t")
    end,
    color = { fg = "#c3ccdc", gui = "bold" },
  }
end

function M.lualine.pretty_path()
  return {
    "filename",
    path = 1,
    symbols = {
      modified = "  ",
      readonly = "",
      unnamed = "",
    },
  }
end

-- Telescope utilities
M.telescope = {}

function M.telescope.config_files()
  return function()
    require("telescope.builtin").find_files({
      cwd = vim.fn.stdpath("config"),
    })
  end
end

-- Mini utilities
M.mini = {}

function M.mini.ai_whichkey(opts)
  local objects = {
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "b", desc = ")]} block" },
    { "c", desc = "class" },
    { "d", desc = "digit(s)" },
    { "e", desc = "CamelCase / snake_case" },
    { "f", desc = "function" },
    { "g", desc = "entire file" },
    { "i", desc = "indent" },
    { "o", desc = "block, conditional, loop" },
    { "q", desc = "quote `\"'}" },
    { "t", desc = "tag" },
    { "u", desc = "use/call function & method" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }

  local ret = { mode = { "o", "x" } }
  local mappings = vim.tbl_extend("force", {}, {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",
  }, opts.mappings or {})
  mappings.goto_left = nil
  mappings.goto_right = nil

  for name, prefix in pairs(mappings) do
    name = name:gsub("^around_", ""):gsub("^inside_", "")
    ret[#ret + 1] = { prefix, group = name }
    for _, obj in ipairs(objects) do
      ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
    end
  end
  require("which-key").add(ret, { notify = false })
end

return M