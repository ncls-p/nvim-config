return {
  -- 🎨 Ultimate 2025 theme collection - Most popular & trending themes

  -- 🌸 Rose Pine - Soho vibes
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "auto",      -- auto, main, moon, dawn
      dark_variant = "main", -- main, moon, dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",
        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",
        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",
        headings = {
          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },
      },
      palette = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
      },
      highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
      },
      before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
      end,
    },
  },

  -- 🌊 Kanagawa - Beautiful Japanese-inspired theme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
        }
      end,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus"
      },
    },
  },

  -- 🌙 Tokyo Night - Clean and modern
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night, day
      light_style = "day",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      use_background = true,
      on_colors = function(colors) end,
      on_highlights = function(highlights, colors) end,
    },
  },

  -- 🐱 Catppuccin - Soothing pastel theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
    },
  },

  -- 🦊 Nightfox - Beautiful and highly customizable
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    opts = {
      options = {
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled",
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        module_default = true,
        colorblind = {
          enable = false,
          simulate_only = false,
          severity = {
            protan = 0,
            deutan = 0,
            tritan = 0,
          },
        },
        styles = {
          comments = "italic",
          conditionals = "NONE",
          constants = "NONE",
          functions = "NONE",
          keywords = "NONE",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "NONE",
          variables = "NONE",
        },
        inverse = {
          match_paren = false,
          visual = false,
          search = false,
        },
      },
      palettes = {},
      specs = {},
      groups = {},
    },
  },

  -- 🌲 Everforest - Comfortable theme for long coding sessions
  {
    "neanias/everforest-nvim",
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "hard", -- hard, medium, soft
        transparent_background_level = 0,
        italics = false,
        disable_italic_comments = false,
        sign_column_background = "none",
        ui_contrast = "low",
        dim_inactive_windows = false,
        diagnostic_text_highlight = false,
        diagnostic_virtual_text = "coloured",
        diagnostic_line_highlight = false,
        spell_foreground = false,
        show_eob = true,
        float_style = "bright",
        inlay_hints_background = "none",
        on_highlights = function(highlight_groups, palette) end,
        colours_override = function(palette) end,
      })
    end,
  },

  -- 🌌 Oxocarbon - IBM Carbon inspired
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
  },

  -- 🎃 Gruvbox Material - Modern Gruvbox
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'hard'     -- soft, medium, hard
      vim.g.gruvbox_material_foreground = 'material' -- material, mix, original
      vim.g.gruvbox_material_disable_italic_comment = 0
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 0
      vim.g.gruvbox_material_cursor = 'auto'
      vim.g.gruvbox_material_transparent_background = 0
      vim.g.gruvbox_material_dim_inactive_windows = 0
      vim.g.gruvbox_material_visual = 'grey background'
      vim.g.gruvbox_material_menu_selection_background = 'grey'
      vim.g.gruvbox_material_sign_column_background = 'none'
      vim.g.gruvbox_material_spell_foreground = 'none'
      vim.g.gruvbox_material_ui_contrast = 'low'    -- low, high
      vim.g.gruvbox_material_show_eob = 1
      vim.g.gruvbox_material_float_style = 'bright' -- bright, dim
      vim.g.gruvbox_material_diagnostic_text_highlight = 0
      vim.g.gruvbox_material_diagnostic_line_highlight = 0
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.g.gruvbox_material_current_word = 'grey background'
      vim.g.gruvbox_material_statusline_style = 'default'
      vim.g.gruvbox_material_lightline_disable_bold = 0
      vim.g.gruvbox_material_better_performance = 1
    end,
  },

  -- 🌈 Neomodern collection - Modern themes
  {
    "cdmill/neomodern.nvim",
    priority = 1000,
    config = function()
      require("neomodern").setup({
        style = "roseprime", -- iceberg, campfire, darkforest, roseprime
        toggle_style_key = nil,
        toggle_style_list = {
          "iceberg",
          "campfire",
          "darkforest",
          "roseprime",
        },
        transparent = false,
        term_colors = true,
        code_style = {
          comments = "italic",
          conditionals = "none",
          functions = "none",
          keywords = "none",
          headings = "bold",
          operators = "none",
          keyword_return = "none",
          strings = "none",
          variables = "none",
        },
        ui = {
          colored_docstrings = true,
          plain_float = false,
          show_eob = true,
          highlight_inactive_windows = false,
        },
        custom_highlights = {},
        custom_colors = {},
      })
    end,
  },

  -- 📈 OneDark - Based on Atom's One Dark (Top trending 2025)
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = 'dark', -- dark, darker, cool, deep, warm, warmer, light
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      toggle_style_key = nil,
      toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' },
      code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
      },
      lualine = {
        transparent = false,
      },
      colors = {},
      highlights = {},
      diagnostics = {
        darker = true,
        undercurl = true,
        background = true,
      },
    },
  },

  -- 💜 VSCode Theme - VS Code inspired (Highly popular)
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    opts = {
      transparent = false,
      italic_comments = true,
      underline_links = true,
      disable_nvimtree_bg = true,
      color_overrides = {},
      group_overrides = {},
    },
  },

  -- 🏗️ Material - Material Design for Neovim
  {
    "marko-cerovac/material.nvim",
    priority = 1000,
    opts = {
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        lsp_virtual_text = false,
        non_current_windows = false,
        filetypes = {},
      },
      styles = {
        comments = { italic = true },
        strings = { bold = false },
        keywords = { underline = false },
        functions = { bold = false, undercurl = false },
        variables = {},
        operators = {},
        types = {},
      },
      plugins = {
        "dap",
        "dashboard",
        "gitsigns",
        "hop",
        "indent-blankline",
        "lspsaga",
        "mini",
        "neogit",
        "neorg",
        "nvim-cmp",
        "nvim-navic",
        "nvim-tree",
        "nvim-web-devicons",
        "sneak",
        "telescope",
        "trouble",
        "which-key",
        "nvim-notify",
      },
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        term_colors = false,
        eob_lines = false
      },
      high_visibility = {
        lighter = false,
        darker = false
      },
      lualine_style = "default",
      async_loading = true,
      custom_colors = nil,
      custom_highlights = {},
    },
  },

  -- 🎨 OneDarkPro - Atom's iconic One Dark with variants (Simplified config)
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    opts = {
      styles = {
        comments = "italic",
        keywords = "bold",
        functions = "italic",
      },
      options = {
        cursorline = false,
        transparency = false,
        terminal_colors = true,
      }
    },
  },

  -- 🏯 Solarized Osaka - Clean theme with LSP support
  {
    "craftzdog/solarized-osaka.nvim",
    priority = 1000,
    opts = {
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      on_colors = function(colors) end,
      on_highlights = function(highlights, colors) end,
    },
  },

  -- ❄️ Nord - Arctic-inspired theme
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false
    end,
  },

  -- 🌒 Nordic - Nord but warmer and darker
  {
    "AlexvZyl/nordic.nvim",
    priority = 1000,
    config = function()
      require("nordic").setup({
        on_palette = function(palette) return palette end,
        bold_keywords = false,
        italic_comments = true,
        transparent = {
          bg = false,
          float = false,
        },
        bright_border = false,
        reduced_blue = true,
        swap_backgrounds = false,
        on_highlight = function(highlights, palette) end,
        telescope = {
          style = "classic",
        },
        leap = {
          dim_backdrop = false,
        },
        ts_context = {
          dark_background = true,
        }
      })
    end,
  },

  -- 🕊️ Duskfox - Beautiful dusk-inspired theme (part of Nightfox family)
  -- Note: Duskfox is included in the main Nightfox plugin above

  -- 🌌 Cyberdream - Futuristic cyberpunk theme
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    opts = {
      transparent = false,
      italic_comments = false,
      hide_fillchars = false,
      borderless_telescope = true,
      terminal_colors = true,
      cache = false,
      theme = {
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set it based on vim.o.background
        highlights = {},
        colors = {},
        overrides = function(colors) -- Override a highlight group entirely using the color palette
          return {}
        end,
      },
      extensions = {
        telescope = true,
        notify = true,
        mini = true,
      },
    },
  },

  -- 🌟 Auto theme switching based on time
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd("colorscheme tokyonight-night")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd("colorscheme tokyonight-day")
      end,
    },
  },

  -- 🎨 Enhanced colorscheme picker with live preview
  {
    "zaldih/themery.nvim",
    cmd = "Themery",
    config = function()
      require("themery").setup({
        themes = {
          -- 🔥 Top Trending 2025 Themes
          {
            name = "🌙 Tokyo Night - Night",
            colorscheme = "tokyonight-night"
          },
          {
            name = "⛈️  Tokyo Night - Storm",
            colorscheme = "tokyonight-storm"
          },
          {
            name = "🌕 Tokyo Night - Moon",
            colorscheme = "tokyonight-moon"
          },
          {
            name = "☀️  Tokyo Night - Day",
            colorscheme = "tokyonight-day"
          },
          {
            name = "☕ Catppuccin - Mocha",
            colorscheme = "catppuccin-mocha"
          },
          {
            name = "🥛 Catppuccin - Macchiato",
            colorscheme = "catppuccin-macchiato"
          },
          {
            name = "🧊 Catppuccin - Frappe",
            colorscheme = "catppuccin-frappe"
          },
          {
            name = "🥖 Catppuccin - Latte",
            colorscheme = "catppuccin-latte"
          },
          {
            name = "🌊 Kanagawa - Wave",
            colorscheme = "kanagawa-wave"
          },
          {
            name = "🐉 Kanagawa - Dragon",
            colorscheme = "kanagawa-dragon"
          },
          {
            name = "🪷 Kanagawa - Lotus",
            colorscheme = "kanagawa-lotus"
          },
          {
            name = "🌹 Rose Pine - Main",
            colorscheme = "rose-pine"
          },
          {
            name = "🌙 Rose Pine - Moon",
            colorscheme = "rose-pine-moon"
          },
          {
            name = "🌅 Rose Pine - Dawn",
            colorscheme = "rose-pine-dawn"
          },

          -- 📈 Most Popular Atom/VS Code Inspired
          {
            name = "📈 OneDark - Dark",
            colorscheme = "onedark"
          },
          {
            name = "💜 VS Code - Dark",
            colorscheme = "vscode"
          },
          {
            name = "🎨 OneDarkPro",
            colorscheme = "onedarkpro"
          },
          {
            name = "🏗️ Material",
            colorscheme = "material"
          },
          {
            name = "🏯 Solarized Osaka",
            colorscheme = "solarized-osaka"
          },

          -- 🦊 Nightfox Family
          {
            name = "🦊 Nightfox",
            colorscheme = "nightfox"
          },
          {
            name = "🌍 Terafox",
            colorscheme = "terafox"
          },
          {
            name = "⚫ Carbonfox",
            colorscheme = "carbonfox"
          },
          {
            name = "🌄 Dawnfox",
            colorscheme = "dawnfox"
          },
          {
            name = "🌞 Dayfox",
            colorscheme = "dayfox"
          },
          {
            name = "🌆 Duskfox",
            colorscheme = "duskfox"
          },
          {
            name = "❄️  Nordfox",
            colorscheme = "nordfox"
          },

          -- 🌲 Nature Inspired
          {
            name = "🌲 Everforest",
            colorscheme = "everforest"
          },
          {
            name = "🎃 Gruvbox Material",
            colorscheme = "gruvbox-material"
          },
          {
            name = "❄️  Nord",
            colorscheme = "nord"
          },
          {
            name = "🌒 Nordic",
            colorscheme = "nordic"
          },

          -- 🚀 Modern & Futuristic
          {
            name = "⚫ Oxocarbon",
            colorscheme = "oxocarbon"
          },
          {
            name = "🌌 Cyberdream",
            colorscheme = "cyberdream"
          },
          {
            name = "🧊 Neomodern - Iceberg",
            colorscheme = "neomodern"
          },
        },
        livePreview = true, -- 🎯 Live preview as you navigate!
        -- Auto apply theme when leaving themery
        onApply = function(colorscheme)
          vim.notify("🎨 Applied theme: " .. colorscheme, vim.log.levels.INFO)
        end,
      })
    end,
    keys = {
      { "<leader>uT", "<cmd>Themery<cr>", desc = "🎨 Theme picker with preview" },
      { "<leader>ut", "<cmd>Themery<cr>", desc = "🎨 Theme picker with preview" },
    },
  },
}

