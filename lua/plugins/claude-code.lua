return {
  -- Claude Code CLI integration for Neovim
  {
    "greggh/claude-code.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup({
        -- Terminal window settings
        window = {
          split_ratio = 0.3, -- Terminal window size (30% of screen)
          position = "botright", -- Position: "botright", "topleft", "vertical", etc.
          enter_insert = true, -- Enter insert mode when opening Claude Code
          hide_numbers = true, -- Hide line numbers in terminal
          hide_signcolumn = true, -- Hide sign column in terminal
        },
        
        -- File refresh settings
        refresh = {
          enable = true, -- Enable file change detection
          updatetime = 100, -- updatetime when Claude Code is active (ms)
          timer_interval = 1000, -- How often to check for file changes (ms)
          show_notifications = true, -- Show notification when files are reloaded
        },
        
        -- Git project settings
        git = {
          use_git_root = true, -- Set CWD to git root when opening Claude Code
        },
        
        -- Shell settings (ensure bash is used for the wrapper script)
        shell = {
          cmd = "/bin/bash", -- Use bash to run the command
        },
        
        -- Command configuration
        command = "/Users/ncls/.claude/local/claude", -- Full path to claude CLI
        
        -- Command variants
        command_variants = {
          default = "",
          continue = "--continue",
        },
      })
      
      -- Default keymaps are automatically set up by the plugin
      -- You can override them if needed
    end,
  },
}