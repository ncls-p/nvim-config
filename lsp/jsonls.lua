-- JSON Language Server configuration
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
  single_file_support = true,
  settings = {
    json = {
      schemas = pcall(require, "schemastore") and require("schemastore").json.schemas() or {},
      validate = { enable = true },
    },
  },
}