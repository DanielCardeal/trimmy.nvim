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

    -- Trim on save
    if not userConfig.trimOnSave then
        return
    end

    local trimmyGroup = vim.api.nvim_create_augroup("TrimmyGroup", {})
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = trimmyGroup,
        pattern = userConfig.pattern,
        callback = function()
            local bufnr = vim.call('bufnr')
            trimBuffer(bufnr)
        end
    })
end

return view
