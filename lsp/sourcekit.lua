-- Swift Language Server (sourcekit-lsp) configuration
return {
  cmd = { "/usr/bin/sourcekit-lsp" },
  filetypes = { "swift", "objective-c", "objective-cpp" },
  root_markers = { "Package.swift", "*.xcodeproj", "*.xcworkspace", ".git" },
  capabilities = vim.tbl_deep_extend("force", 
    vim.lsp.protocol.make_client_capabilities(),
    {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    }
  ),
}