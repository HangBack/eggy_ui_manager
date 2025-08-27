---@class UIManager.ENode : Class
---@field __name "UIManager.ENode"
---@field id ENode ID值 - 只读
---@field name string UI名称 - 只读
---@field parent UIManager.ENode? 父亲节点 - 只读
---@field children ArrayReadOnly<UIManager.ENode> 子节点列表 - 只读
---@field client_role Role? 客户端玩家
---@field visible boolean 是否可见
---@field disabled boolean 是否禁用
---@field protected _id ENode 受保护的id值
---@field protected _name string 受保护的UI名称
---@field protected _parent UIManager.ENode 受保护的父亲节点
---@field protected _children Array<UIManager.ENode> 受保护的子节点列表
---@field protected _client_role Role? 受保护的客户端玩家
---@field protected _visible boolean 受保护的是否可见
---@field protected _disabled boolean 受保护的是否禁用
---@field new fun(self: UIManager.ENode, _node: ENode, _name: string)
local ENode = Class("UIManager.ENode")
local nodes_list = UIManager.nodes_list
local allroles = UIManager.allroles

local event_handlers = UIManager.event_handlers

---@param _node ENode
---@param _name string
function ENode:init(_node, _name)
    if nodes_list[_node] then
        nodes_list[_node] = nil
    end
    nodes_list[_node] = self
    self._name = _name
    self._parent = nil
    self._id = _node

    local array = UIManager.Array:new() --[[@as Array<UIManager.ENode>]]
    self._children = array
    self._read_only_children = UIManager.ArrayReadOnly:new(array)
end

function ENode:__init_children()
    for idx, node in ipairs(GameAPI.get_eui_children(self.id)) do
        local uinode = nodes_list[node] --[[@as UIManager.ENode]]
        uinode._parent = self
        self._children:append(uinode)
    end
end

function ENode:__get_children()
    return self._read_only_children
end

function ENode:__set_children(value)
    warn(("attempt to set a read-only value field 'children' of '%s'"):format(self.__name))
end

function ENode:__get_parent()
    return self._parent
end

function ENode:__set_parent(value)
    warn(("attempt to set a read-only value field 'parent' of '%s'"):format(self.__name))
end

function ENode:__get_name()
    return self._name
end

function ENode:__set_name(value)
    warn(("attempt to set a read-only value field 'name' of '%s'"):format(self.__name))
end

function ENode:__get_id()
    return self._id
end

function ENode:__set_id(value)
    warn(("attempt to set a read-only value field 'id' of '%s'"):format(self.__name))
end

function ENode:__get_client_role()
    return self._client_role
end

function ENode:__set_client_role(value)
    self._client_role = value
end

function ENode:__get_visible()
    return self._visible
end

function ENode:__set_visible(value)
    self._visible = value
    self:__update_visible()
end

function ENode:__update_visible()
    if self.client_role then
        self.client_role.set_node_visible(self._id, self._visible)
    else
        for _, role in ipairs(allroles) do
            role.set_node_visible(self._id, self._visible)
        end
    end
end

function ENode:__get_disabled()
    return self._disabled
end

function ENode:__set_disabled(value)
    self._disabled = value
    self:__update_disabled()
end

function ENode:__update_disabled()
    if self.client_role then
        self.client_role.set_node_touch_enabled(self._id, not self._disabled)
    else
        for _, role in ipairs(allroles) do
            role.set_node_touch_enabled(self._id, not self._disabled)
        end
    end
end

function ENode:query_nodes_by_name()
    
end

---@param _event string
---@param _callback fun(data: {role: Role, target: UIManager.ENode, listener: UIManager.Listener})
---@return UIManager.Listener
function ENode:listen(_event, _callback)
    local listener = UIManager.Listener:new()
    local handler = event_handlers[_event]
    local trigger
    if not handler then
        event_handlers[_event] = {}
        handler = event_handlers[_event]
        
        ---@param data {eui_node_id: ENode, role: Role}
        trigger = LuaAPI.global_register_custom_event(_event, function(_, _, data)
            local handler_data = event_handlers[_event][data.eui_node_id]
            if handler_data and handler_data.callbacks and not handler_data.node._disabled then
                handler_data.node.client_role = data.role
                for _, callback in ipairs(handler_data.callbacks) do
                    callback({
                        role = data.role,
                        target = handler_data.node,
                        listener = listener
                    })
                end
                handler_data.node.client_role = nil
            end
        end)
        handler.trigger = trigger
    end
    
    local handler_data = handler[self._id]
    if not handler_data then
        handler[self._id] = {
            callbacks = { _callback },
            node = self
        }
    else
        table.insert(handler_data.callbacks, _callback)
    end
    
    -- 设置 listener 的相关信息，用于后续删除
    listener._event = _event
    listener._callback = _callback
    listener._node_id = self._id
    
    return listener
end

return ENode
