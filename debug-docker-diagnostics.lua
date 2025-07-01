-- Debug Docker diagnostics display
-- Run this in a Dockerfile buffer: :luafile debug-docker-diagnostics.lua

print("=== Docker Diagnostics Debug ===")

local bufnr = vim.api.nvim_get_current_buf()
local filetype = vim.bo[bufnr].filetype

print("Buffer:", bufnr)
print("Filetype:", filetype)

-- Check LSP clients
local lsp_clients = vim.lsp.get_clients({ bufnr = bufnr })
print("LSP clients:", #lsp_clients)
for _, client in ipairs(lsp_clients) do
  print("  - " .. client.name)
end

-- Check all diagnostics
local all_diagnostics = vim.diagnostic.get(bufnr)
print("Total diagnostics:", #all_diagnostics)

for i, diag in ipairs(all_diagnostics) do
  print(string.format("  %d. Line %d: [%s] %s (source: %s)", 
    i, diag.lnum + 1, vim.diagnostic.severity[diag.severity], diag.message, diag.source or "unknown"))
end

-- Check diagnostic configuration
local config = vim.diagnostic.config()
print("Virtual text enabled:", config.virtual_text ~= false)
print("Signs enabled:", config.signs ~= false)
print("Underline enabled:", config.underline ~= false)

-- Check if diagnostics are being shown
print("Diagnostics in current line:")
local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = current_line })
for _, diag in ipairs(line_diagnostics) do
  print("  - " .. diag.message)
end

-- Force refresh diagnostics
print("Refreshing diagnostics...")
vim.diagnostic.reset()
for _, client in ipairs(lsp_clients) do
  if client.name == "dockerls" then
    client.request_sync("textDocument/diagnostic", {
      textDocument = vim.lsp.util.make_text_document_params()
    }, 5000, bufnr)
  end
end

-- Try manual diagnostic
vim.diagnostic.show(nil, bufnr)