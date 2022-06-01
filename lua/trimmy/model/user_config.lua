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
    local badOpt = validateOptKeys(opts)
    if badOpt then
        local err = string.format(
            "Trimmy: Invalid option '%s'. Available options are 'trimOnSave' and 'pattern'.",
            badOpt
        )
        error(err)
    end

    local obj = opts or {}
    setmetatable(obj, { __index = self })
    return obj
end

return UserConfig
