local M = {}

function M.open_project_picker()
    local Path = require("plenary.path")
    local scan = require("plenary.scandir")
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local config_path = vim.fn.stdpath("config") .. "/config.json"
    local config_file = io.open(config_path, "r")
    assert(config_file, "config.json not found at " .. config_path)
    local config_content = config_file:read("*a")
    config_file:close()
    local config = vim.fn.json_decode(config_content)
    local base_dir = vim.fn.expand(config.reposDirectory)
    assert(base_dir, "reposDirectory not set in config.json")

    -- Ensure base_dir ends with a slash
    if not base_dir:match("/$") then
        base_dir = base_dir .. "/"
    end

    local folders = scan.scan_dir(base_dir, { only_dirs = true, depth = 1 })
    if #folders == 0 then
        vim.notify("No projects found in " .. base_dir, vim.log.levels.WARN)
    end

    local entries = { "[+ New Project]" }

    for _, folder in ipairs(folders) do
        -- Get the folder name only, not the full path
        local folder_name = Path:new(folder):make_relative(base_dir)
        table.insert(entries, folder_name)
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
                                vim.cmd('cd ' .. full_path)
                                require('telescope').extensions.file_browser.file_browser({
                                    path = full_path,
                                    previewer = true,
                                    layout_config = {
                                        height = 0.9,
                                        width = 0.9,
                                    },
                                })
                            end
                        end)
                    else
                        local full_path = base_dir .. selection
                        vim.cmd('cd ' .. full_path)
                        require('telescope').extensions.file_browser.file_browser({
                            path = full_path,
                            previewer = true,
                            layout_config = {
                                height = 0.9,
                                width = 0.9,
                            },
                        })
                    end
                end)
                return true
            end,
        })
        :find()
end

return M
