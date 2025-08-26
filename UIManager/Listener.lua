---@class UIManager.Listener : Class
---@field handler integer 句柄
---@field protected _handler integer 受保护的句柄
local Listener = Class("UIManager.Listener")

function Listener:init() end

function Listener:destroy()
    LuaAPI.global_unregister_custom_event(self._handler)
    self._handler = nil
end

function Listener:__get_handler()
    return self._handler
end

function Listener:__set_handler(value)
    self._handler = value
end

return Listener