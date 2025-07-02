-- Aider integration
return {
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    -- Raccourci : <leader> c A → ouvre le menu de commandes d’Aider
    keys = {
      { "<leader>cA", "<cmd>Aider<cr>", desc = "Aider Command Menu" },
    },
    dependencies = {
      "folke/snacks.nvim",
      -- Les dépendances ci-dessous sont facultatives ; décommentez-les si
      -- vous utilisez déjà ces plugins dans votre configuration.
      -- "catppuccin/nvim",
      -- "nvim-tree/nvim-tree.lua",
      -- { "nvim-neo-tree/neo-tree.nvim" },
    },
    -- Configuration par défaut (modifiable plus tard si besoin)
    config = true,
  },
}
