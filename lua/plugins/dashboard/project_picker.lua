local M = {}

function M.open_project_picker()
    local Path = require("plenary.path")
    local scan = require("plenary.scandir")
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local base_dir = os.getenv("FOLDER_WITH_ALL_REPOS") 
    local folders = scan.scan_dir(base_dir, { only_dirs = true, depth = 1 })
    local entries = { "[ New Project]" }

    for _, folder in ipairs(folders) do
        table.insert(entries, Path:new(folder):make_relative(base_dir))
    end

    require('telescope.pickers')
        .new({}, {
            prompt_title = ' Open Or Create a Project',
            finder = require('telescope.finders').new_table({
                results = entries
            }),
            sorter = require('telescope.config').values.generic_sorter({}),
            attach_mappings = function(_, map)
                map('i', '<CR>', function(prompt_bufnr)
                    local selection = action_state.get_selected_entry()[1]
                    actions.close(prompt_bufnr)

                    if selection == "[ New Project]" then
                        vim.ui.input({ prompt = " Enter new project folder name: " }, function(input)
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

return M
