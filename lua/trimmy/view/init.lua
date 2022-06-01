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

    -- Setup trimOnSave toggling
    local enabled = false
    local autocmdId = nil
    local trimmyGroup = vim.api.nvim_create_augroup("TrimmyGroup", {})
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
        else
            vim.api.nvim_del_autocmd(autocmdId)
            enabled = false
        end
    end

    vim.api.nvim_create_user_command(
        "TrimmyToggleTrimOnSave",
        toggleTrimOnSave,
        {}
    )

    -- Initialize with trimOnSave enabled
    if userConfig.trimOnSave then
        toggleTrimOnSave()
    end
end

return view
