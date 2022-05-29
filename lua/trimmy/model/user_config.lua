---@class UserConfig
local UserConfig = {
    --- Automatic setup trimming before saving the file
    trimOnSave = true,
    --- Filetypes to configure automatic trimming
    pattern = { "*" },
}

--[[###########################################################################
                            PUBLIC FUNCTIONS
##############################################################################]]
---Create UserConfig object based on user passed options.
---@param opts table
---@return UserConfig
function UserConfig:from(opts)
    local obj = opts or {}
    setmetatable(obj, { __index = self })
    return obj
end

return UserConfig
