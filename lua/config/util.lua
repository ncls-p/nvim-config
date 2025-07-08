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
    string.format("Auto format %s %s", M.format.enabled and "enabled" or "disabled",
      buf_local and "(buffer)" or "(global)")
  )
end

function M.get_format_enabled(buf)
  if vim.b[buf].autoformat ~= nil then
    return vim.b[buf].autoformat
  end
  return M.format.enabled
end

-- Session persistence utilities
local session_file = vim.fn.stdpath("data") .. "/session_settings.json"

function M.load_session_settings()
  local ok, content = pcall(vim.fn.readfile, session_file)
  if ok and content and #content > 0 then
    local settings = vim.fn.json_decode(table.concat(content, "\n"))
    if settings and settings.relativenumber ~= nil then
      vim.opt.relativenumber = settings.relativenumber
    end
  end
end

function M.save_session_settings()
  local settings = {
    relativenumber = vim.opt.relativenumber:get()
  }
  local content = vim.fn.json_encode(settings)
  vim.fn.writefile({ content }, session_file)
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
  
  -- Save relativenumber setting to session
  if option == "relativenumber" then
    M.save_session_settings()
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
  local enabled = vim.diagnostic.is_enabled()
  if enabled then
    vim.diagnostic.enable(false)
    vim.notify("Diagnostics disabled")
  else
    vim.diagnostic.enable(true)
    vim.notify("Diagnostics enabled")
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

-- LSP utilities (simplified - most functionality moved to native lsp.lua)
M.lsp = {}

-- Keep only essential utility for file renaming
function M.lsp.on_rename(from, to)
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles", { bufnr = 0 }) then
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

