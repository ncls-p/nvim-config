return {
  -- Mini.tabline for buffer/tab line
  {
    "echasnovski/mini.tabline",
    version = false,
    event = "VeryLazy",
    keys = {
      { "<leader>bp", function() vim.cmd("pin") end, desc = "Pin current buffer" },
      { "<leader>bo", function() vim.cmd("BufferCloseAllBut") end, desc = "Close all but current" },
      { "<Tab>", "<cmd>bnext<cr>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>bprevious<cr>", desc = "Previous buffer" },
    },
    config = function()
      require("mini.tabline").setup({
        show_icons = true,
        set_vim_settings = true,
        tabpage_section = "right",
        format = function(buf_id, label)
          local suffix = vim.bo[buf_id].modified and " ●" or ""
          
          -- Add LSP error indicator
          local diagnostics = vim.diagnostic.get(buf_id, { severity = vim.diagnostic.severity.ERROR })
          local error_indicator = #diagnostics > 0 and " " or ""
          
          -- Add git status (if available)
          local git_status = ""
          if vim.b[buf_id].gitsigns_status_dict then
            local status = vim.b[buf_id].gitsigns_status_dict
            if status.added and status.added > 0 then
              git_status = git_status .. " +"
            end
            if status.changed and status.changed > 0 then
              git_status = git_status .. " ~"
            end
            if status.removed and status.removed > 0 then
              git_status = git_status .. " -"
            end
          end
          
          return "  " .. label .. suffix .. error_indicator .. git_status .. "  │"
        end,
      })
      
      -- Custom command to close all buffers except current
      vim.api.nvim_create_user_command("BufferCloseAllBut", function()
        local current = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if buf ~= current and vim.bo[buf].buflisted then
            vim.api.nvim_buf_delete(buf, { force = false })
          end
        end
      end, {})
    end,
  },
}