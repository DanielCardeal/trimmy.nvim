---@class Trimmer
local Trimmer = {
    bufnr = 0,
    bufname = "",
    changeList = {},
}

--[[###########################################################################
                            PRIVATE FUNCTIONS
##############################################################################]]

---Read all content of buffer `bufnr`.
---@param bufnr number
---@return string
local function readAllBuffer(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    return table.concat(lines, "\n")
end

---Read last saved version of `filepath` file
---
---If there is no saved version of the file, returns an empty string.
---@param filepath string
---@return string
local function readSavedFile(filepath)
    local file = io.open(filepath, "rb")
    if not file then return "" end
    local text = file:read("a")
    file:close()
    return text:sub(1, text:len() - 1)
end

---Gets a block of `block_size` lines starting at `line_start` from the buffer
---`bufnr`.
---
---Indexing is zero-based and delta has to be >= 0.
---@param bufnr number
---@param lineStart number
---@param blockSize number
---@return table
local function readBufferBlock(bufnr, lineStart, blockSize)
    blockSize = (blockSize >= 0) and blockSize or 0
    local line_end = lineStart + blockSize
    return vim.api.nvim_buf_get_lines(
        bufnr,
        lineStart,
        line_end,
        false
    )
end

---Replaces the block of `block_size` lines starting at `line_start` of the
---buffer `bufnr` with the contents of the `replacement` list. The `replacement`
---list is a list of lines.
---
---Indexing is zero-based and delta has to be >= 0.
---@param bufnr number
---@param lineStart number
---@param blockSize number
---@param replacement table
---@return nil
local function writeBufferBlock(bufnr, lineStart, blockSize, replacement)
    blockSize = (blockSize >= 0) and blockSize or 0
    local line_end = lineStart + blockSize
    return vim.api.nvim_buf_set_lines(
        bufnr,
        lineStart,
        line_end,
        false,
        replacement
    )
end

---Remove trailing whitespace from a block of lines. A block of lines is a list
---of lines.
---@param block table
---@return table
local function cleanBlock(block)
    block = block or {}
    local result_block = {}
    for i, line in ipairs(block) do
        line = line or ""
        result_block[i] = line:gsub("%s+$", "")
    end
    return result_block
end

--[[###########################################################################
                            PUBLIC FUNCTIONS
##############################################################################]]

---Create a trimmer for the buffer `bufnr`.
---@return Trimmer
function Trimmer:new(bufnr)
    local obj = {}
    setmetatable(obj, { __index = self })
    obj.bufnr = bufnr
    obj.bufname = vim.api.nvim_buf_get_name(bufnr)
    return obj
end

---Update objects `changeList` based on the difference between buffer contents
---and saved file.
function Trimmer:update()
    local bufContents = readAllBuffer(self.bufnr)
    local fileContents = readSavedFile(self.bufname)
    self.changeList = vim.diff(
        fileContents,
        bufContents,
        { result_type = "indices" }
    )
end

---Detect and trim changes from the buffer.
function Trimmer:trim()
    self:update()
    if #self.changeList == 0 then return end
    for _, changeBlock in ipairs(self.changeList) do
        local lineStart = changeBlock[3] - 1
        local blockSize = changeBlock[4]
        local bufBlock = readBufferBlock(self.bufnr, lineStart, blockSize)
        writeBufferBlock(self.bufnr, lineStart, blockSize, cleanBlock(bufBlock))
    end
end

return Trimmer
