-- Debug script for Dockerfile LSP
-- Run this in Neovim with :luafile test-dockerfile-lsp.lua

print("=== Dockerfile LSP Debug ===")

-- Check filetype detection
local ft = vim.bo.filetype
print("Current filetype: " .. ft)

-- Check if dockerfile-language-server is available
local function check_command(cmd)
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end

print("dockerfile-language-server-nodejs available: " .. tostring(check_command("dockerfile-language-server-nodejs")))

-- Check LSP configuration
local config = vim.lsp.config.dockerls
if config then
  print("LSP config exists:")
  print("  cmd: " .. vim.inspect(config.cmd))
  print("  filetypes: " .. vim.inspect(config.filetypes))
else
  print("LSP config NOT found")
end

-- Check active LSP clients
local clients = vim.lsp.get_clients({ bufnr = 0 })
print("Active LSP clients: " .. #clients)
for i, client in ipairs(clients) do
  print("  " .. i .. ": " .. client.name)
end

-- Try to manually start the LSP
if ft == "dockerfile" and #clients == 0 then
  print("Attempting to start dockerls...")
  vim.lsp.start({
    name = "dockerls",
    cmd = { "dockerfile-language-server-nodejs", "--stdio" },
    filetypes = { "dockerfile" },
    root_dir = vim.fn.getcwd(),
  })
  
  -- Check again after a delay
  vim.defer_fn(function()
    local new_clients = vim.lsp.get_clients({ bufnr = 0 })
    print("LSP clients after manual start: " .. #new_clients)
  end, 1000)
end