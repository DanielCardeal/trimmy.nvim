---@class UserConfig
local UserConfig = {
    --- Automatic setup trimming before saving the file
    trimOnSave = true,
    --- Filetypes to configure automatic trimming
    pattern = { "*" },
}

--[[###########################################################################
                           PRIVATE FUNCTIONS
##############################################################################]]

---Checks if user options table contains only valid configuration keys. If a
---invalid configuration key is found, return it, otherwise, returns `nil`.
---@param opts table
---@return string?
local function validateOptKeys(opts)
    for opt, _ in pairs(opts) do
        if not UserConfig[opt] then
            return opt
        end
    end
end

--[[###########################################################################
                            PUBLIC FUNCTIONS
##############################################################################]]

---Create UserConfig object based on user passed options.
---@param opts table
---@return UserConfig
function UserConfig:from(opts)
    opts = opts or {}
    local badOpt = validateOptKeys(opts)
    if badOpt then
        local errMsg = string.format(
            "TRIMMY: Invalid option '%s'.",
            badOpt
        )
        vim.notify(errMsg, vim.log.levels.ERROR)
    end

    local obj = opts
    setmetatable(obj, { __index = self })
    return obj
end

return UserConfig
