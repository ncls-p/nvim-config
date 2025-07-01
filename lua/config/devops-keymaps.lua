-- DevOps-specific keymaps and commands
-- Loaded automatically by Neovim

local function augroup(name)
  return vim.api.nvim_create_augroup("devops_" .. name, { clear = true })
end

-- DevOps commands and keymaps
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("keymaps"),
  pattern = { "terraform", "hcl", "terraform-vars", "dockerfile", "yaml", "yaml.docker-compose", "yaml.ansible", "helm" },
  callback = function(event)
    local buf = event.buf
    local ft = vim.bo[buf].filetype

    -- Terraform-specific keymaps
    if ft:match("terraform") or ft == "hcl" then
      vim.keymap.set("n", "<leader>tf", "<cmd>!terraform fmt %<cr>", { buffer = buf, desc = "Terraform Format" })
      vim.keymap.set("n", "<leader>ti", "<cmd>!terraform init<cr>", { buffer = buf, desc = "Terraform Init" })
      vim.keymap.set("n", "<leader>tp", "<cmd>!terraform plan<cr>", { buffer = buf, desc = "Terraform Plan" })
      vim.keymap.set("n", "<leader>ta", "<cmd>!terraform apply<cr>", { buffer = buf, desc = "Terraform Apply" })
      vim.keymap.set("n", "<leader>tv", "<cmd>!terraform validate<cr>", { buffer = buf, desc = "Terraform Validate" })
      vim.keymap.set("n", "<leader>tl", "<cmd>!tflint<cr>", { buffer = buf, desc = "Terraform Lint" })
    end

    -- Docker-specific keymaps
    if ft == "dockerfile" then
      vim.keymap.set("n", "<leader>db", "<cmd>!docker build -t temp-image .<cr>", { buffer = buf, desc = "Docker Build" })
      vim.keymap.set("n", "<leader>dl", "<cmd>!hadolint %<cr>", { buffer = buf, desc = "Docker Lint" })
    end

    -- Docker Compose keymaps
    if ft == "yaml.docker-compose" then
      vim.keymap.set("n", "<leader>dcu", "<cmd>!docker-compose up -d<cr>", { buffer = buf, desc = "Docker Compose Up" })
      vim.keymap.set("n", "<leader>dcd", "<cmd>!docker-compose down<cr>", { buffer = buf, desc = "Docker Compose Down" })
      vim.keymap.set("n", "<leader>dcl", "<cmd>!docker-compose logs -f<cr>", { buffer = buf, desc = "Docker Compose Logs" })
      vim.keymap.set("n", "<leader>dcv", "<cmd>!docker-compose config<cr>", { buffer = buf, desc = "Docker Compose Validate" })
    end

    -- Kubernetes/YAML keymaps
    if ft == "yaml" or ft == "helm" then
      vim.keymap.set("n", "<leader>ka", "<cmd>!kubectl apply -f %<cr>", { buffer = buf, desc = "Kubectl Apply" })
      vim.keymap.set("n", "<leader>kd", "<cmd>!kubectl delete -f %<cr>", { buffer = buf, desc = "Kubectl Delete" })
      vim.keymap.set("n", "<leader>kv", "<cmd>!kubectl apply --dry-run=client -f %<cr>", { buffer = buf, desc = "Kubectl Validate" })
      vim.keymap.set("n", "<leader>ky", "<cmd>!yamllint %<cr>", { buffer = buf, desc = "YAML Lint" })
    end

    -- Helm-specific keymaps
    if ft == "helm" then
      vim.keymap.set("n", "<leader>ht", "<cmd>!helm template . --debug<cr>", { buffer = buf, desc = "Helm Template" })
      vim.keymap.set("n", "<leader>hl", "<cmd>!helm lint .<cr>", { buffer = buf, desc = "Helm Lint" })
      vim.keymap.set("n", "<leader>hi", "<cmd>!helm install test . --dry-run<cr>", { buffer = buf, desc = "Helm Install (Dry Run)" })
    end

    -- Ansible keymaps
    if ft == "yaml.ansible" then
      vim.keymap.set("n", "<leader>ap", "<cmd>!ansible-playbook % --check<cr>", { buffer = buf, desc = "Ansible Check" })
      vim.keymap.set("n", "<leader>ar", "<cmd>!ansible-playbook %<cr>", { buffer = buf, desc = "Ansible Run" })
      vim.keymap.set("n", "<leader>al", "<cmd>!ansible-lint %<cr>", { buffer = buf, desc = "Ansible Lint" })
      vim.keymap.set("n", "<leader>av", "<cmd>!ansible-playbook % --syntax-check<cr>", { buffer = buf, desc = "Ansible Syntax Check" })
    end

    -- Common DevOps keymaps for all filetypes
    vim.keymap.set("n", "<leader>cf", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { buffer = buf, desc = "Format File" })
  end,
})

-- Global DevOps commands
vim.api.nvim_create_user_command("DevOpsInfo", function()
  print("DevOps Tools Available:")
  print("Terraform: tf[fmt|init|plan|apply|validate|lint]")
  print("Docker: d[build|lint], dc[up|down|logs|validate]")
  print("Kubernetes: k[apply|delete|validate], y[aml-lint]")
  print("Helm: h[template|lint|install]")
  print("Ansible: a[check|run|lint|validate]")
end, { desc = "Show DevOps commands" })

-- Schema validation commands
vim.api.nvim_create_user_command("SchemaValidate", function(opts)
  local file = opts.args ~= "" and opts.args or vim.fn.expand("%")
  local ft = vim.bo.filetype
  
  if ft == "yaml" or ft:match("yaml") then
    vim.cmd("!yamllint " .. file)
  elseif ft == "json" then
    vim.cmd("!jsonlint " .. file)
  elseif ft == "dockerfile" then
    vim.cmd("!hadolint " .. file)
  elseif ft:match("terraform") then
    vim.cmd("!terraform validate")
  else
    print("No schema validation available for filetype: " .. ft)
  end
end, { nargs = "?", desc = "Validate file schema" })

-- Quick access to common DevOps directories
vim.keymap.set("n", "<leader>fk", function()
  require("telescope.builtin").find_files({
    prompt_title = "Find Kubernetes Files",
    find_command = { "find", ".", "-name", "*.yaml", "-o", "-name", "*.yml", "-path", "*/k8s/*", "-o", "-path", "*/kubernetes/*" },
  })
end, { desc = "Find Kubernetes Files" })

vim.keymap.set("n", "<leader>ft", function()
  require("telescope.builtin").find_files({
    prompt_title = "Find Terraform Files",
    find_command = { "find", ".", "-name", "*.tf", "-o", "-name", "*.tfvars", "-o", "-name", "*.hcl" },
  })
end, { desc = "Find Terraform Files" })

vim.keymap.set("n", "<leader>fd", function()
  require("telescope.builtin").find_files({
    prompt_title = "Find Docker Files",
    find_command = { "find", ".", "-name", "Dockerfile*", "-o", "-name", "docker-compose*.yml", "-o", "-name", "docker-compose*.yaml" },
  })
end, { desc = "Find Docker Files" })

-- DevOps live grep
vim.keymap.set("n", "<leader>fgd", function()
  require("telescope.builtin").live_grep({
    prompt_title = "DevOps Live Grep",
    type_filter = { "yaml", "yml", "tf", "hcl", "dockerfile" },
  })
end, { desc = "DevOps Live Grep" })

-- Quick open common DevOps files
local function quick_open_devops()
  local files = {
    "docker-compose.yml",
    "docker-compose.yaml", 
    "Dockerfile",
    "terraform.tf",
    "main.tf",
    "variables.tf",
    "outputs.tf",
    "Chart.yaml",
    "values.yaml",
    "kustomization.yaml",
    ".gitlab-ci.yml",
    ".github/workflows/main.yml",
    "Makefile",
    "justfile",
  }
  
  require("telescope.pickers").new({}, {
    prompt_title = "Quick Open DevOps Files",
    finder = require("telescope.finders").new_table({
      results = files,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      require("telescope.actions").select_default:replace(function()
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        if vim.fn.filereadable(selection.value) == 1 then
          vim.cmd("edit " .. selection.value)
        else
          print("File not found: " .. selection.value)
        end
      end)
      return true
    end,
  }):find()
end

vim.keymap.set("n", "<leader>fo", quick_open_devops, { desc = "Quick Open DevOps Files" })