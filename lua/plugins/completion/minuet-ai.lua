return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Note: MunifTanjim/nui.nvim is not needed according to the docs
    },
    event = "InsertEnter",
    config = function()
      -- Check if API key exists
      if not vim.env.CODESTRAL_API_KEY then
        vim.notify("Minuet: CODESTRAL_API_KEY not found!", vim.log.levels.ERROR)
        return
      end

      require("minuet").setup({
        provider = "codestral",
        notify = false, -- Disable all notifications
        provider_options = {
          codestral = {
            model = 'codestral-latest',
            end_point = 'https://codestral.mistral.ai/v1/fim/completions',
            api_key = 'CODESTRAL_API_KEY', -- Use string reference to env var
            stream = true,
            optional = {
              max_tokens = 256,
              stop = { '\n\n' },
            },
          },
        },
        -- Configure virtual text with keymaps
        virtualtext = {
          enabled = true,
          auto_trigger_ft = { "*" }, -- Enable for all file types
          keymap = {
            accept = "<A-y>",
            accept_line = nil,
            accept_n_lines = nil,
            next = "<A-n>",
            prev = "<A-p>",
            dismiss = "<A-c>",
          },
        },
        -- Set buffer variable to enable auto-trigger by default
        on_setup = function()
          vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = "*",
            callback = function()
              vim.b.minuet_virtual_text_auto_trigger = true
            end,
          })
        end,
      })

      -- Ensure auto-trigger is enabled for all buffers
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "InsertEnter" }, {
        pattern = "*",
        callback = function()
          vim.b.minuet_virtual_text_auto_trigger = true
        end,
      })

      -- Enable auto-trigger for the current buffer immediately
      vim.b.minuet_virtual_text_auto_trigger = true

      -- Also set it for any already opened buffers
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          vim.api.nvim_buf_set_var(buf, "minuet_virtual_text_auto_trigger", true)
        end
      end
    end,
    keys = {
      -- Manual trigger for suggestions
      { "<A-\\>", function() require('minuet.virtualtext').action.next() end,    mode = "i", desc = "Trigger Minuet suggestion" },
      -- Additional keybindings that override the defaults if needed
      { "<A-y>",  function() require('minuet.virtualtext').action.accept() end,  mode = "i", desc = "Accept Minuet suggestion" },
      { "<A-n>",  function() require('minuet.virtualtext').action.next() end,    mode = "i", desc = "Next Minuet suggestion" },
      { "<A-p>",  function() require('minuet.virtualtext').action.prev() end,    mode = "i", desc = "Previous Minuet suggestion" },
      { "<A-c>",  function() require('minuet.virtualtext').action.dismiss() end, mode = "i", desc = "Dismiss Minuet suggestion" },

      -- macOS-friendly keymaps using Cmd (D- in Neovim)
      { "<D-y>",  function() require('minuet.virtualtext').action.accept() end,  mode = "i", desc = "Accept Minuet suggestion" },
      { "<D-]>",  function() require('minuet.virtualtext').action.next() end,    mode = "i", desc = "Next Minuet suggestion" },
      { "<D-[>",  function() require('minuet.virtualtext').action.prev() end,    mode = "i", desc = "Previous Minuet suggestion" },
      { "<D-/>",  function() require('minuet.virtualtext').action.dismiss() end, mode = "i", desc = "Dismiss Minuet suggestion" },

      -- Alternative Tab-based keymaps (common for completion)
      {
        "<Tab>",
        function()
          if require('minuet.virtualtext').action.is_visible() then
            require('minuet.virtualtext').action.accept()
          else
            return "<Tab>"
          end
        end,
        mode = "i",
        expr = true,
        desc = "Accept Minuet or insert Tab"
      },
      { "<S-Tab>", function() require('minuet.virtualtext').action.prev() end, mode = "i", desc = "Previous Minuet suggestion" },
    },
  },
}
