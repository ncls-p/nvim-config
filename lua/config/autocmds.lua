-- Autocmds are automatically loaded on the VeryLazy event
local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 500,
    })
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].config_last_loc then
      return
    end
    vim.b[buf].config_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Swift-specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("swift_settings"),
  pattern = "swift",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = "// %s"
  end,
})

-- Ensure Swift files are detected properly
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("swift_detection"),
  pattern = "*.swift",
  callback = function()
    vim.bo.filetype = "swift"
  end,
})

-- XML-specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("xml_settings"),
  pattern = { "xml", "xsd", "xsl", "xslt", "svg" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.wrap = false
    vim.opt_local.textwidth = 0
    -- Enable folding for XML
    vim.opt_local.foldmethod = "indent"
    vim.opt_local.foldlevel = 99
  end,
})

-- Auto-close XML tags
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("xml_autoclosetag"),
  pattern = { "xml", "xsd", "xsl", "xslt", "svg", "html" },
  callback = function()
    vim.keymap.set("i", ">", function()
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local before_cursor = line:sub(1, col)
      local tag = before_cursor:match("<(%w+)[^>]*$")
      if tag and not before_cursor:match("/%s*$") then
        return "></" .. tag .. "><Left><Left><Left>"
      else
        return ">"
      end
    end, { buffer = true, expr = true })
  end,
})

-- DevOps file type detection and settings

-- Docker file detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("docker_detection"),
  pattern = {
    "Dockerfile",
    "Dockerfile.*",
    "*.dockerfile",
    ".dockerignore",
  },
  callback = function()
    local filename = vim.fn.expand("%:t")
    if filename:match("^Dockerfile") or filename:match("%.dockerfile$") then
      vim.bo.filetype = "dockerfile"
    end
  end,
})

-- Docker Compose detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("docker_compose_detection"),
  pattern = {
    "docker-compose.yml",
    "docker-compose.yaml",
    "docker-compose.*.yml",
    "docker-compose.*.yaml",
    "compose.yml",
    "compose.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end,
})

-- Kubernetes YAML detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("k8s_detection"),
  pattern = {
    "*.k8s.yml",
    "*.k8s.yaml",
    "*.kubernetes.yml",
    "*.kubernetes.yaml",
    "k8s/**/*.yml",
    "k8s/**/*.yaml",
    "kubernetes/**/*.yml",
    "kubernetes/**/*.yaml",
    "manifests/**/*.yml",
    "manifests/**/*.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml"
    vim.bo.syntax = "yaml"
  end,
})

-- Ansible detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("ansible_detection"),
  pattern = {
    "*playbook*.yml",
    "*playbook*.yaml",
    "site.yml",
    "site.yaml",
    "main.yml",
    "main.yaml",
    "*/tasks/*.yml",
    "*/tasks/*.yaml",
    "*/handlers/*.yml",
    "*/handlers/*.yaml",
    "*/vars/*.yml",
    "*/vars/*.yaml",
    "*/defaults/*.yml",
    "*/defaults/*.yaml",
    "*/meta/*.yml",
    "*/meta/*.yaml",
    "ansible.cfg",
    "*/group_vars/*",
    "*/host_vars/*",
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})

-- Helm template detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("helm_detection"),
  pattern = {
    "*/templates/*.yaml",
    "*/templates/*.yml",
    "Chart.yaml",
    "values.yaml",
    "values.yml",
    "values-*.yaml",
    "values-*.yml",
    "requirements.yaml",
    "requirements.yml",
  },
  callback = function()
    local filepath = vim.fn.expand("%:p")
    if filepath:match("/templates/") then
      vim.bo.filetype = "helm"
    else
      vim.bo.filetype = "yaml"
    end
  end,
})

-- Terraform file detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("terraform_detection"),
  pattern = {
    "*.tf",
    "*.tfvars",
    "*.hcl",
  },
  callback = function()
    local ext = vim.fn.expand("%:e")
    if ext == "tfvars" then
      vim.bo.filetype = "terraform-vars"
    elseif ext == "hcl" then
      vim.bo.filetype = "hcl"
    else
      vim.bo.filetype = "terraform"
    end
  end,
})

-- GitOps file detection (ArgoCD, Flux)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("gitops_detection"),
  pattern = {
    "**/flux-system/**/*.yaml",
    "**/flux-system/**/*.yml",
    "**/applications/**/*.yaml",
    "**/applications/**/*.yml",
    "kustomization.yaml",
    "kustomization.yml",
    "*.kustomization.yaml",
    "*.kustomization.yml",
  },
  callback = function()
    vim.bo.filetype = "yaml"
    vim.bo.syntax = "yaml"
  end,
})

-- DevOps file settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("devops_settings"),
  pattern = {
    "dockerfile",
    "terraform",
    "hcl",
    "terraform-vars",
    "yaml.docker-compose",
    "yaml.ansible",
    "helm",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
})

-- Terraform specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("terraform_settings"),
  pattern = { "terraform", "hcl", "terraform-vars" },
  callback = function()
    vim.opt_local.commentstring = "# %s"
    vim.opt_local.formatoptions:remove("o") -- Don't continue comments with o/O
  end,
})

-- Docker specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("docker_settings"),
  pattern = "dockerfile",
  callback = function()
    vim.opt_local.commentstring = "# %s"
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- YAML indentation for DevOps files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("yaml_devops_settings"),
  pattern = { "yaml", "yaml.docker-compose", "yaml.ansible", "helm" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.indentkeys:remove("<:>")  -- Disable auto-unindent for YAML
    vim.opt_local.indentkeys:remove("0#")   -- Disable auto-unindent for comments
  end,
})

-- Load DevOps keymaps
require("config.devops-keymaps")

