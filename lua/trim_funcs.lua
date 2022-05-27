local trim_funcs = {}

---Remove trailing whitespace of `line`.
---@param line string
---@return string
function trim_funcs.trim_line(line)
    line = line or ""
    return line:gsub("%s+$", "")
end

return trim_funcs
