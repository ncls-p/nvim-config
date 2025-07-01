-- nvim-lint configuration
-- Many linters are commented out to prevent ENOENT errors
-- Uncomment and install the tools you need via their respective package managers
-- This configuration includes error handling to gracefully skip missing linters

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      -- Only enable linters that are commonly available or installed via Mason
      lint.linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
        svelte = { "eslint" },
        python = { "ruff" }, -- Removed pylint since Pyright handles imports/type checking
        lua = { "luacheck" },
        markdown = { "markdownlint" },
        dockerfile = { "hadolint" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        fish = { "fish" },
        -- go = { "golangci-lint" }, -- install via: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
        -- rust = { "clippy" }, -- comes with rust toolchain
        -- cpp = { "cppcheck" }, -- install via: apt install cppcheck / brew install cppcheck
        -- c = { "cppcheck" },
        -- cmake = { "cmakelint" }, -- install via: pip install cmakelint
        -- sql = { "sqlfluff" }, -- install via: pip install sqlfluff
        -- vim = { "vint" }, -- install via: pip install vim-vint
        -- html = { "htmlhint" }, -- install via: npm install -g htmlhint
        -- css = { "stylelint" }, -- install via: npm install -g stylelint
        -- scss = { "stylelint" },
        -- sass = { "stylelint" },
        -- ruby = { "ruby" },
        -- php = { "phpcs" }, -- install via: composer global require squizlabs/php_codesniffer
        -- java = { "checkstyle" }, -- install via: brew install checkstyle
        -- kotlin = { "ktlint" }, -- install via: brew install ktlint
        -- swift = { "swiftlint" }, -- Commented out - install via: brew install swiftlint
        terraform = { "tflint" }, -- install via: brew install tflint
        ansible = { "ansible-lint" }, -- install via: pip install ansible-lint
      }

      -- Configure specific linters
      lint.linters.eslint.args = {
        "--no-eslintrc",
        "--config",
        function()
          local config_files = {
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
          }
          
          for _, config_file in ipairs(config_files) do
            if vim.fn.findfile(config_file, ".;") ~= "" then
              return vim.fn.findfile(config_file, ".;")
            end
          end
          
          return vim.fn.expand("~/.eslintrc.json")
        end,
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }

      -- Custom linter for Python using ruff
      lint.linters.ruff = {
        cmd = "ruff",
        stdin = true,
        args = {
          "check",
          "--output-format=json",
          "--stdin-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
          "-",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = function(output, _)
          local diagnostics = {}
          local success, decoded = pcall(vim.json.decode, output)
          
          if not success or not decoded then
            return diagnostics
          end
          
          for _, item in ipairs(decoded) do
            if item.location then
              table.insert(diagnostics, {
                lnum = item.location.row - 1,
                col = item.location.column - 1,
                end_lnum = item.end_location and item.end_location.row - 1 or item.location.row - 1,
                end_col = item.end_location and item.end_location.column - 1 or item.location.column - 1,
                severity = vim.diagnostic.severity.WARN,
                message = item.message,
                code = item.code,
                source = "ruff",
              })
            end
          end
          
          return diagnostics
        end,
      }

      -- Configure luacheck for Neovim configs
      lint.linters.luacheck.args = {
        "--globals",
        "vim",
        "--formatter",
        "plain",
        "--codes",
        "--ranges",
        "-",
      }

      -- Helper function to check if linter is available
      local function is_linter_available(linter_name)
        local linter = lint.linters[linter_name]
        if not linter or not linter.cmd then
          return false
        end
        
        -- Handle both string and table cmd formats
        local cmd
        if type(linter.cmd) == "string" then
          cmd = linter.cmd
        elseif type(linter.cmd) == "table" and #linter.cmd > 0 then
          cmd = linter.cmd[1]
        else
          return false
        end
        
        return vim.fn.executable(cmd) == 1
      end

      -- Filter out unavailable linters
      local function get_available_linters(ft)
        local linters = lint.linters_by_ft[ft] or {}
        local available = {}
        for _, linter in ipairs(linters) do
          if is_linter_available(linter) then
            table.insert(available, linter)
          end
        end
        return available
      end

      -- Auto-lint on save and text changes
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only run linting if LSP doesn't already provide diagnostics
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local has_lsp_diagnostics = false
          
          for _, client in ipairs(clients) do
            if client.server_capabilities.diagnosticProvider then
              has_lsp_diagnostics = true
              break
            end
          end
          
          -- Run linting for filetypes that don't have LSP diagnostics or need additional linting
          local ft = vim.bo.filetype
          local always_lint = { "markdown", "dockerfile", "yaml", "json" }
          local skip_when_lsp = { "python" } -- Skip linting for Python when Pyright is available
          
          if (not has_lsp_diagnostics or vim.tbl_contains(always_lint, ft)) and not (has_lsp_diagnostics and vim.tbl_contains(skip_when_lsp, ft)) then
            -- Only lint if we have available linters for this filetype
            local available_linters = get_available_linters(ft)
            if #available_linters > 0 then
              lint.try_lint()
            end
          end
        end,
      })

      -- Manual linting command
      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Run linters" })

      -- Toggle linting
      local linting_enabled = true
      vim.api.nvim_create_user_command("LintToggle", function()
        linting_enabled = not linting_enabled
        if linting_enabled then
          vim.notify("Linting enabled", vim.log.levels.INFO, { title = "nvim-lint" })
          lint.try_lint()
        else
          vim.notify("Linting disabled", vim.log.levels.INFO, { title = "nvim-lint" })
          vim.diagnostic.reset(vim.api.nvim_create_namespace("nvim-lint"))
        end
      end, { desc = "Toggle linting" })

      -- Keymap for manual linting
      vim.keymap.set("n", "<leader>cl", function()
        if linting_enabled then
          lint.try_lint()
        end
      end, { desc = "Run linters" })

      vim.keymap.set("n", "<leader>cL", "<cmd>LintToggle<cr>", { desc = "Toggle linting" })
    end,
  },
}