return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },

      -- Live Grep : always start empty and never resume
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep({
            resume = false, -- disable automatic resume
          })
        end,
        desc = "Live Grep",
      },

      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
      { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
      { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
      { "<leader>fl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
      { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
      { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "Jumps" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Word under cursor" },
      { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "WORD under cursor" },
      { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
      { "<leader>f:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      -- Git
      { "<leader>gf", "<cmd>FzfLua git_files<cr>", desc = "Git Files" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
      { "<leader>gC", "<cmd>FzfLua git_bcommits<cr>", desc = "Buffer Git Commits" },
      { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
      { "<leader>gt", "<cmd>FzfLua git_tags<cr>", desc = "Git Tags" },
      { "<leader>gh", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
      -- LSP
      { "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Go to Definition" },
      { "gr", "<cmd>FzfLua lsp_references<cr>", desc = "References" },
      { "gi", "<cmd>FzfLua lsp_implementations<cr>", desc = "Go to Implementation" },
      { "gt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Go to Type Definition" },
      { "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code Actions" },
    },
    opts = function()
      local actions = require("fzf-lua.actions")
      return {
        "default-title",
        fzf_colors = true,
        fzf_opts = { ["--no-scrollbar"] = true },
        defaults = { formatter = "path.filename_first" },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = { "chafa" },
              ["jpg"] = { "chafa" },
              ["jpeg"] = { "chafa" },
              ["gif"] = { "chafa" },
              ["webp"] = { "chafa" },
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollbar = "float",
            scrolloff = -1,
            scrollchars = { "┃", "" },
          },
        },
        keymap = {
          builtin = {
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            ["<PageDown>"] = "preview-page-down",
            ["<PageUp>"] = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
          },
          fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["shift-down"] = "preview-page-down",
            ["shift-up"] = "preview-page-up",
          },
        },
        actions = {
          files = {
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-s"]  = actions.file_split,
            ["ctrl-v"]  = actions.file_vsplit,
            ["ctrl-t"]  = actions.file_tabedit,
            ["alt-q"]   = actions.file_sel_to_qf,
            ["alt-l"]   = actions.file_sel_to_ll,
          },
          buffers = {
            ["default"] = actions.buf_edit,
            ["ctrl-s"]  = actions.buf_split,
            ["ctrl-v"]  = actions.buf_vsplit,
            ["ctrl-t"]  = actions.buf_tabedit,
          },
        },
        -- Remaining configuration unchanged
      }
    end,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
    end,
  },
}
