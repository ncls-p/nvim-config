-- vgit.nvim - Visual Git Plugin
-- Lightning-fast git features with visual interface

return {
  'tanvirtin/vgit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons'
  },
  event = 'VeryLazy',
  config = function()
    require('vgit').setup({
      -- Keymaps configuration
      keymaps = {
        ['n ]h'] = function() require('vgit').hunk_down() end,
        ['n [h'] = function() require('vgit').hunk_up() end,
        ['n <leader>gs'] = function() require('vgit').buffer_hunk_stage() end,
        ['n <leader>gr'] = function() require('vgit').buffer_hunk_reset() end,
        ['n <leader>gp'] = function() require('vgit').buffer_hunk_preview() end,
        ['n <leader>gb'] = function() require('vgit').buffer_blame_preview() end,
        ['n <leader>gf'] = function() require('vgit').buffer_diff_preview() end,
        ['n <leader>gd'] = function() require('vgit').project_diff_preview() end,
        ['n <leader>gl'] = function() require('vgit').project_logs_preview() end,
        ['n <leader>gL'] = function() require('vgit').buffer_history_preview() end,
        ['n <leader>gu'] = function() require('vgit').buffer_reset() end,
        ['n <leader>gg'] = function() require('vgit').buffer_gutter_blame_preview() end,
        ['n <leader>gS'] = function() require('vgit').project_stash_preview() end,
        -- Navigation in hunk preview
        ['n <leader>g]'] = nil,  -- Remove duplicate
        ['n <leader>g['] = nil,  -- Remove duplicate
      },
      -- Settings
      settings = {
        git = {
          cmd = 'git', -- git command
          fallback_cwd = vim.fn.expand("$HOME"),
          fallback_args = {
            "--git-dir",
            vim.fn.expand("$HOME/.dotfiles/"),
            "--work-tree",
            vim.fn.expand("$HOME"),
          },
        },
        hls = {
          -- Highlight groups
          GitBackground = 'Normal',
          GitHeader = 'NormalFloat',
          GitFooter = 'NormalFloat',
          GitBorder = 'FloatBorder',
          GitLineNr = 'LineNr',
          GitComment = 'Comment',
          GitSignsAdd = {
            gui = nil,
            fg = '#8ec07c',
            bg = nil,
            sp = nil,
            override = false,
          },
          GitSignsChange = {
            gui = nil,
            fg = '#fabd2f',
            bg = nil,
            sp = nil,
            override = false,
          },
          GitSignsDelete = {
            gui = nil,
            fg = '#fb4934',
            bg = nil,
            sp = nil,
            override = false,
          },
          GitSignsAddLn = 'DiffAdd',
          GitSignsDeleteLn = 'DiffDelete',
          GitWordAdd = {
            gui = nil,
            fg = nil,
            bg = '#32361a',
            sp = nil,
            override = false,
          },
          GitWordDelete = {
            gui = nil,
            fg = nil,
            bg = '#3c1f1e',
            sp = nil,
            override = false,
          },
        },
        live_blame = {
          enabled = true,
          format = function(blame, git_config)
            local author = blame.author
            if git_config and git_config.user and git_config.user.name == author then
              author = 'You'
            end
            local time = os.difftime(os.time(), blame.author_time) / (60 * 60 * 24 * 30 * 12)
            local time_format = string.format('%.0fy ago', time)
            if time < 1 then
              time_format = string.format('%.0fm ago', time * 12)
            end
            local format = string.format('%s, %s', author, time_format)
            return {
              {
                '  ',
              },
              {
                format,
                'Comment',
              },
            }
          end,
        },
        live_gutter = {
          enabled = true,
          edge_navigation = true, -- Navigate to edge hunks when at the top/bottom
        },
        authorship_code_lens = {
          enabled = true,
        },
        scene = {
          diff_preference = 'unified', -- unified or split
          keymaps = {
            quit = 'q'
          },
        },
        diff_preview = {
          keymaps = {
            buffer_stage = 'S',
            buffer_unstage = 'U',
            buffer_hunk_stage = 's',
            buffer_hunk_unstage = 'u',
            toggle_view = 't',
          },
        },
        project_diff_preview = {
          keymaps = {
            buffer_stage = 'S',
            buffer_unstage = 'U',
            buffer_hunk_stage = 's',
            buffer_hunk_unstage = 'u',
            buffer_reset = 'r',
            stage_all = 'a',
            unstage_all = 'A',
            reset_all = 'R',
          },
        },
        signs = {
          priority = 10,
          definitions = {
            GitSignsAddLn = {
              linehl = 'GitSignsAddLn',
              texthl = nil,
              numhl = nil,
              icon = nil,
              text = '',
            },
            GitSignsDeleteLn = {
              linehl = 'GitSignsDeleteLn',
              texthl = nil,
              numhl = nil,
              icon = nil,
              text = '',
            },
            GitSignsAdd = {
              texthl = 'GitSignsAdd',
              numhl = nil,
              icon = nil,
              linehl = nil,
              text = '┃',
            },
            GitSignsDelete = {
              texthl = 'GitSignsDelete',
              numhl = nil,
              icon = nil,
              linehl = nil,
              text = '┃',
            },
            GitSignsChange = {
              texthl = 'GitSignsChange',
              numhl = nil,
              icon = nil,
              linehl = nil,
              text = '┃',
            },
          },
          usage = {
            screen = {
              add = 'GitSignsAddLn',
              remove = 'GitSignsDeleteLn',
            },
            main = {
              add = 'GitSignsAdd',
              remove = 'GitSignsDelete',
              change = 'GitSignsChange',
            },
          },
        },
        symbols = {
          void = '⣿',
        },
      },
    })
  end
}