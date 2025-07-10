-- Markdown Preview Plugin Configuration
-- Real-time markdown preview in browser with synchronized scrolling

return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      local install_cmd = "cd app && "
      if vim.fn.executable("yarn") == 1 then
        install_cmd = install_cmd .. "yarn install"
      else
        install_cmd = install_cmd .. "npm install"
      end
      vim.fn.system(install_cmd)
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      
      -- Configuration options
      vim.g.mkdp_auto_start = 0 -- Don't auto-start preview
      vim.g.mkdp_auto_close = 1 -- Auto-close preview when changing buffer
      vim.g.mkdp_refresh_slow = 0 -- Real-time refresh
      vim.g.mkdp_command_for_global = 0 -- Preview only for markdown files
      vim.g.mkdp_open_to_the_world = 0 -- Only accessible from localhost
      vim.g.mkdp_open_ip = '' -- Use default
      vim.g.mkdp_browser = '' -- Use system default browser
      vim.g.mkdp_echo_preview_url = 1 -- Echo preview URL
      vim.g.mkdp_browserfunc = '' -- Use default
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
      vim.g.mkdp_markdown_css = '' -- Use default CSS
      vim.g.mkdp_highlight_css = '' -- Use default highlight CSS
      vim.g.mkdp_port = '' -- Use random port
      vim.g.mkdp_page_title = '「${name}」' -- Page title format
      vim.g.mkdp_images_path = '' -- Default images path
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'dark' -- Use dark theme
      vim.g.mkdp_combine_preview = 0 -- Don't combine preview windows
      vim.g.mkdp_combine_preview_auto_refresh = 1
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
      { "<leader>mo", "<cmd>MarkdownPreview<cr>", desc = "Start Markdown Preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Markdown Preview" },
    },
  },
  
  -- Optional: Enhanced in-editor markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { "markdown" },
    opts = {
      enabled = true,
      max_file_size = 10.0, -- MB
      preset = 'lazy', -- Use a balanced preset
      anti_conceal = {
        enabled = true,
      },
      heading = {
        enabled = true,
        sign = true,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      },
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        disable_background = false,
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'thin',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',
      },
      checkbox = {
        enabled = true,
        position = 'inline',
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
          important = { raw = '[!]', rendered = '󰅾 ', highlight = 'RenderMarkdownImportant' },
        },
      },
      quote = {
        enabled = true,
        icon = '▎',
        repeat_linebreak = false,
        highlight = 'RenderMarkdownQuote',
      },
      pipe_table = {
        enabled = true,
        preset = 'round',
        style = 'full',
        cell = 'padded',
        padding = 1,
        min_width = 0,
        border = {
          '│', '─', '│', '│',
          '╭', '┬', '╮',
          '├', '┼', '┤',
          '╰', '┴', '╯',
        },
        alignment_indicator = '━',
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        filler = 'RenderMarkdownTableFill',
      },
      callout = {
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
      },
      link = {
        enabled = true,
        image = '󰥶 ',
        email = '@ ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
        custom = {
          web = { pattern = '^http', icon = '󰖟 ' },
        },
      },
      sign = {
        enabled = true,
        exclude = {
          buftypes = { 'nofile' },
        },
      },
      indent = {
        enabled = true,
        per_level = 2,
        skip_level = 1,
        skip_heading = false,
      },
    },
  },
}