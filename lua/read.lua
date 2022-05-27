local read = {}

---Read all content of current buffer to a lua string.
---@return string
function read.all_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    return table.concat(lines, "\n")
end

---Read last saved version of current file to a lua string.
---@return nil
function read.saved_file()
    local filename = vim.api.nvim_buf_get_name(0)
    local file = io.open(filename, "r")
    if not file then return nil end
    local text = file:read("a")
    file:close()
    return text
end

return read
