return {
    ["nathom/filetype.nvim"] = {},
    ["romgrk/barbar.nvim"] = {after = "nvim-web-devicons"},
    ["folke/trouble.nvim"] = {},
    ["kevinhwang91/promise-async"] = {},
    ["kevinhwang91/nvim-ufo"] = {after = "promise-async"},
    -- ["petertriho/nvim-scrollbar"] = {
    --     config = function() require "configs.scrollbar" end
    -- },
    ["catppuccin/nvim"] = {
        as = "catppuccin",
        config = function() require "user.plugins.catppuccin" end
    },
    ["akinsho/bufferline.nvim"] = {disable = true}
    -- ["gelguy/wilder.nvim"] = [config = function() require "configs.wilder" end],
    -- ["j-hui/fidget.nvim"],
    -- ["folke/lua-dev.nvim"],
    -- ["AckslD/nvim-neoclip.lua"],
    -- ["sudormrfbin/cheatsheet.nvim"],
    -- ["ggandor/lightspeed.nvim"],
    -- ["yamatsum/nvim-cursorline"],
    -- ["ziontee113/syntax-tree-surfer"],
}
