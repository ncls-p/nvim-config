return {
  -- Modern bufferline for visual buffer management
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete Other Buffers" },
      { "<leader>bm", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Left" },
      { "<leader>bn", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Right" },
      { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to Buffer 1" },
      { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to Buffer 2" },
      { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to Buffer 3" },
      { "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to Buffer 4" },
      { "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to Buffer 5" },
    },
    opts = {
      options = {
        mode = "buffers", -- "tabs" or "buffers"
        themable = true,
        numbers = "ordinal", -- "none" | "ordinal" | "buffer_id" | "both"
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        -- Sidebar offsets for file explorers
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        separator_style = "slope", -- More rounded appearance
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        -- Hide "No Name" buffers
        custom_filter = function(buf_number, buf_numbers)
          -- Filter out buffers with no name and no content
          local buf_name = vim.fn.bufname(buf_number)
          if buf_name == "" then
            -- Check if buffer has any content
            local lines = vim.api.nvim_buf_get_lines(buf_number, 0, -1, false)
            local has_content = false
            for _, line in ipairs(lines) do
              if line ~= "" then
                has_content = true
                break
              end
            end
            return has_content
          end
          return true
        end,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {'close'}
        },
        sort_by = 'insert_after_current',
      },
      highlights = {
        fill = {
          bg = {
            attribute = "bg",
            highlight = "TabLine"
          },
        },
        background = {
          bg = {
            attribute = "bg",
            highlight = "TabLine"
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(function() vim.cmd("BufferLineSort") end)
          end)
        end,
      })
    end,
  },
}