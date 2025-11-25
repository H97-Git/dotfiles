return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      omnisharp = false,
      csharp_ls = {}, -- lightweight and works well with diagnostics/rename/hover
    },
  },
}
