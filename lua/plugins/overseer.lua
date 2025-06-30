return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    keys = {
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build Task" },
      { "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
      { "<leader>ol", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
      { "<leader>os", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
    },
    opts = {
      strategy = {
        "toggleterm",
        direction = "horizontal",
        autos_croll = true,
        quit_on_exit = "success",
      },
      templates = { "builtin", "user.cpp_build", "user.go_build", "user.npm_scripts", "user.make" },
      auto_scroll = true,
      open_on_start = true,
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },
      form = {
        border = "rounded",
        zindex = 40,
        min_width = 80,
        max_width = 0.9,
        width = nil,
        min_height = 10,
        max_height = 0.9,
        height = nil,
        win_opts = {
          winblend = 10,
        },
      },
      confirm = {
        border = "rounded",
        zindex = 40,
        min_width = 20,
        width = 0.5,
        max_width = 0.8,
        min_height = 6,
        height = 0.9,
        max_height = 0.9,
        win_opts = {
          winblend = 10,
        },
      },
      task_win = {
        padding = 2,
        border = "rounded",
        win_opts = {
          winblend = 10,
        },
      },
      help_win = {
        border = "rounded",
        win_opts = {},
      },
      component_aliases = {
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
        },
        default_neotest = {
          "unique",
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_dispose",
        },
      },
      bundles = {
        save_task_opts = {
          bundleable = true,
        },
        autostart_on_load = true,
      },
      presets = {
        -- Enable some common presets
        default = true,
        -- Custom presets
        build = {
          name = "build",
          builder = function()
            local file = vim.fn.expand("%:p")
            local filetype = vim.bo.filetype
            local commands = {
              go = "go build .",
              rust = "cargo build",
              c = "gcc -o %:r %",
              cpp = "g++ -o %:r %",
              python = "python %",
              javascript = "node %",
              typescript = "npx tsx %",
              lua = "lua %",
              sh = "bash %",
              make = "make",
            }
            
            local cmd = commands[filetype]
            if not cmd then
              if vim.fn.filereadable("Makefile") == 1 then
                cmd = "make"
              elseif vim.fn.filereadable("package.json") == 1 then
                cmd = "npm run build"
              elseif vim.fn.filereadable("Cargo.toml") == 1 then
                cmd = "cargo build"
              elseif vim.fn.filereadable("go.mod") == 1 then
                cmd = "go build ."
              else
                cmd = "echo 'No build command found for " .. filetype .. "'"
              end
            end
            
            return {
              cmd = cmd,
              cwd = vim.fn.expand("%:p:h"),
              components = { "default" },
            }
          end,
        },
        run = {
          name = "run",
          builder = function()
            local file = vim.fn.expand("%:p")
            local filetype = vim.bo.filetype
            local commands = {
              go = "go run .",
              rust = "cargo run",
              c = "./%:r",
              cpp = "./%:r",
              python = "python %",
              javascript = "node %",
              typescript = "npx tsx %",
              lua = "lua %",
              sh = "bash %",
            }
            
            local cmd = commands[filetype]
            if not cmd then
              if vim.fn.filereadable("package.json") == 1 then
                cmd = "npm start"
              elseif vim.fn.filereadable("Cargo.toml") == 1 then
                cmd = "cargo run"
              elseif vim.fn.filereadable("go.mod") == 1 then
                cmd = "go run ."
              else
                cmd = "echo 'No run command found for " .. filetype .. "'"
              end
            end
            
            return {
              cmd = cmd,
              cwd = vim.fn.expand("%:p:h"),
              components = { "default" },
            }
          end,
        },
        test = {
          name = "test",
          builder = function()
            local filetype = vim.bo.filetype
            local commands = {
              go = "go test ./...",
              rust = "cargo test",
              python = "python -m pytest",
              javascript = "npm test",
              typescript = "npm test",
            }
            
            local cmd = commands[filetype]
            if not cmd then
              if vim.fn.filereadable("package.json") == 1 then
                cmd = "npm test"
              elseif vim.fn.filereadable("Cargo.toml") == 1 then
                cmd = "cargo test"
              elseif vim.fn.filereadable("go.mod") == 1 then
                cmd = "go test ./..."
              else
                cmd = "echo 'No test command found for " .. filetype .. "'"
              end
            end
            
            return {
              cmd = cmd,
              cwd = vim.fn.getcwd(),
              components = { "default" },
            }
          end,
        },
      },
      dap = true,
      log = {
        {
          type = "echo",
          level = vim.log.levels.WARN,
        },
        {
          type = "file",
          filename = "overseer.log",
          level = vim.log.levels.DEBUG,
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      
      -- Load custom templates
      overseer.register_template({
        name = "npm scripts",
        builder = function()
          local package_json = vim.fn.findfile("package.json", ".;")
          if package_json == "" then
            return {}
          end
          
          local scripts = {}
          local package_data = vim.fn.json_decode(vim.fn.readfile(package_json))
          
          if package_data and package_data.scripts then
            for script_name, script_cmd in pairs(package_data.scripts) do
              table.insert(scripts, {
                name = "npm run " .. script_name,
                cmd = "npm run " .. script_name,
                cwd = vim.fn.fnamemodify(package_json, ":h"),
                components = { "default" },
              })
            end
          end
          
          return scripts
        end,
        condition = {
          filetype = { "javascript", "typescript", "json" },
        },
      })
      
      -- Auto-open overseer when running tasks
      vim.api.nvim_create_autocmd("User", {
        pattern = "OverseerOnStart",
        callback = function()
          overseer.open({ enter = false })
        end,
      })
      
      -- Quick run commands
      vim.keymap.set("n", "<F5>", function()
        overseer.run_template({ name = "run" })
      end, { desc = "Run current file" })
      
      vim.keymap.set("n", "<F6>", function()
        overseer.run_template({ name = "build" })
      end, { desc = "Build current project" })
      
      vim.keymap.set("n", "<F7>", function()
        overseer.run_template({ name = "test" })
      end, { desc = "Run tests" })
    end,
  },
}