return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('dashboard').setup({
            theme = 'hyper',
            config = {
                header = (function()
                    local ok, content = pcall(function()
                        return vim.fn.readfile(vim.fn.stdpath('config') .. '/lua/plugins/dashboard/headerAscii.txt')
                    end)
                    return ok and content or { 'Error loading header' }
                end)(),
                shortcut = {
                    {
                        icon = ' ',
                        desc = 'Open Projects',
                        action = require('plugins.dashboard.project_picker').open_project_picker,
                        key = 'o',
                    }
                },
                footer = { 'What you cooking today?' },
                disable_move = true,
                week_header = { enable = false },
                packages = { enable = false },
                project = { enable = true, limit = 3 },
                mru = { enable = false },
            },
        })
    end
}
