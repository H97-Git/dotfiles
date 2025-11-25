return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "float", -- instead of "left" or "right"
      popup = {
        size = { height = "80%", width = "60%" },
        position = "50%", -- center the window
      },
      mapping_options = {
        noremap = true,
        nowait = true,
      },
    },
  },
}
