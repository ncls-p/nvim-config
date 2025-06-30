-- Performance monitoring and optimization
local M = {}

-- Track startup time
vim.g.start_time = vim.fn.reltime()

-- Startup time measurement
function M.startup_time()
  local time = vim.fn.reltimestr(vim.fn.reltime(vim.g.start_time))
  vim.notify(string.format("Neovim started in %.2f ms", tonumber(time) * 1000))
end

-- Profile startup
function M.profile_startup()
  vim.cmd("profile start /tmp/nvim-profile.log")
  vim.cmd("profile func *")
  vim.cmd("profile file *")
end

-- Memory usage
function M.memory_usage()
  local mem = vim.fn.system("ps -o rss= -p " .. vim.fn.getpid())
  vim.notify(string.format("Memory usage: %.1f MB", tonumber(mem) / 1024))
end

-- Plugin load times
function M.plugin_times()
  local lazy = require("lazy")
  local times = {}
  
  for name, plugin in pairs(lazy.plugins()) do
    if plugin._.loaded then
      local time = plugin._.loaded.time or 0
      table.insert(times, { name = name, time = time })
    end
  end
  
  table.sort(times, function(a, b) return a.time > b.time end)
  
  print("Plugin load times:")
  for i = 1, math.min(10, #times) do
    print(string.format("  %s: %.2f ms", times[i].name, times[i].time))
  end
end

-- Auto-command to show startup time
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(M.startup_time, 100)
  end,
})

return M