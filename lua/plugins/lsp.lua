-- Neovim 0.11 Native LSP Configuration
-- This configuration uses the new vim.lsp.config() and vim.lsp.enable() APIs
-- introduced in Neovim 0.11 for native LSP support without nvim-lspconfig

return {
  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- Language servers
        "lua-language-server",
        "typescript-language-server",
        "basedpyright", -- Better Python LSP with enhanced features 
        "json-lsp",
        "html-lsp",
        "css-lsp",
        "lemminx",
        -- Formatters
        "stylua",
        "shfmt",
        -- Linters (for nvim-lint)
        "eslint_d",
        "ruff",
        "luacheck",
        "markdownlint",
        "hadolint",
        "yamllint",
        "shellcheck",
        "prettier",
        -- DevOps tools
        "dockerfile-language-server",
        "docker-compose-language-service",
        "terraform-ls",
        "tflint",
        "ansible-language-server",
        "helm-ls",
        "yaml-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- Native LSP Configuration
  {
    name = "native-lsp",
    dir = vim.fn.stdpath("config"),
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "LSP Info" },
      { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
      { "gr", vim.lsp.buf.references, desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
      { "gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
      { "gy", vim.lsp.buf.type_definition, desc = "Go to Type Definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      { "<leader>ca", function() 
          if pcall(require, "tiny-code-action") then
            require("tiny-code-action").code_action()
          else
            vim.lsp.buf.code_action()
          end
        end, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>cf", function() 
          local conform_ok, conform = pcall(require, "conform")
          if conform_ok then
            conform.format({ async = true, lsp_format = "fallback" })
          else
            vim.lsp.buf.format({ async = true })
          end
        end, desc = "Format" },
      { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
      { "[d", vim.diagnostic.goto_prev, desc = "Previous Diagnostic" },
      { "<leader>cd", vim.diagnostic.open_float, desc = "Show Diagnostic" },
      { "<leader>cq", vim.diagnostic.setloclist, desc = "Diagnostic Quickfix" },
      { "<leader>ct", function()
        local current_config = vim.diagnostic.config()
        local virtual_text_enabled = current_config.virtual_text ~= false
        vim.diagnostic.config({
          virtual_text = not virtual_text_enabled,
        })
        vim.notify(
          "Virtual text " .. (virtual_text_enabled and "disabled" or "enabled"),
          vim.log.levels.INFO,
          { title = "Diagnostics" }
        )
      end, desc = "Toggle Virtual Text" },
    },
    config = function()
      -- Configure diagnostics
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          severity = { min = vim.diagnostic.severity.HINT },
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          severity_sort = true,
          focusable = false,
        },
      })

      -- Enhanced diagnostics for specific filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dockerfile", "terraform", "yaml" },
        callback = function()
          -- Force enable virtual text for DevOps files
          vim.diagnostic.config({
            virtual_text = {
              spacing = 4,
              source = "always",
              prefix = "●",
              severity = { min = vim.diagnostic.severity.HINT },
              format = function(diagnostic)
                return string.format("%s: %s", diagnostic.source or "LSP", diagnostic.message)
              end,
            },
          }, vim.api.nvim_get_current_buf())
        end,
      })

      -- Global LSP configuration (applies to all servers)
      vim.lsp.config["*"] = {
        capabilities = vim.tbl_deep_extend("force", 
          vim.lsp.protocol.make_client_capabilities(),
          -- Add blink.cmp capabilities if available
          pcall(require, "blink.cmp") and require("blink.cmp").get_lsp_capabilities() or {}
        ),
      }

      -- Configure individual LSP servers using vim.lsp.config
      
      -- Lua Language Server
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              },
            },
            completion = {
              callSnippet = "Replace",
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- TypeScript/JavaScript Language Server
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
        single_file_support = true,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }

      -- Python Language Server (Basedpyright with Ruff integration)
      -- Basedpyright: Enhanced Python LSP with better performance and features
      vim.lsp.config.basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".venv", ".git" },
        single_file_support = true,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
            },
          },
          basedpyright = {
            -- Disable Basedpyright's own organizing imports since we use Ruff
            disableOrganizeImports = true,
          },
        },
      }
      
      -- Setup Python virtual environment detection via LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.py",
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "basedpyright" then
            return
          end
          
          local root_dir = client.config.root_dir or vim.fn.getcwd()
          local venv_python = root_dir .. "/.venv/bin/python"
          
          if vim.fn.executable(venv_python) == 1 then
            client.config.settings.python = client.config.settings.python or {}
            client.config.settings.python.pythonPath = venv_python
            client.config.settings.python.venvPath = vim.fn.fnamemodify(venv_python, ":h:h")
            client.config.settings.python.venv = ".venv"
            
            client.notify("workspace/didChangeConfiguration", {
              settings = client.config.settings
            })
          elseif vim.env.VIRTUAL_ENV then
            local env_python = vim.env.VIRTUAL_ENV .. "/bin/python"
            if vim.fn.executable(env_python) == 1 then
              client.config.settings.python = client.config.settings.python or {}
              client.config.settings.python.pythonPath = env_python
              client.config.settings.python.venvPath = vim.env.VIRTUAL_ENV
              
              client.notify("workspace/didChangeConfiguration", {
                settings = client.config.settings
              })
            end
          end
        end,
      })

      -- JSON Language Server
      vim.lsp.config.jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { "package.json", ".git" },
        single_file_support = true,
        settings = {
          json = {
            schemas = (function()
              local ok, schemastore = pcall(require, "schemastore")
              return ok and schemastore.json.schemas() or {}
            end)(),
            validate = { enable = true },
          },
        },
      }

      -- HTML Language Server
      vim.lsp.config.html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "templ" },
        root_markers = { "package.json", ".git" },
        single_file_support = true,
        settings = {},
      }

      -- CSS Language Server
      vim.lsp.config.cssls = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        single_file_support = true,
        settings = {
          css = {
            validate = true,
          },
          scss = {
            validate = true,
          },
          less = {
            validate = true,
          },
        },
      }

      -- XML Language Server (lemminx)
      vim.lsp.config.lemminx = {
        cmd = { "lemminx" },
        filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
        root_markers = { ".git" },
        single_file_support = true,
        settings = {
          xml = {
            server = {
              workDir = vim.fn.expand("~/.cache/lemminx"),
            },
            format = {
              enabled = true,
              splitAttributes = "preserve",
              joinCDATALines = false,
              joinCommentLines = false,
              formatComments = true,
              joinContentLines = false,
              trimFinalNewlines = true,
              insertFinalNewline = true,
              trimTrailingWhitespace = true,
              preserveEmptyContent = true,
              preservedNewlines = 2,
              spaceBeforeEmptyCloseTag = true,
            },
            validation = {
              enabled = true,
              resolveExternalEntities = false,
              noGrammar = "hint",
            },
            completion = {
              autoCloseTags = true,
            },
          },
        },
      }

      -- Swift Language Server (sourcekit-lsp)
      vim.lsp.config.sourcekit = {
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

      -- Docker Language Server
      vim.lsp.config.dockerls = {
        cmd = function()
          -- Try different possible command names
          local possible_commands = {
            "dockerfile-language-server-nodejs",
            "docker-langserver",
            "dockerfile-language-server"
          }
          
          for _, cmd in ipairs(possible_commands) do
            if vim.fn.executable(cmd) == 1 then
              return { cmd, "--stdio" }
            end
          end
          
          -- Fallback to the standard name
          return { "dockerfile-language-server-nodejs", "--stdio" }
        end,
        filetypes = { "dockerfile" },
        root_markers = { "Dockerfile", "docker-compose.yml", ".git" },
        single_file_support = true,
        settings = {
          docker = {
            languageserver = {
              diagnostics = {
                -- Enable hadolint integration
                hadolintPath = "hadolint",
              },
            },
          },
        },
      }

      -- Docker Compose Language Server
      vim.lsp.config.docker_compose_language_service = {
        cmd = { "docker-compose-langserver", "--stdio" },
        filetypes = { "yaml.docker-compose" },
        root_markers = { "docker-compose.yml", "docker-compose.yaml", ".git" },
        single_file_support = true,
      }

      -- Terraform Language Server
      vim.lsp.config.terraformls = {
        cmd = { "terraform-ls", "serve" },
        filetypes = { "terraform", "tf", "terraform-vars" },
        root_markers = { ".terraform", ".git" },
      }

      -- Ansible Language Server
      vim.lsp.config.ansiblels = {
        cmd = { "ansible-language-server", "--stdio" },
        filetypes = { "yaml.ansible" },
        root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
        settings = {
          ansible = {
            ansible = {
              path = "ansible",
            },
            executionEnvironment = {
              enabled = false,
            },
            python = {
              interpreterPath = "python",
            },
            validation = {
              enabled = true,
              lint = {
                enabled = true,
                path = "ansible-lint",
              },
            },
          },
        },
      }

      -- Helm Language Server
      vim.lsp.config.helm_ls = {
        cmd = { "helm_ls", "serve" },
        filetypes = { "helm" },
        root_markers = { "Chart.yaml", "values.yaml", ".git" },
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = "yaml-language-server",
            },
          },
        },
      }

      -- YAML Language Server (enhanced for DevOps)
      vim.lsp.config.yamlls = {
        cmd = { "yaml-language-server", "--stdio" },
        filetypes = { "yaml", "yml" },
        root_markers = { ".git" },
        settings = {
          yaml = {
            schemas = {
              -- Kubernetes schemas
              ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.29.0/all.json"] = "/*.k8s.yaml",
              ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0/all.json"] = "k8s/**/*.yaml",
              -- Docker compose
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
              -- GitHub Actions
              ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
              -- GitLab CI
              ["https://json.schemastore.org/gitlab-ci.json"] = ".gitlab-ci.yml",
              -- Ansible
              ["https://json.schemastore.org/ansible-playbook.json"] = "*playbook*.yml",
              ["https://json.schemastore.org/ansible-inventory.json"] = "*inventory*.yml",
              -- Helm
              ["https://json.schemastore.org/chart.json"] = "Chart.yaml",
              ["https://json.schemastore.org/helm-values.json"] = "values*.yaml",
            },
            validate = true,
            hover = true,
            completion = true,
            customTags = {
              "!reference sequence",
              "!Ref",
              "!Sub",
              "!GetAtt",
              "!ImportValue",
              "!Join",
              "!Select",
              "!Split",
              "!Not",
              "!Equals",
              "!And",
              "!Or",
              "!If",
            },
          },
        },
      }

      -- Enable LSP servers
      vim.lsp.enable({
        "lua_ls",
        "ts_ls", 
        "basedpyright",
        "jsonls",
        "html",
        "cssls",
        "lemminx",
        "sourcekit",
        -- DevOps servers
        "dockerls",
        "docker_compose_language_service",
        "terraformls",
        "ansiblels",
        "helm_ls",
        "yamlls",
      })


      -- Inlay hints disabled by default (use <leader>ch to toggle if needed)
      if vim.lsp.inlay_hint then
        -- Toggle inlay hints (disabled by default)
        vim.keymap.set("n", "<leader>ch", function()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
          vim.notify(
            "Inlay hints " .. (not enabled and "enabled" or "disabled"),
            vim.log.levels.INFO,
            { title = "LSP" }
          )
        end, { desc = "Toggle Inlay Hints" })
      end

      -- Auto-format on save using conform.nvim (better than LSP formatting)
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          -- Use conform.nvim for formatting if available
          local conform_ok, conform = pcall(require, "conform")
          if conform_ok then
            conform.format({ 
              bufnr = args.buf,
              timeout_ms = 2000,
              async = false,
              lsp_format = "fallback", -- Use LSP as fallback
            })
          end
        end,
      })

      -- Better hover window
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      -- Better signature help window
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

    end,
  },

  -- Schema store for JSON schemas
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- Tiny Code Action - Better UI for code actions
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup({
        backend = "vim",
        picker = "telescope", -- Use telescope as fzf-lua might not be supported yet
        signs = {
          quickfix = { "󰁨", { link = "DiagnosticWarning" } },
          refactor = { "󰊕", { link = "DiagnosticInfo" } },
          source = { "", { link = "DiagnosticInfo" } },
          combined = { "󰌵", { link = "DiagnosticInfo" } },
          user = { "", { link = "DiagnosticInfo" } },
        },
      })
    end,
  },

  -- Formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Languages",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        -- swift = { "swiftformat" }, -- Commented out - install via: brew install swiftformat
        xml = { "xmllint" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        python = { "ruff_format", "ruff_fix" },
        -- DevOps formats
        dockerfile = { "hadolint" },
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        xmllint = {
          command = "xmllint",
          args = { "--format", "-" },
          stdin = true,
        },
        swiftformat = {
          command = "swiftformat",
          args = { "--stdinpath", "$FILENAME" },
          stdin = true,
        },
      },
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}