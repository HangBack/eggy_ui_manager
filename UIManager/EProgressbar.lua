---@class UIManager.EProgressbar : UIManager.ENode
---@field __name "UIManager.EProgressbar"
---@field value integer 进度值
---@field max_value integer 最大进度值
---@field min_value integer 最小进度值
---@field transition_time Fixed 样式变化时间
---@field protected _value integer 进度值
---@field protected _max_value integer 最大进度值
---@field protected _min_value integer 最小进度值
---@field protected _transition_time Fixed 受保护的样式变化时间
local EProgressbar = Class("UIManager.EProgressbar", UIManager.ENode)
local allroles = UIManager.allroles

---@param _node ENode
---@param _name string
function EProgressbar:init(_node, _name)
    UIManager.ENode.init(self, _node, _name)
    self._text = ""
end

function EProgressbar:__get_value()
    return self._value
end

function EProgressbar:__set_value(value)
    self._value = value
    self:__update_value()
end

-- 更新进度值
function EProgressbar:__update_value()
    if self.client_role then
        self.client_role.set_progressbar_transition(self._id, self._value, self._transition_time)
    else
        for _, role in ipairs(allroles) do
            role.set_progressbar_transition(self._id, self._value, self._transition_time)
        end
    end
end

function EProgressbar:__get_max_value()
    return self._max_value
end

function EProgressbar:__set_max_value(value)
    self._max_value = value
    self:__update_max_value()
end

-- 更新最大进度值
function EProgressbar:__update_max_value()
    if self.client_role then
        self.client_role.set_progressbar_max(self._id, self._max_value)
    else
        for _, role in ipairs(allroles) do
            role.set_progressbar_max(self._id, self._max_value)
        end
    end
end

function EProgressbar:__get_min_value()
    return self._min_value
end

function EProgressbar:__set_min_value(value)
    self._min_value = value
    self:__update_min_value()
end

-- 更新最小进度值
function EProgressbar:__update_min_value()
    if self.client_role then
        self.client_role.set_progressbar_min(self._id, self._min_value)
    else
        for _, role in ipairs(allroles) do
            role.set_progressbar_min(self._id, self._min_value)
        end
    end
end

function EProgressbar:__get_transition_time()
    return self._transition_time
end

function EProgressbar:__set_transition_time(value)
    self._transition_time = value
end

return EProgressbar
