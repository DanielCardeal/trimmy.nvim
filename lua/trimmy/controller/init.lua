local view = require('trimmy.view')
local Diff = require('trimmy.model.diff')

--[[###########################################################################
                            PRIVATE FUNCTIONS
##############################################################################]]

---Trim changes in buffer `buffnr`.
---@param bufnr number
local function trimBuffer(bufnr)
    local diff = Diff:new(bufnr)
    diff:update()
    diff:write()
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