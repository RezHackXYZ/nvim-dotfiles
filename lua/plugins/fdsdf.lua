require('telescope').setup({
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            preview_width = 0.6,
        },
        sorting_strategy = 'ascending',
        winblend = 10,
    },
    extensions = {
        file_browser = {
            hijack_netrw = true,
            grouped = true,
            previewer = true,
        },
    }
})

require('telescope').load_extension('file_browser')


vim.keymap.set('n', '<C-e>', function()
    require('telescope').extensions.file_browser.file_browser({
        path = vim.fn.expand('%:p:h'),
        previewer = true,
        layout_config = {
            height = 0.9,
            width = 0.9,
        },
    })
end)


require('toggleterm').setup({
    direction = 'float',
    start_in_insert = true,
    float_opts = {
        border = 'curved',
        width = 100,
        height = 30,
    },
})

vim.keymap.set('n', '<C-d>', '<cmd>ToggleTerm<CR>')

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })


-- Explicitly declare `vim` as a global variable to ensure it is recognized
_G.vim = _G.vim or {}

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('telescope').setup({
                defaults = {
                    layout_strategy = 'horizontal',
                    layout_config = {
                        preview_width = 0.6,
                    },
                    sorting_strategy = 'ascending',
                    winblend = 10,
                },
                extensions = {
                    file_browser = {
                        hijack_netrw = true,
                        grouped = true,
                        previewer = true,
                    },
                }
            })

            require('telescope').load_extension('file_browser')

            vim.keymap.set('n', '<C-e>', function()
                require('telescope').extensions.file_browser.file_browser({
                    path = vim.fn.expand('%:p:h'),
                    previewer = true,
                    layout_config = {
                        height = 0.9,
                        width = 0.9,
                    },
                })
            end)
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require('toggleterm').setup({
                direction = 'float',
                start_in_insert = true,
                float_opts = {
                    border = 'curved',
                    width = 100,
                    height = 30,
                },
            })

            vim.keymap.set('n', '<C-d>', '<cmd>ToggleTerm<CR>')
            vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })
        end,
    },
}
