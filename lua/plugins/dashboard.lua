local function open_project_picker()
    local Path = require("plenary.path")
    local scan = require("plenary.scandir")
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local base_dir = vim.fn.expand("~/Documents/repos/")
    local folders = scan.scan_dir(base_dir, { only_dirs = true, depth = 1 })
    local entries = { "[+ New Project]" }

    for _, folder in ipairs(folders) do
        table.insert(entries, Path:new(folder):make_relative(base_dir))
    end

    require('telescope.pickers')
        .new({}, {
            prompt_title = 'Open Or Create a Project',
            finder = require('telescope.finders').new_table({
                results = entries
            }),
            sorter = require('telescope.config').values.generic_sorter({}),
            attach_mappings = function(_, map)
                map('i', '<CR>', function(prompt_bufnr)
                    local selection = action_state.get_selected_entry()[1]
                    actions.close(prompt_bufnr)

                    if selection == "[+ New Project]" then
                        vim.ui.input({ prompt = "Enter new project folder name: " }, function(input)
                            if input and input ~= "" then
                                local new_path = base_dir .. input
                                vim.fn.mkdir(new_path, "p")
                                vim.cmd('cd ' .. new_path)
                                vim.cmd('Neotree') -- or Telescope find_files
                            end
                        end)
                    else
                        local full_path = base_dir .. selection
                        vim.cmd('cd ' .. full_path)
                        vim.cmd('Neotree')
                    end
                end)
                return true
            end,
        })
        :find()
end


return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('dashboard').setup({
            theme = 'hyper',
            config = {
                header = {
                    'Welcome back,',
                    '|  __ \\        | |  | |          | |   \\ \\ / /\\ \\   / /___  /',
                    '| |__) |___ ___| |__| | __ _  ___| | __ \\ V /  \\ \\_/ /   / / ',
                    '|  _  // _ \\_  /  __  |/ _` |/ __| |/ /  > <    \\   /   / /  ',
                    '| | \\ \\  __// /| |  | | (_| | (__|   <  / . \\    | |   / /__ ',
                    '|_|  \\_\\___/___|_|  |_|\\__,_|\\___|_|\\_\\/_/ \\_\\   |_|  /_____|',
                    'to',
                    '    | \\ | |       \\ \\    / (_)               ',
                    '    |  \\| | ___  __\\ \\  / / _ _ __ ___       ',
                    '    | . ` |/ _ \\/ _ \\ \\/ / | | \'_ ` _ \\      ',
                    '    | |\\  |  __/ (_) \\  /  | | | | | | |     ',
                    '    |_| \\_|\\___|\\___/ \\/   |_|_| |_| |_ |    ',
                    ''
                },
                shortcut = {
                    {
                        icon = '󰥨 ',
                        desc = 'Open Projects',
                        group = '@property',
                        action = open_project_picker,
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
