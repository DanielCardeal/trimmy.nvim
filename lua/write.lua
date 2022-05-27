local write = {}

---Replaces the block of `block_size` lines starting at `line_start` of the
---current buffer with the contents of the `replacement` list. The `replacement`
---list is a list of lines.
---
---Indexing is zero-based and delta has to be >= 0.
---@param line_start number
---@param block_size number
---@param replacement table
---@return nil
function write.buffer_block(line_start, block_size, replacement)
    block_size = (block_size >= 0) and block_size or 0
    local line_end = line_start + block_size
    return vim.api.nvim_buf_set_lines(
        0,
        line_start,
        line_end,
        false,
        replacement
    )
end

return write
