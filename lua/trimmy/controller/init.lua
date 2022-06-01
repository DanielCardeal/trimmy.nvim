local view = require('trimmy.view')
local Trimmer = require('trimmy.model.trimmer')

--[[###########################################################################
                            PRIVATE FUNCTIONS
##############################################################################]]

---Trim changes in buffer `buffnr`.
---@param bufnr number
local function trimBuffer(bufnr)
    local trimmer = Trimmer:new(bufnr)
    trimmer:trim()
end

--[[###########################################################################
                            PUBLIC API
##############################################################################]]

local controller = {}

---Initialize trimmy controller for the given user options.
---@param opts UserConfig
function controller.setup(opts)
    view.init(trimBuffer, opts)
end

return controller
