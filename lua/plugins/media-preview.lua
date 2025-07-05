return {
  -- For Neovide and GUI users: use external image viewer
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- Add custom commands for image preview in neo-tree
      opts.window = opts.window or {}
      opts.window.mappings = opts.window.mappings or {}
      
      -- Add image preview mapping for Neovide
      opts.window.mappings["I"] = {
        function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          local ext = vim.fn.fnamemodify(path, ":e"):lower()
          
          -- Check if it's an image file
          local image_extensions = { "png", "jpg", "jpeg", "gif", "webp", "avif", "svg", "bmp", "ico", "tiff" }
          if vim.tbl_contains(image_extensions, ext) then
            -- Open with system viewer in Neovide
            if vim.fn.has("mac") == 1 then
              vim.fn.jobstart({ "open", path }, { detach = true })
            else
              vim.fn.jobstart({ "xdg-open", path }, { detach = true })
            end
          end
        end,
        desc = "Preview image in external viewer",
      }
      
      return opts
    end,
  },
  
  -- Image.nvim for molten output rendering
  {
    "3rd/image.nvim",
    enabled = true,
    pin = true,  -- Prevent updates (dependency of molten-nvim)
    config = function()
      -- Suppress terminal errors for GUI environments like Neovide
      local ok, image = pcall(require, "image")
      if not ok then
        return
      end
      
      -- Check if we're in a GUI environment
      if vim.fn.has("gui_running") == 1 or vim.g.neovide then
        -- Disable image rendering in GUI but keep plugin loaded for molten compatibility
        image.setup({
          backend = "none",
          integrations = {},
        })
        return
      end
      
      -- Full setup for terminal environments
      image.setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = false,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      })
    end,
  },

  -- PDF preview using peek.nvim for markdown->PDF workflow
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>cp",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Toggle Markdown Preview",
      },
    },
    opts = {
      auto_load = false,
      close_on_bdelete = true,
      syntax = true,
      theme = "dark",
      update_on_change = true,
      app = vim.fn.has("mac") == 1 and "browser" or "webview",
      filetype = { "markdown", "mdx" },
      throttle_at = 200000,
      throttle_time = "auto",
    },
  },

  -- LaTeX to PDF preview with vimtex
  {
    "lervag/vimtex",
    lazy = false,
    keys = {
      { "<leader>ll", "<cmd>VimtexCompile<cr>", desc = "Compile LaTeX" },
      { "<leader>lv", "<cmd>VimtexView<cr>", desc = "View PDF" },
      { "<leader>ls", "<cmd>VimtexStop<cr>", desc = "Stop Compilation" },
      { "<leader>lc", "<cmd>VimtexClean<cr>", desc = "Clean Aux Files" },
      { "<leader>lt", "<cmd>VimtexTocToggle<cr>", desc = "Toggle TOC" },
      { "<leader>le", "<cmd>VimtexErrors<cr>", desc = "Show Errors" },
    },
    init = function()
      -- VimTeX configuration
      vim.g.vimtex_view_method = vim.fn.has("mac") == 1 and "skim" or "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_mappings_enabled = 0
      vim.g.vimtex_indent_enabled = 0
      vim.g.tex_flavor = "latex"
      
      -- For better performance
      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_matchparen_deferred = 0
      vim.g.vimtex_text_obj_enabled = 0
      vim.g.vimtex_imaps_enabled = 0
      
      -- PDF viewer settings
      if vim.fn.has("mac") == 1 then
        vim.g.vimtex_view_skim_sync = 1
        vim.g.vimtex_view_skim_activate = 1
      end
    end,
  },

  -- General document preview (supports multiple formats including PDF)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "mdx" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_browser = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
    },
    ft = { "markdown", "mdx" },
  },

  -- File type specific preview handler
  {
    "nvim-lua/plenary.nvim",
    config = function()
      -- Create custom command for unified preview (Neovide compatible)
      vim.api.nvim_create_user_command("Preview", function(args)
        local file = args.args ~= "" and args.args or vim.fn.expand("%:p")
        local ext = vim.fn.fnamemodify(file, ":e"):lower()
        
        -- Image files - use external viewer in Neovide
        local image_extensions = { "png", "jpg", "jpeg", "gif", "webp", "avif", "svg", "bmp", "ico", "tiff" }
        if vim.tbl_contains(image_extensions, ext) then
          if vim.fn.has("mac") == 1 then
            vim.fn.jobstart({ "open", file }, { detach = true })
          else
            vim.fn.jobstart({ "xdg-open", file }, { detach = true })
          end
          return
        end
        
        -- PDF files
        if ext == "pdf" then
          if vim.fn.has("mac") == 1 then
            vim.fn.jobstart({ "open", file }, { detach = true })
          else
            vim.fn.jobstart({ "xdg-open", file }, { detach = true })
          end
          return
        end
        
        -- Markdown files
        if ext == "md" or ext == "markdown" or ext == "mdx" then
          vim.cmd("MarkdownPreviewToggle")
          return
        end
        
        -- LaTeX files
        if ext == "tex" then
          vim.cmd("VimtexView")
          return
        end
        
        vim.notify("No preview available for ." .. ext .. " files", vim.log.levels.INFO)
      end, {
        nargs = "?",
        complete = "file",
        desc = "Preview current file based on its type"
      })
      
      -- Add global keybinding
      vim.keymap.set("n", "<leader>p", "<cmd>Preview<cr>", { desc = "Preview current file" })
    end,
  },

  -- Diagram renderer (mermaid, plantuml, etc.)
  {
    "3rd/diagram.nvim",
    enabled = false, -- Disabled because it requires image.nvim which needs terminal graphics protocol
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown", "norg" },
    opts = {
      renderer_options = {
        mermaid = {
          theme = "dark",
          background = "transparent",
        },
        plantuml = {
          charset = "utf-8",
        },
        d2 = {
          theme = 0,
          layout = "dagre",
        },
      },
      events = {
        render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
        clear_buffer = { "BufLeave" },
      },
    },
  },
}