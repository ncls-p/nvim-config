local M = {}

-- Path to store theme preference
local theme_file = vim.fn.stdpath("data") .. "/theme.txt"

-- Save current theme to file
function M.save_theme(theme_name)
  local file = io.open(theme_file, "w")
  if file then
    file:write(theme_name)
    file:close()
    vim.notify("Theme saved: " .. theme_name, vim.log.levels.INFO)
  else
    vim.notify("Failed to save theme", vim.log.levels.ERROR)
  end
end

-- Load theme from file
function M.load_theme()
  local file = io.open(theme_file, "r")
  if file then
    local theme_name = file:read("*all"):gsub("%s+", "")
    file:close()
    if theme_name and theme_name ~= "" then
      -- Try to apply the theme
      local ok, err = pcall(function()
        vim.cmd.colorscheme(theme_name)
      end)
      if not ok then
        vim.notify("Failed to load saved theme: " .. theme_name .. " - " .. tostring(err), vim.log.levels.WARN)
        return nil
      end
      vim.notify("Loaded saved theme: " .. theme_name, vim.log.levels.INFO)
      return theme_name
    end
  end
  return nil
end

-- Get current theme name
function M.get_current_theme()
  return vim.g.colors_name or "default"
end

-- Theme picker with persistence
function M.theme_picker_with_persistence()
  local telescope = require("telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  
  telescope.colorscheme({
    enable_preview = true,
    ignore_builtins = true,
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection then
          actions.close(prompt_bufnr)
          -- Apply the theme
          vim.cmd.colorscheme(selection.value)
          -- Save the theme
          M.save_theme(selection.value)
        end
      end)
      return true
    end,
  })
end

return M