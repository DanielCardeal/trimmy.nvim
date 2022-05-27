local trim_funcs = {}

---Remove trailing whitespace of `line`.
---@param line string
---@return string
function trim_funcs.trim_line(line)
    line = line or ""
    return line:gsub("%s+$", "")
end

---Remove trailing whitespace from a block of lines. A block of lines is a list
---of lines
---@param block table
---@return table
function trim_funcs.trim_block(block)
    block = block or {}
    local result_block = {}
    for i, line in ipairs(block) do
        result_block[i] = trim_funcs.trim_line(line)
    end
    return result_block
end

return trim_funcs
