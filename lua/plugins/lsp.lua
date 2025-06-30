return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      { "<leader>ca", function() require("tiny-code-action").code_action() end, desc = "Code Action", mode = { "n", "v" } },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
      },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
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
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = false,
      },
      capabilities = {},
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        lua_ls = {
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
        },
        -- Essential language servers only
        ts_ls = {}, -- TypeScript/JavaScript
        pyright = {}, -- Python
        jsonls = {}, -- JSON
        html = {}, -- HTML
        cssls = {}, -- CSS
        -- XML development
        lemminx = {
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
      },
      setup = {},
    },
    config = function(_, opts)
      require("config.util").format.register(require("config.util").lsp.formatter())

      require("config.util").lsp.on_attach(function(client, buffer)
        require("config.util").lsp.keymaps.on_attach(client, buffer)
      end)

      require("config.util").lsp.setup()
      require("config.util").lsp.on_dynamic_capability(require("config.util").lsp.keymaps.on_attach)

      require("config.util").lsp.words.setup()

      if opts.inlay_hints.enabled then
        require("config.util").lsp.inlay_hints.setup()
      end

      if opts.codelens.enabled and vim.lsp.codelens then
        require("config.util").lsp.codelens.setup()
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = "●"
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        opts.capabilities or {}
      )

      -- Add blink.cmp capabilities if available
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink and blink.get_lsp_capabilities then
        capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
      end

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      if have_mason then
        local ensure_installed = {}
        for server, server_opts in pairs(servers) do
          if server_opts then
            ensure_installed[#ensure_installed + 1] = server
          end
        end

        mlsp.setup({
          ensure_installed = ensure_installed,
          handlers = { setup },
        })
      else
        -- Fallback: setup servers directly if mason-lspconfig is not available
        for server, server_opts in pairs(servers) do
          if server_opts then
            setup(server)
          end
        end
      end

      if require("config.util").lsp.get_config("denols") and require("config.util").lsp.get_config("ts_ls") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        require("config.util").lsp.disable("ts_ls", is_deno)
        require("config.util").lsp.disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end
      
      -- Setup sourcekit for Swift development (not available via Mason)
      local lspconfig = require("lspconfig")
      lspconfig.sourcekit.setup({
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        }),
        cmd = { "/usr/bin/sourcekit-lsp" },
        filetypes = { "swift", "objective-c", "objective-cpp" },
        root_dir = lspconfig.util.root_pattern("Package.swift", ".git"),
      })
    end,
  },

  -- Package manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
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
        picker = "telescope",
        telescope_opts = {
          layout_strategy = "vertical",
          layout_config = {
            width = 0.7,
            height = 0.9,
            preview_cutoff = 1,
            preview_height = function(_, _, max_lines)
              local h = math.floor(max_lines * 0.5)
              return math.max(h, 10)
            end,
          },
        },
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

  -- Formatting
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
        desc = "Format Injected Langs",
      },
    },
    init = function()
      require("config.util").format.register({
        name = "conform.nvim",
        priority = 100,
        primary = false,
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        scala = { "scalafmt" },
        sbt = { "scalafmt" },
        swift = { "swiftformat" },
        xml = { "xmllint", "lemminx" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        xmllint = {
          command = "xmllint",
          args = { "--format", "-" },
          stdin = true,
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
