-- Molten.nvim configuration for interactive code execution with Jupyter kernels
-- Following official repository configuration from https://github.com/benlubas/molten-nvim

return {
  -- Main Molten plugin
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- Pin to stable version
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    lazy = false,  -- Load immediately instead of lazy loading
    ft = { "python", "julia", "r", "lua", "javascript", "typescript" },
    init = function()
      -- Core configuration following official docs
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      
      -- Virtual text configuration
      vim.g.molten_virt_text_max_lines = 10
      
      -- Output window styling
      vim.g.molten_output_show_more = true
      vim.g.molten_output_crop_border = true
      vim.g.molten_output_win_hide_on_leave = true
      
      -- Floating window border
      vim.g.molten_output_win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.molten_output_win_style = "minimal"
      
      -- Auto image popup (optional)
      vim.g.molten_auto_image_popup = false
      
      -- Cover lines configuration
      vim.g.molten_cover_empty_lines = true
      vim.g.molten_cover_lines_starting_with = { "# %%", "# <codecell>" }
      
      -- Tick rate for updates
      vim.g.molten_tick_rate = 150
      
      -- Copy output setting
      vim.g.molten_copy_output = false
    end,
    config = function()
      -- Additional runtime configuration can go here
      
      -- Define text objects for code cells (requires treesitter)
      local function define_cell_text_objects()
        -- For Python files with # %% markers
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
          pattern = { "*.py", "*.ipynb" },
          callback = function()
            -- Basic cell navigation without treesitter dependency
            vim.api.nvim_buf_set_keymap(0, "n", "]c", "", {
              desc = "Next cell",
              callback = function()
                vim.fn.search("^# %%", "W")
              end,
            })
            vim.api.nvim_buf_set_keymap(0, "n", "[c", "", {
              desc = "Previous cell",
              callback = function()
                vim.fn.search("^# %%", "bW")
              end,
            })
          end,
        })
      end
      
      define_cell_text_objects()
      
      -- Auto commands for better UX
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenInitPost",
        callback = function()
          -- Automatically open output window when kernel initializes
          vim.notify("Molten kernel initialized", vim.log.levels.INFO)
        end,
      })
      
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenDeinitPost",
        callback = function()
          vim.notify("Molten kernel shut down", vim.log.levels.INFO)
        end,
      })
    end,
    keys = {
      -- Core keybindings following official minimal setup
      { "<leader>mi", ":MoltenInit<CR>", desc = "Initialize Molten kernel", silent = true },
      { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Evaluate operator", silent = true },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Evaluate line", silent = true },
      { "<leader>mc", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell", silent = true },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate visual selection", silent = true },
      
      -- Output management
      { "<leader>md", ":MoltenDelete<CR>", desc = "Delete cell", silent = true },
      { "<leader>mh", ":MoltenHideOutput<CR>", desc = "Hide output", silent = true },
      { "<leader>ms", ":MoltenEnterOutput<CR>", desc = "Show/enter output", silent = true },
      
      -- Navigation  
      { "]m", ":MoltenNext<CR>", desc = "Next molten cell", silent = true },
      { "[m", ":MoltenPrev<CR>", desc = "Previous molten cell", silent = true },
      
      -- Kernel management
      { "<leader>mI", ":MoltenInterrupt<CR>", desc = "Interrupt kernel", silent = true },
      { "<leader>mR", ":MoltenRestart!<CR>", desc = "Restart kernel", silent = true },
      
      -- Import/Export for Jupyter notebooks
      { "<leader>mE", ":MoltenExportOutput<CR>", desc = "Export to .ipynb", silent = true },
      { "<leader>mP", ":MoltenImportOutput<CR>", desc = "Import from .ipynb", silent = true },
      
      -- Image popup for plots
      { "<leader>mp", ":MoltenImagePopup<CR>", desc = "Show image popup", silent = true },
      
      -- Save/Load sessions
      { "<leader>mS", ":MoltenSave<CR>", desc = "Save session", silent = true },
      { "<leader>mL", ":MoltenLoad<CR>", desc = "Load session", silent = true },
    },
  },

  -- Image.nvim for displaying plots and images
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty", -- or "ueberzug" for X11
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "", "minifiles" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      -- Disable hijack_file_patterns to prevent conflicts with mini.files
      hijack_file_patterns = {},
    },
    config = function(_, opts)
      require("image").setup(opts)
    end,
  },

  -- Optional: Jupytext integration for .ipynb files
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    ft = { "ipynb" },
    build = "pip3 install --user jupytext",
    config = function()
      require("jupytext").setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "markdown",
        -- Molten can handle the converted markdown files
        custom_language_formatting = {
          python = {
            extension = "md",
            style = "markdown",
            force_ft = "markdown",
          },
        },
      })
    end,
  },

  -- Optional: vim-slime for alternative REPL interaction
  {
    "jpalardy/vim-slime",
    lazy = true,
    ft = { "python", "julia", "r" },
    init = function()
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_python_ipython = 1
    end,
    keys = {
      { "<leader>ss", "<Plug>SlimeSendCell", desc = "Send cell to REPL" },
      { "<leader>sl", "<Plug>SlimeLineSend", desc = "Send line to REPL" },
      { "<leader>sv", "<Plug>SlimeRegionSend", mode = "v", desc = "Send region to REPL" },
      { "<leader>sc", "<Plug>SlimeConfig", desc = "Configure Slime" },
    },
  },
}