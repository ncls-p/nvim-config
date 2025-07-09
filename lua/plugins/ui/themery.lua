return {
  -- Theme manager
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      -- Automatic theme discovery - detects ALL installed colorschemes
      local function discover_themes()
        local all_colors = vim.fn.getcompletion("", "color")
        
        -- Filter out basic vim themes we don't want (keep only modern ones)
        local excluded_themes = {
          "blue", "darkblue", "delek", "desert", "elflord", "evening", 
          "industry", "koehler", "morning", "murphy", "pablo", "peachpuff",
          "ron", "shine", "slate", "torte", "zellner", "lunaperche",
          "quiet", "retrobox", "sorbet", "wildcharm"
        }
        
        local discovered_themes = {}
        for _, color in ipairs(all_colors) do
          local is_excluded = false
          for _, excluded in ipairs(excluded_themes) do
            if color == excluded then
              is_excluded = true
              break
            end
          end
          if not is_excluded then
            table.insert(discovered_themes, color)
          end
        end
        
        -- Sort themes alphabetically for better UX
        table.sort(discovered_themes)
        
        return discovered_themes
      end
      
      require("themery").setup({
        themes = discover_themes(),
        livePreview = true, -- Apply theme while browsing
      })
    end,
    keys = {
      { "<leader>uT", "<cmd>Themery<cr>", desc = "🎨 Theme manager" },
    },
  },
}
