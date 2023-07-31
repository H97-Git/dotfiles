return {
  "ThePrimeagen/vim-be-good",
  "ziontee113/icon-picker.nvim",
  opts = {
    function()
      require("icon-picker").setup({
        disable_legacy_commands = true,
      })
    end,
  },
  {
    "crusj/bookmarks.nvim",
    opts = {
      function()
        require("bookmarks").setup()
      end,
    },
  },
  {
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup({
        -- optionally override defaults
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      })
    end,
  },
  -- {
  --   "m4xshen/hardtime.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- {
  --   "gelguy/wilder.nvim",
  --   opts = {
  --     function()
  --       require("wilder").setup({ modes = { ":", "/", "?" } })
  --     end,
  --   },
  -- },
}
