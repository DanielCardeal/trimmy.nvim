local trimmy = {}
local trim_funcs = require("trim_funcs")
local read = require("read")
local write = require("write")

---Trim lines of a given `diff_hunk`.
---
---The table `diff_hunk` must be constructed on the same way as the return of
---the `vim.diff` function.
---@param diff_hunk table
---@return nil
local function trim_diff_hunk(diff_hunk)
    if (not diff_hunk) or (not diff_hunk[3]) or (not diff_hunk[4]) then
        return
    end
    -- We need to coorect both line_start and block_size since diff hunks use
    -- one-based indexing and inclusive-end.
    local line_start = diff_hunk[3] - 1
    local block_size = diff_hunk[4]
    local block = read.buffer_block(line_start, block_size)

    local trimmed_block = trim_funcs.trim_block(block)

    write.buffer_block(line_start, block_size, trimmed_block)
end

--[[##########################################################
                        PUBLIC API
--###########################################################]]

---Trims whitespace of changed lines in the current buffer.
---@return nil
function trimmy.trim_diffed_whitespace()
    local saved = read.saved_file()
    local buffer = read.all_buffer()
    local hunks = vim.diff(saved, buffer, { result_type = "indices" })

    -- No changes, nothing to do
    if #hunks == 0 then return end

    for _, hunk in ipairs(hunks) do
        trim_diff_hunk(hunk)
    end
end

--- Default options for user configuration.
local DEFAULT_OPTS = {
    --- Whether to set up auto-trimming or not.
    trim_on_save = true,
    --- Filetypes to configure trim on save.
    patterns = { "*" },
}

--- Create user command for on-demand trimming.
--- @param opts table
--- @return nil
local function setup_cmd(opts)
    vim.api.nvim_create_user_command(
        "Trimmy",
        trimmy.trim_diffed_whitespace,
        {}
    )
end

--- Create autocommand for pre save trimming of buffer.
--- @param opts table
--- @return nil
local function setup_autocmd(opts)
    local group = vim.api.nvim_create_augroup("TrimmyGroup", {})
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = opts.patterns,
        callback = trimmy.trim_diffed_whitespace,
        group = group,
    })
end

--- Setup trimmy based on user preferences.
--- @param opts table
--- @return nil
function trimmy.setup(opts)
    -- Safely recover user options
    opts = opts or {}
    setmetatable(opts, { __index = DEFAULT_OPTS })
    setup_cmd(opts)
    if opts.trim_on_save then
        setup_autocmd(opts)
    end
end

return trimmy
