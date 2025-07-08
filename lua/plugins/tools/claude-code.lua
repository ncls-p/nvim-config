return {
  -- Claude Code integration
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup({
        window = {
          split_ratio = 0.8,
          position = "float",
          enter_insert = true,
          float_opts = {
            border = "rounded",
            width = 0.8,
            height = 0.8,
            row = 0.1,
            col = 0.1,
          }
        },
        command = "claude"
      })
    end,
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
      { "<leader>cC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Code Continue" },
    },
  },
}