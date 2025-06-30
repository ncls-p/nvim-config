return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionChat<cr>", desc = "AI Chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    },
    opts = {
      adapters = {
        helix = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://helixmind.online",
              api_key = os.getenv("HELIXMIND_API_KEY") or "cmd:echo $HELIXMIND_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = { default = "deepseek-reasoner" },
            },
          })
        end,
        openwebui = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://owebui.nclsp.com",
              api_key = "sk-0db5bf539cd943d09ba33e3bf066c71c",
              chat_url = "/api/chat/completions",
            },
            schema = {
              model = { default = "qwen2.5-coder:1.5b-base" },
            },
          })
        end,
      },
      strategies = {
        chat = { adapter = "helix" },
        inline = { adapter = "openwebui" },
      },
    },
  },
}

