local config_path = vim.fn.stdpath("config") .. "/config.json"
local config_file = io.open(config_path, "r")
assert(config_file, "config.json not found at " .. config_path)
local config_content = config_file:read("*a")
config_file:close()
local config = vim.fn.json_decode(config_content)
local AsciiTextc = config.dashboardAsciiArt

return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('dashboard').setup({
            theme = 'hyper',
            config = {
                header = vim.fn.readfile(vim.fn.stdpath('config') .. AsciiTextc),
                shortcut = {
                    {
                        icon = '󰥨 ',
                        desc = 'Open Projects',
                        group = '@property',
                        action = require('plugins.dashboard.project_picker').open_project_picker,
                        key = 'o',
                    }
                },
                footer = { 'Hey? what you looking here? get to grinding!' },
                disable_move = true,
                week_header = { enable = false },
                packages = { enable = false },
                project = { enable = true, limit = 3 },
                mru = { enable = false },
            },
        })
    end
}
