local view = {}

---Setup autocommands and user commands based on user options.
---@param trimBuffer function
---@param userConfig UserConfig
function view.init(trimBuffer, userConfig)
    -- Setup user command
    vim.api.nvim_create_user_command(
        "Trimmy",
        function()
            local bufnr = vim.call('bufnr')
            trimBuffer(bufnr)
        end,
        {}
    )

    local enabled = false
    local autocmdId = nil
    local trimmyGroup = vim.api.nvim_create_augroup("TrimmyGroup", {})

    -- Setup startup trim on save
    if userConfig.trimOnSave then
        autocmdId = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group = trimmyGroup,
            pattern = userConfig.pattern,
            callback = function()
                local bufnr = vim.call('bufnr')
                trimBuffer(bufnr)
            end
        })
        enabled = true
    end

    -- Setup trimOnSave toggling
    local toggleTrimOnSave = function()
        if not enabled then
            autocmdId = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                group = trimmyGroup,
                pattern = userConfig.pattern,
                callback = function()
                    local bufnr = vim.call('bufnr')
                    trimBuffer(bufnr)
                end
            })
            enabled = true
            vim.notify('Enabled trim-on-save.', vim.log.levels.INFO)
        else
            vim.api.nvim_del_autocmd(autocmdId)
            enabled = false
            vim.notify('Disabled trim-on-save.', vim.log.levels.INFO)
        end
    end

    vim.api.nvim_create_user_command(
        "TrimmyToggleTrimOnSave",
        toggleTrimOnSave,
        {}
    )
end

return view
