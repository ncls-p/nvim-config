return {
  -- Scala language server (Metals) support
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap", -- for debugging support
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      
      -- Get capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      metals_config.capabilities = capabilities
      
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        serverProperties = { "-Xmx1G" },
      }
      
      metals_config.init_options.statusBarProvider = "on"
      
      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
        
        -- Metals specific mappings
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        
        map("gds", function()
          require("telescope.builtin").lsp_document_symbols()
        end, "Document symbols")
        
        map("gws", function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end, "Workspace symbols")
        
        map("<leader>mc", function()
          require("telescope").extensions.metals.commands()
        end, "Metals commands")
        
        map("<leader>mh", function()
          require("metals").hover_worksheet()
        end, "Metals hover worksheet")
        
        map("<leader>mt", function()
          require("metals.tvp").toggle_tree_view()
        end, "Metals tree view")
        
        map("<leader>mr", function()
          require("metals.tvp").reveal_in_tree()
        end, "Metals reveal in tree")
        
        map("<leader>mw", function()
          require("metals").worksheet_hover()
        end, "Metals worksheet hover")
        
        map("<leader>ml", function()
          require("metals").toggle_logs()
        end, "Metals toggle logs")
      end
      
      return metals_config
    end,
    config = function(self, metals_config)
      -- Disable nvim-metals warnings
      vim.g.metals_disabled_mode = true
      
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          -- Only initialize Metals if it's installed
          local metals_installed = vim.fn.executable("metals") == 1 or vim.fn.executable("cs") == 1
          if metals_installed then
            vim.g.metals_disabled_mode = false
            require("metals").initialize_or_attach(metals_config)
          end
        end,
        group = nvim_metals_group,
      })
    end,
  },
}