local trimmy = {}

local controller = require('trimmy.controller')
local UserConfig = require('trimmy.model.user_config')

--- Setup trimmy based on user preferences.
--- @param opts table
--- @return nil
function trimmy.setup(opts)
    local userConfig = UserConfig:from(opts)
    controller.setup(userConfig)
end

return trimmy
