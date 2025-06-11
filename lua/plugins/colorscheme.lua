return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "storm", -- or storm/day/moon/night
            transparent = false,
        })
        vim.cmd("colorscheme tokyonight")
    end,
}
