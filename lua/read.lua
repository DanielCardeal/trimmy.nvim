local read = {}

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
