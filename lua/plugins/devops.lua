-- DevOps Tools Configuration (2025)
-- Comprehensive support for Docker, Kubernetes, Terraform, and cloud-native tools

return {
  -- Kubernetes support
  {
    "Ramilito/kubectl.nvim",
    cmd = { "Kubectl", "Kubens", "Kubectx" },
    keys = {
      { "<leader>k", "<cmd>lua require('kubectl').toggle()<cr>", desc = "Kubectl" },
    },
    config = function()
      require("kubectl").setup({
        auto_refresh = {
          enabled = true,
          interval = 300, -- 5 minutes
        },
        hints = true,
        context = true,
        float_size = {
          width = 0.9,
          height = 0.8,
        },
      })
    end,
  },

  -- Terraform/OpenTofu support
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "hcl" },
    config = function()
      vim.g.terraform_align = 1
      vim.g.terraform_fmt_on_save = 1
    end,
  },

  -- Enhanced YAML support for K8s manifests
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    ft = { "yaml", "yml" },
    config = function()
      require("telescope").load_extension("yaml_schema")
      local cfg = require("yaml-companion").setup({
        builtin_matchers = {
          kubernetes = { enabled = true },
          cloud_init = { enabled = true },
        },
        schemas = {
          -- Kubernetes schemas
          {
            name = "Kubernetes",
            uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0/all.json",
          },
          -- Helm chart schemas
          {
            name = "Helm Chart.yaml",
            uri = "https://json.schemastore.org/chart.json",
          },
          {
            name = "Helm Values",
            uri = "https://json.schemastore.org/helm-values.json",
          },
          -- Docker compose
          {
            name = "Docker Compose",
            uri = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
          },
          -- GitHub Actions
          {
            name = "GitHub Actions",
            uri = "https://json.schemastore.org/github-workflow.json",
          },
          -- GitLab CI
          {
            name = "GitLab CI",
            uri = "https://json.schemastore.org/gitlab-ci.json",
          },
          -- Ansible
          {
            name = "Ansible Playbook",
            uri = "https://json.schemastore.org/ansible-playbook.json",
          },
        },
        lspconfig = {
          settings = {
            yaml = {
              validate = true,
              schemaStore = {
                enable = false,
                url = "",
              },
            },
          },
        },
      })
      require("lspconfig")["yamlls"].setup(cfg)
    end,
    keys = {
      {
        "<leader>cy",
        "<cmd>Telescope yaml_schema<cr>",
        desc = "YAML Schema",
      },
    },
  },

  -- Alternative YAML navigation
  {
    "cuducos/yaml.nvim",
    ft = { "yaml", "yml" },
    config = function()
      require("yaml_nvim").setup({
        highlight = { enable = true },
      })
    end,
    keys = {
      { "<leader>yp", function() print(require("yaml_nvim").get_yaml_key_and_value()) end, desc = "YAML Path" },
      { "<leader>yk", function() print(require("yaml_nvim").get_yaml_key()) end, desc = "YAML Key" },
    },
  },

  -- Helm file detection and syntax
  {
    "towolf/vim-helm",
    ft = { "helm", "gotmpl", "helmfile" },
  },

  -- Additional Docker utilities
  {
    "kkvh/vim-docker-tools",
    ft = { "dockerfile" },
    cmd = { "DockerBuild", "DockerRun" },
  },

  -- Cloud-native config files support
  {
    "cappyzawa/trim.nvim",
    event = "BufWritePre",
    opts = {
      patterns = {
        [[%s/\s\+$//e]], -- Remove trailing whitespace
        [[%s/\($\n\s*\)\+\%$//]], -- Remove trailing blank lines
      },
      ft_blocklist = { "markdown", "text", "help" },
    },
  },

  -- DevOps snippets
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Load DevOps specific snippets
      require("luasnip.loaders.from_vscode").lazy_load({
        include = { "dockerfile", "yaml", "terraform", "helm", "kubernetes" },
      })
    end,
  },

  -- Infrastructure diagram preview
  {
    "jubnzv/virtual-types.nvim",
    ft = { "terraform", "yaml", "json" },
  },

  -- Better quickfix for terraform plan outputs
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        auto_preview = true,
        show_title = true,
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          -- Skip preview for large files
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            ret = false
          end
          return ret
        end,
      },
    },
  },
}