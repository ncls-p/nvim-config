-- Aider integration
return {
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    -- Keymap : <leader>cA → ouvre le menu de commandes d’Aider
    keys = {
      { "<leader>cA", "<cmd>Aider<cr>", desc = "Aider Command Menu" },
    },
    dependencies = {
      "folke/snacks.nvim",
      -- Les dépendances ci-dessous sont facultatives ; décommentez-les
      -- si vous utilisez déjà ces plugins dans votre configuration.
      -- "catppuccin/nvim",
      -- "nvim-tree/nvim-tree.lua",
      -- { "nvim-neo-tree/neo-tree.nvim" },
    },
    -- Paramètres passés à require("nvim_aider").setup(...)
    opts = {
      -- Arguments par défaut transmis à la CLI `aider`
      args = {
        "--no-auto-commits",
        "--pretty",
        "--stream",
      },
    },
    -- Laisser Lazy appeler automatiquement setup avec `opts`
    config = true,
  },
}
