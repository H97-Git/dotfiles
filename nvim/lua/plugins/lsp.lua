return {
  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "onsails/lspkind.nvim",
  },
  {
    "simrat39/symbols-outline.nvim",
  },
}
