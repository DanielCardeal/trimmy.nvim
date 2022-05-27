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

return trimmy
