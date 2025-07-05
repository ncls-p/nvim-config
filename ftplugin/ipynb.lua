-- Auto-activate quarto for ipynb files converted to markdown
require("quarto").activate()

-- Ensure proper filetype detection for converted notebooks
vim.bo.filetype = "markdown"