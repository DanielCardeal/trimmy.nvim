local read = {}

---Read all content of current buffer to a lua string.
---@return string
function read.all_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    return table.concat(lines, "\n")
end

---Gets a block of `block_size` lines starting at `line_start` from the current
---buffer.
---
---Indexing is zero-based and delta has to be >= 0.
---@param line_start number
---@param block_size number
---@return table
function read.buffer_block(line_start, block_size)
    block_size = (block_size >= 0) and block_size or 0
    local line_end = line_start + block_size
    return vim.api.nvim_buf_get_lines(
        0,
        line_start,
        line_end,
        false
    )
end

---Read last saved version of current file to a lua string.
---@return nil
function read.saved_file()
    local filename = vim.api.nvim_buf_get_name(0)
    local file = io.open(filename, "rb")
    if not file then return nil end
    local text = file:read("a")
    file:close()
    return text
end

return read
